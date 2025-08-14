import 'dart:async';
import 'package:black_board_mobile/src/rust/api.dart';
import 'package:black_board_mobile/src/rust/bridge_models.dart' as rust;
import 'package:black_board_mobile/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

class PathData {
  final String id;
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  PathData({
    required this.id,
    required this.points,
    required this.color,
    required this.strokeWidth,
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
  final _serverAddrController = TextEditingController(text: '107.173.62.153:12345');
  final _usernameController = TextEditingController(text: 'FlutterUser');
  final _roomIdController = TextEditingController();

  String? _roomId;
  bool _isConnected = false;
  StreamSubscription<rust.EventMessage>? _eventSubscription;

  Map<String, PathData> _paths = {};
  String? _currentPathId;

  Color _brushColor = Colors.black;
  Color _backgroundColor = Colors.white;
  double _currentStrokeWidth = 4.0;
  bool _isErasing = false;

  // *** متغیرهای جدید برای لیست جلسات ضبط شده ***
  List<String> _recordings = [];
  bool _isLoadingRecordings = false;
  bool _isReplaying = false;

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
          final roomEvent = proto.RoomEvent.fromBuffer(event.data);
          if (roomEvent.hasCanvasCommand()) {
            final command = roomEvent.canvasCommand.command;
            if (mounted) {
              setState(() {
                if (command.hasPathStart()) {
                  final pathStart = command.pathStart;
                  _paths[pathStart.id] = PathData(
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
                  final pathFull = command.pathFull;
                  _paths[pathFull.id] = PathData(
                    id: pathFull.id,
                    points: pathFull.points.map((p) => Offset(p.dx, p.dy)).toList(),
                    color: Color(pathFull.color),
                    strokeWidth: pathFull.strokeWidth,
                  );
                }
              });
            }
          } else if (roomEvent.hasHostEndedSession()) {
            _showErrorDialog("The host has ended the session.");
            _disconnect();
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
    if (!_isConnected && !_isReplaying) return;
    _eventSubscription?.cancel();
    _eventSubscription = null;
    // فقط در صورتی که اتصال زنده باشد، disconnect را فراخوانی می‌کنیم
    if (_isConnected) {
      disconnect();
    }
    if (mounted) {
      setState(() {
        _isConnected = false;
        _isReplaying = false;
        _roomId = null;
        _paths = {};
      });
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (!_isConnected) return;
    setState(() {
      _currentPathId = uuid.v4();
      final newPath = PathData(
        id: _currentPathId!,
        points: [details.localPosition],
        color: _isErasing ? _backgroundColor : _brushColor,
        strokeWidth: _currentStrokeWidth,
      );
      _paths[_currentPathId!] = newPath;

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

    appendToPath(
      id: _currentPathId!,
      point: rust.Point(dx: details.localPosition.dx, dy: details.localPosition.dy),
    );
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentPathId == null || _paths[_currentPathId] == null) return;

    final finishedPath = _paths[_currentPathId]!;
    finishPath(
      id: finishedPath.id,
      points: finishedPath.points.map((p) => rust.Point(dx: p.dx, dy: p.dy)).toList(),
      color: finishedPath.color.value,
      strokeWidth: finishedPath.strokeWidth,
    );

    _currentPathId = null;
  }

  void _openColorPicker(bool isBackground) {
    Color pickerColor = isBackground ? _backgroundColor : _brushColor;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBackground ? 'Pick Background Color' : 'Pick Brush Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => setState(() => pickerColor = color),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Done'),
            onPressed: () {
              setState(() {
                if (isBackground) {
                  _backgroundColor = pickerColor;
                } else {
                  _brushColor = pickerColor;
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: SelectableText(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // *** توابع جدید برای لیست و بازپخش جلسات ***
  void _fetchRecordings() async {
    setState(() => _isLoadingRecordings = true);
    try {
      final filenames = await listRecordings(serverAddr: _serverAddrController.text);
      if (mounted) {
        setState(() {
          _recordings = filenames;
        });
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoadingRecordings = false);
      }
    }
  }

  void _startReplay(String filename) {
    if (_isConnected || _isReplaying) {
      _showErrorDialog("Please disconnect from the live session first.");
      return;
    }
    setState(() {
      _paths = {}; // پاک کردن بوم برای بازپخش
      _isReplaying = true;
    });

    final stream = replayRoom(
      serverAddr: _serverAddrController.text,
      logFilename: filename,
    );

    _eventSubscription = stream.listen(
          (event) {
        try {
          final roomEvent = proto.RoomEvent.fromBuffer(event.data);
          if (roomEvent.hasCanvasCommand()) {
            final command = roomEvent.canvasCommand.command;
            if (mounted) {
              setState(() {
                if (command.hasPathStart()) {
                  final pathStart = command.pathStart;
                  _paths[pathStart.id] = PathData(
                    id: pathStart.id,
                    points: [Offset(pathStart.point.dx, pathStart.point.dy)],
                    color: Color(pathStart.color),
                    strokeWidth: pathStart.strokeWidth,
                  );
                } else if (command.hasPathAppend()) {
                  final pathAppend = command.pathAppend;
                  if (_paths.containsKey(pathAppend.id)) {
                    _paths[pathAppend.id]!.points.add(Offset(pathAppend.point.dx, pathAppend.point.dy));
                  }
                } else if (command.hasPathFull()) {
                  final pathFull = command.pathFull;
                  _paths[pathFull.id] = PathData(
                    id: pathFull.id,
                    points: pathFull.points.map((p) => Offset(p.dx, p.dy)).toList(),
                    color: Color(pathFull.color),
                    strokeWidth: pathFull.strokeWidth,
                  );
                }
              });
            }
          }
        } catch (e) {
          debugPrint("Failed to parse replay event: $e");
        }
      },
      onError: (e) {
        _showErrorDialog(e.toString());
        _disconnect();
      },
      onDone: () {
        _disconnect();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Replay finished!')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool controlsEnabled = !_isConnected && !_isReplaying;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isReplaying ? 'Replaying Session...' :
            (_isConnected ? 'Room: $_roomId' : 'Blackboard Client')
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.palette, color: Colors.blueGrey),
            tooltip: 'Change Background Color',
            onPressed: () => _openColorPicker(true),
          ),
          IconButton(
            icon: Icon(Icons.brush, color: _isErasing ? Colors.grey : _brushColor),
            tooltip: 'Brush',
            onPressed: () => setState(() => _isErasing = false),
          ),
          IconButton(
            icon: Icon(Icons.cleaning_services, color: _isErasing ? Colors.blue : Colors.grey),
            tooltip: 'Eraser',
            onPressed: () => setState(() => _isErasing = true),
          ),
          IconButton(
            icon: Icon(Icons.color_lens, color: _brushColor),
            tooltip: 'Change Brush Color',
            onPressed: () => _openColorPicker(false),
          ),
        ],
      ),
      body: Column(
        children: [
          ExpansionTile(
            title: const Text('Connection & Sessions'),
            initiallyExpanded: controlsEnabled,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _serverAddrController,
                      decoration: const InputDecoration(labelText: 'Server Address'),
                      enabled: controlsEnabled,
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      enabled: controlsEnabled,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _roomIdController,
                            decoration: const InputDecoration(labelText: 'Room ID'),
                            enabled: controlsEnabled,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: controlsEnabled ? _joinRoom : null,
                          child: const Text('Join'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                          onPressed: controlsEnabled ? _createRoom : null,
                          child: const Text('Create Room'),
                        ),
                        FilledButton.tonal(
                          onPressed: _isConnected ? _disconnect : null,
                          child: const Text('Disconnect'),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Recorded Sessions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _isLoadingRecordings || !controlsEnabled ? null : _fetchRecordings,
                        ),
                      ],
                    ),
                    _isLoadingRecordings
                        ? const Center(child: CircularProgressIndicator())
                        : _recordings.isEmpty
                        ? const Center(child: Text("No recordings found. Press refresh to fetch."))
                        : SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: _recordings.length,
                        itemBuilder: (context, index) {
                          final filename = _recordings[index];
                          return ListTile(
                            title: Text(filename, style: TextStyle(fontSize: 12)),
                            leading: const Icon(Icons.movie_creation_outlined),
                            onTap: controlsEnabled ? () => _startReplay(filename) : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text("Size:"),
                Expanded(
                  child: Slider(
                    value: _currentStrokeWidth,
                    min: 1.0,
                    max: 20.0,
                    onChanged: (value) => setState(() => _currentStrokeWidth = value),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _backgroundColor,
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
                onPanStart: _isConnected ? _onPanStart : null,
                onPanUpdate: _isConnected ? _onPanUpdate : null,
                onPanEnd: _isConnected ? _onPanEnd : null,
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
  final List<PathData> paths;

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
