import 'dart:async';
import 'package:black_board_mobile/src/rust/api.dart';
import 'package:black_board_mobile/src/rust/bridge_models.dart' as rust;
import 'package:black_board_mobile/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'src/generated/communication.pb.dart' as proto;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const MyApp());
}

const uuid = Uuid();
// ignore: invalid_use_of_internal_member
final api = RustLib.instance.api;

// مدل داده برای نگهداری یک مسیر نقاشی در UI
class DrawingPath {
  final String id;
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawingPath({
    required this.id,
    required this.points,
    this.color = Colors.black,
    this.strokeWidth = 4.0,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackboard Client',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _serverAddrController = TextEditingController(text: '127.0.0.1:12345');
  final _usernameController = TextEditingController(text: 'FlutterUser');
  final _roomIdController = TextEditingController();

  String? _roomId;
  bool _isConnected = false;
  StreamSubscription<rust.EventMessage>? _eventSubscription;

  Map<String, DrawingPath> _paths = {};
  String? _currentPathId;

  @override
  void dispose() {
    _disconnect();
    _serverAddrController.dispose();
    _usernameController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  void _setupStreamListener() {
    _eventSubscription?.cancel();
    final stream = listenEvents();
    _eventSubscription = stream.listen(
      (event) {
        try {
          //解析 کردن بایت‌های خام Protobuf
          final roomEvent = proto.RoomEvent.fromBuffer(event.data);

          if (roomEvent.hasCanvasCommand()) {
            final command = roomEvent.canvasCommand.command;
            if (mounted) {
              setState(() {
                // *** مدیریت رویدادهای ساختاریافته جدید ***
                if (command.hasPathStart()) {
                  final pathStart = command.pathStart;
                  _paths[pathStart.id] = DrawingPath(
                    id: pathStart.id,
                    points: [Offset(pathStart.point.dx, pathStart.point.dy)],
                    color: Color(pathStart.color),
                    strokeWidth: pathStart.strokeWidth,
                  );
                } else if (command.hasPathAppend()) {
                  final pathAppend = command.pathAppend;
                  if (_paths.containsKey(pathAppend.id)) {
                    _paths[pathAppend.id]!.points.add(
                          Offset(pathAppend.point.dx, pathAppend.point.dy),
                        );
                  }
                } else if (command.hasPathFull()) {
                  // این برای همگام‌سازی تاریخچه است
                  final pathFull = command.pathFull;
                  _paths[pathFull.id] = DrawingPath(
                    id: pathFull.id,
                    points: pathFull.points
                        .map((p) => Offset(p.dx, p.dy))
                        .toList(),
                    color: Color(pathFull.color),
                    strokeWidth: pathFull.strokeWidth,
                  );
                }
              });
            }
          }
        } catch (e) {
          debugPrint("Failed to parse event: $e");
        }
      },
      onError: (e) => _showErrorDialog(e.toString()),
      onDone: _disconnect,
    );
  }

  void _createRoom() async {
    if (_isConnected) return;
    try {
      final createdRoomId = await createRoom(
        serverAddr: _serverAddrController.text,
        username: _usernameController.text,
      );
      if (mounted) {
        setState(() {
          _isConnected = true;
          _roomId = createdRoomId;
          _roomIdController.text = createdRoomId;
        });
      }
      _setupStreamListener();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _joinRoom() async {
    if (_isConnected || _roomIdController.text.isEmpty) return;
    try {
      await joinRoom(
        serverAddr: _serverAddrController.text,
        username: _usernameController.text,
        roomId: _roomIdController.text,
      );
      if (mounted) {
        setState(() {
          _isConnected = true;
          _roomId = _roomIdController.text;
        });
      }
      _setupStreamListener();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _disconnect() {
    if (!_isConnected) return;
    _eventSubscription?.cancel();
    _eventSubscription = null;
    disconnect();
    if (mounted) {
      setState(() {
        _isConnected = false;
        _roomId = null;
        _paths = {};
      });
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (!_isConnected) return;
    setState(() {
      _currentPathId = uuid.v4();
      final newPath = DrawingPath(
        id: _currentPathId!,
        points: [details.localPosition],
        // شما می‌توانید رنگ و ضخامت را از UI انتخاب کنید
        color: Colors.amber,
        strokeWidth: 5.0,
      );
      _paths[_currentPathId!] = newPath;
      
      // *** ارسال رویداد ساختاریافته PathStart ***
      startPath(
        id: newPath.id,
        point: rust.Point(dx: newPath.points.first.dx, dy: newPath.points.first.dy),
        color: newPath.color.value,
        strokeWidth: newPath.strokeWidth,
      );
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentPathId == null || _paths[_currentPathId] == null) return;
    setState(() {
      _paths[_currentPathId]!.points.add(details.localPosition);
    });
    
    // *** ارسال رویداد ساختاریافته PathAppend ***
    appendToPath(
      id: _currentPathId!,
      point: rust.Point(dx: details.localPosition.dx, dy: details.localPosition.dy),
    );
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentPathId == null || _paths[_currentPathId] == null) return;
    
    // *** ارسال رویداد ساختاریافته PathFull برای ذخیره در تاریخچه ***
    final finishedPath = _paths[_currentPathId]!;
    finishPath(
      id: finishedPath.id,
      points: finishedPath.points.map((p) => rust.Point(dx: p.dx, dy: p.dy)).toList(),
      color: finishedPath.color.value,
      strokeWidth: finishedPath.strokeWidth,
    );

    _currentPathId = null;
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isConnected ? 'Room: $_roomId' : 'Blackboard Client'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          ExpansionTile(
            title: const Text('Connection Settings'),
            initiallyExpanded: !_isConnected,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _serverAddrController,
                      decoration: const InputDecoration(labelText: 'Server Address'),
                      enabled: !_isConnected,
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      enabled: !_isConnected,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _roomIdController,
                            decoration: const InputDecoration(labelText: 'Room ID'),
                            enabled: !_isConnected,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isConnected ? null : _joinRoom,
                          child: const Text('Join'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                          onPressed: _isConnected ? null : _createRoom,
                          child: const Text('Create Room'),
                        ),
                        FilledButton.tonal(
                          onPressed: _isConnected ? _disconnect : null,
                          child: const Text('Disconnect'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomPaint(
                    painter: DrawingPainter(paths: _paths.values.toList()),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPath> paths;

  DrawingPainter({required this.paths});

  @override
  void paint(Canvas canvas, Size size) {
    for (var pathData in paths) {
      final paint = Paint()
        ..color = pathData.color
        ..strokeWidth = pathData.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (pathData.points.length < 2) continue;

      final path = Path();
      path.moveTo(pathData.points.first.dx, pathData.points.first.dy);
      for (var i = 1; i < pathData.points.length; i++) {
        path.lineTo(pathData.points[i].dx, pathData.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
