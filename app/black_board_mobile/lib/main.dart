import 'dart:async';
import 'dart:convert';
import 'package:black_board_mobile/src/rust/api.dart';
import 'package:black_board_mobile/src/rust/bridge_models.dart';
import 'package:black_board_mobile/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const MyApp());
}

const uuid = Uuid();

// مدل داده برای نگهداری یک مسیر نقاشی
class DrawingPath {
  // *** اضافه شدن شناسه منحصر به فرد برای هر مسیر ***
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

  DrawingPath copyWith({List<Offset>? points}) {
    return DrawingPath(
      id: id,
      points: points ?? this.points,
      color: color,
      strokeWidth: strokeWidth,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points.map((p) => {'dx': p.dx, 'dy': p.dy}).toList(),
      'color': color.value,
      'strokeWidth': strokeWidth,
    };
  }

  factory DrawingPath.fromJson(Map<String, dynamic> json) {
    final pointsList = json['points'] as List? ?? [];
    return DrawingPath(
      id: json['id'] ?? uuid.v4(),
      points: pointsList
          .map(
            (p) =>
                Offset((p['dx'] ?? 0.0) as double, (p['dy'] ?? 0.0) as double),
          )
          .toList(),
      color: Color((json['color'] ?? 0xFF000000) as int),
      strokeWidth: (json['strokeWidth'] ?? 4.0) as double,
    );
  }
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
  StreamSubscription<EventMessage>? _eventSubscription;

  // *** استفاده از Map برای مدیریت بهینه مسیرها ***
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
          final eventJsonString = utf8.decode(event.data);
          final eventData = json.decode(eventJsonString);

          if (eventData['event_type']?['CanvasCommand'] != null) {
            final commandData = eventData['event_type']['CanvasCommand'];
            final commandJsonString = commandData['command']['command_json'];
            final pathData = json.decode(commandJsonString);
            final receivedPath = DrawingPath.fromJson(pathData);

            if (mounted) {
              setState(() {
                // *** بروزرسانی یا اضافه کردن مسیر در Map ***
                _paths[receivedPath.id] = receivedPath;
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
        _paths = {}; // پاک کردن Map
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
      );
      _paths[_currentPathId!] = newPath;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentPathId == null || _paths[_currentPathId] == null) return;
    setState(() {
      final updatedPath = _paths[_currentPathId]!.copyWith(
        points: List.from(_paths[_currentPathId]!.points)
          ..add(details.localPosition),
      );
      _paths[_currentPathId!] = updatedPath;
    });
    // *** ارسال داده در حین حرکت ***
    _sendCurrentPathUpdate();
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentPathId == null) return;
    _sendCurrentPathUpdate(); // ارسال آخرین وضعیت
    _currentPathId = null;
  }

  // تابع کمکی برای ارسال مسیر فعلی به سرور
  void _sendCurrentPathUpdate() {
    if (_currentPathId == null || _paths[_currentPathId] == null) return;
    final pathToSend = _paths[_currentPathId]!;
    final commandJson = json.encode(pathToSend.toJson());
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    sendCanvasCommand(commandJson: commandJson, timestampMs: timestamp);
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
                      decoration: const InputDecoration(
                        labelText: 'Server Address',
                      ),
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
                            decoration: const InputDecoration(
                              labelText: 'Room ID',
                            ),
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
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    // این شرط با الگوی Immutable به درستی کار می‌کند
    return true;
  }
}
