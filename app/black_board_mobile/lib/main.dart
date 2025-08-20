import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:black_board_mobile/src/services/audio_service.dart';
import 'package:http/http.dart' as http;
import 'package:black_board_mobile/src/rust/api.dart';
import 'package:black_board_mobile/src/rust/bridge_models.dart' as rust;
import 'package:black_board_mobile/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'src/generated/communication.pb.dart' as proto;
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const MyApp());
}

class PathData {
  final BigInt id;
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  PathData.fromRust(rust.FlutterPathFull rustPath)
    : id = rustPath.pathId,
      points = rustPath.points.map((p) => Offset(p.dx, p.dy)).toList(),
      color = Color(rustPath.color),
      strokeWidth = rustPath.strokeWidth.toDouble();

  PathData({
    required this.id,
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}

class PublicRoomInfo {
  final String roomId;
  final String name;
  final int participantCount;

  PublicRoomInfo({
    required this.roomId,
    required this.name,
    required this.participantCount,
  });

  factory PublicRoomInfo.fromJson(Map<String, dynamic> json) {
    return PublicRoomInfo(
      roomId: json['room_id'] as String,
      name: json['name'] as String,
      participantCount: json['participant_count'] as int,
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
  final _serverAddrController = TextEditingController(
    text: '107.173.62.153:12345',
  );
  final _usernameController = TextEditingController(text: 'FlutterUser');
  final _roomIdController = TextEditingController();

  String? _roomId;
  bool _isConnected = false;
  StreamSubscription? _eventSubscription;

  Map<BigInt, PathData> _paths = {};
  BigInt? _currentPathId;

  Color _brushColor = Colors.black;
  Color _backgroundColor = Colors.white;
  double _currentStrokeWidth = 4.0;
  bool _isErasing = false;

  List<String> _recordings = [];
  bool _isLoadingRecordings = false;

  List<PublicRoomInfo> _publicRooms = [];
  bool _isLoadingPublicRooms = false;

  bool _isReplaying = false;
  int? _replayStartWallClock;
  BigInt? _replayStartEventTimestamp;

  late final AudioService _audioService;
  StreamSubscription? _outgoingAudioSubscription;
  int _audioSequence = 0;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _fetchPublicRooms();
  }

  @override
  void dispose() {
    _disconnect(isFinal: true);
    _audioService.dispose();
    _serverAddrController.dispose();
    _usernameController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  Future<void> _startAudioProcessing() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _showErrorDialog('Microphone permission is required for voice chat.');
      return;
    }

    await _audioService.start();

    _outgoingAudioSubscription?.cancel();

    _outgoingAudioSubscription = _audioService.outgoingAudioStream.listen((
      audioChunk,
    ) {
      try {
        sendAudioChunk(data: audioChunk, sequence: _audioSequence++);
      } catch (e) {
        debugPrint("Failed to send audio chunk to Rust: $e");
      }
    });
  }

  void _setupStreamListener() {
    _eventSubscription?.cancel();
    final stream = listenEvents();
    _eventSubscription = stream.listen(
      _handleRoomEvent,
      onError: (e) => _showErrorDialog(e.toString()),
      onDone: () => _disconnect(isFinal: true),
    );
  }

  void _handleRoomEvent(rust.EventMessage event) {
    try {
      final roomEvent = proto.RoomEvent.fromBuffer(event.data);

      // از متد whichEventType() برای تشخیص نوع رویداد استفاده می‌کنیم
      switch (roomEvent.whichEventType()) {
        case proto.RoomEvent_EventType.canvasSnapshot:
          final snapshot = roomEvent.canvasSnapshot;
          final newPaths = <BigInt, PathData>{};
          for (final pathFull in snapshot.paths) {
            final pathId = BigInt.parse(pathFull.pathId.toString());
            newPaths[pathId] = PathData(
              id: pathId,
              points: pathFull.points
                  .map((p) => Offset(p.dx.toDouble(), p.dy.toDouble()))
                  .toList(),
              color: Color(pathFull.color),
              strokeWidth: pathFull.strokeWidth.toDouble(),
            );
          }
          if (mounted) setState(() => _paths = newPaths);
          break;

        case proto.RoomEvent_EventType.canvasCommand:
          _applyCanvasCommand(roomEvent.canvasCommand.command);
          break;

        case proto.RoomEvent_EventType.audioChunk:
          // حالا به صورت امن به فیلد audioChunk دسترسی داریم
          final audioChunkData = roomEvent.audioChunk.chunk.data;
          _audioService.playAudioChunk(Uint8List.fromList(audioChunkData));
          break;

        case proto.RoomEvent_EventType.hostEndedSession:
          if (_isReplaying) {
            _handleReplayFinished();
          } else {
            _showErrorDialog("The host has ended the session.");
            _disconnect(isFinal: true);
          }
          break;

        // این دو مورد را فعلا مدیریت نمی‌کنیم، اما بهتر است در switch باشند
        case proto.RoomEvent_EventType.userJoined:
        case proto.RoomEvent_EventType.userLeft:
          break;

        // حالت 'notSet' زمانی است که هیچ‌کدام از فیلدهای oneof مقدار ندارند
        case proto.RoomEvent_EventType.notSet:
          // هیچ کاری انجام نده
          break;
      }
    } catch (e) {
      debugPrint("Failed to parse event: $e");
    }
  }

  void _applyCanvasCommand(proto.CanvasCommand command) {
    if (!mounted) return;
    setState(() {
      if (command.hasPathStart()) {
        final pathStart = command.pathStart;
        final pathId = BigInt.parse(pathStart.pathId.toString());
        _paths[pathId] = PathData(
          id: pathId,
          points: [
            Offset(
              pathStart.point.dx.toDouble(),
              pathStart.point.dy.toDouble(),
            ),
          ],
          color: Color(pathStart.color),
          strokeWidth: pathStart.strokeWidth.toDouble(),
        );
      } else if (command.hasPathAppend()) {
        final pathAppend = command.pathAppend;
        final pathId = BigInt.parse(pathAppend.pathId.toString());
        if (_paths.containsKey(pathId)) {
          _paths[pathId]!.points.add(
            Offset(
              pathAppend.point.dx.toDouble(),
              pathAppend.point.dy.toDouble(),
            ),
          );
        }
      }
    });
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
      await _startAudioProcessing();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _joinRoom() async {
    if (_isConnected || _roomIdController.text.isEmpty) return;
    try {
      final initialPaths = await joinRoom(
        serverAddr: _serverAddrController.text,
        username: _usernameController.text,
        roomId: _roomIdController.text,
      );

      final newPaths = <BigInt, PathData>{};
      for (final rustPath in initialPaths) {
        newPaths[rustPath.pathId] = PathData.fromRust(rustPath);
      }

      if (mounted) {
        setState(() {
          _isConnected = true;
          _roomId = _roomIdController.text;
          _paths = newPaths;
        });
      }

      _setupStreamListener();
      await _startAudioProcessing();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _disconnect({bool isFinal = false}) {
    if (!_isConnected && !_isReplaying) return;

    _audioService.stop();
    _outgoingAudioSubscription?.cancel();
    _outgoingAudioSubscription = null;

    _eventSubscription?.cancel();
    _eventSubscription = null;

    if (_isConnected) {
      disconnect();
    }

    if (mounted) {
      setState(() {
        _isConnected = false;
        _isReplaying = false;
        _roomId = null;
        if (isFinal) {
          _paths = {};
        }
      });
      _fetchPublicRooms();
    }
  }

  void _handleReplayFinished() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
    if (mounted) {
      setState(() {
        _isReplaying = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Replay finished!')));
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (!_isConnected) return;

    final newPathId = startPath(
      point: rust.FlutterPoint(
        dx: details.localPosition.dx,
        dy: details.localPosition.dy,
      ),
      color: (_isErasing ? _backgroundColor : _brushColor).value,
      strokeWidth: _currentStrokeWidth,
    );

    setState(() {
      _currentPathId = newPathId;
      final newPath = PathData(
        id: _currentPathId!,
        points: [details.localPosition],
        color: _isErasing ? _backgroundColor : _brushColor,
        strokeWidth: _currentStrokeWidth,
      );
      _paths[_currentPathId!] = newPath;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentPathId == null || _paths[_currentPathId] == null) return;

    setState(() {
      _paths[_currentPathId]!.points.add(details.localPosition);
    });

    appendToPath(
      pathId: _currentPathId!,
      point: rust.FlutterPoint(
        dx: details.localPosition.dx,
        dy: details.localPosition.dy,
      ),
    );
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentPathId == null) return;
    endPath(pathId: _currentPathId!);
    _currentPathId = null;
  }

  void _openColorPicker(bool isBackground) {
    Color pickerColor = isBackground ? _backgroundColor : _brushColor;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isBackground ? 'Pick Background Color' : 'Pick Brush Color',
        ),
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

  Future<void> _fetchPublicRooms() async {
    setState(() => _isLoadingPublicRooms = true);
    try {
      final serverIp = _serverAddrController.text.split(':')[0];
      if (serverIp.isEmpty) throw Exception("Server address is not set");

      final url = Uri.parse('http://$serverIp:8080/rooms');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> roomsJson = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _publicRooms = roomsJson
                .map((json) => PublicRoomInfo.fromJson(json))
                .toList();
          });
        }
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog("Could not fetch public rooms: ${e.toString()}");
      if (mounted) setState(() => _publicRooms = []);
    } finally {
      if (mounted) {
        setState(() => _isLoadingPublicRooms = false);
      }
    }
  }

  Future<void> _fetchRecordings() async {
    setState(() => _isLoadingRecordings = true);
    try {
      final serverIp = _serverAddrController.text.split(':')[0];
      if (serverIp.isEmpty) throw Exception("Server address is not set");

      final url = Uri.parse('http://$serverIp:8080/recordings');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> recordingsJson = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _recordings = recordingsJson.cast<String>();
          });
        }
      } else {
        throw Exception('Failed to load recordings: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog("Could not fetch recordings: ${e.toString()}");
      if (mounted) setState(() => _recordings = []);
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
      _paths = {};
      _isReplaying = true;
      _replayStartWallClock = null;
      _replayStartEventTimestamp = null;
    });

    final stream = replayRoom(
      serverAddr: _serverAddrController.text,
      logFilename: filename,
    );

    _eventSubscription = stream.listen(
      _handleReplayEvent,
      onError: (e) {
        _showErrorDialog(e.toString());
        _disconnect(isFinal: true);
      },
      onDone: () => _handleReplayFinished(),
    );
  }

  void _handleReplayEvent(rust.EventMessage event) {
    try {
      final roomEvent = proto.RoomEvent.fromBuffer(event.data);
      if (roomEvent.hasHostEndedSession()) {
        _handleReplayFinished();
        return;
      }

      if (!roomEvent.hasCanvasCommand()) return;
      final command = roomEvent.canvasCommand.command;

      if (_replayStartWallClock == null || _replayStartEventTimestamp == null) {
        _replayStartWallClock = DateTime.now().millisecondsSinceEpoch;
        _replayStartEventTimestamp = BigInt.parse(
          command.timestampMs.toString(),
        );
      }

      final eventTimestamp = BigInt.parse(command.timestampMs.toString());
      final eventTimeOffset = (eventTimestamp - _replayStartEventTimestamp!)
          .toInt();
      final wallClockOffset =
          DateTime.now().millisecondsSinceEpoch - _replayStartWallClock!;

      final delay = eventTimeOffset - wallClockOffset;

      Future.delayed(Duration(milliseconds: delay > 0 ? delay : 0), () {
        if (_isReplaying) {
          _applyCanvasCommand(command);
        }
      });
    } catch (e) {
      debugPrint("Failed to handle replay event: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool controlsEnabled = !_isConnected && !_isReplaying;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isReplaying
              ? 'Replaying Session...'
              : (_isConnected ? 'Room: $_roomId' : 'Blackboard Client'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.blueGrey),
            tooltip: 'Change Background Color',
            onPressed: () => _openColorPicker(true),
          ),
          IconButton(
            icon: Icon(
              Icons.brush,
              color: _isErasing ? Colors.grey : _brushColor,
            ),
            tooltip: 'Brush',
            onPressed: () => setState(() => _isErasing = false),
          ),
          IconButton(
            icon: Icon(
              Icons.cleaning_services,
              color: _isErasing ? Colors.blue : Colors.grey,
            ),
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
                      decoration: const InputDecoration(
                        labelText: 'Server Address (QUIC Port)',
                      ),
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
                            decoration: const InputDecoration(
                              labelText: 'Room ID',
                            ),
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
                          onPressed: _isConnected || _isReplaying
                              ? () => _disconnect(isFinal: true)
                              : null,
                          child: const Text('Disconnect'),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Public Rooms",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _isLoadingPublicRooms || !controlsEnabled
                              ? null
                              : _fetchPublicRooms,
                        ),
                      ],
                    ),
                    _isLoadingPublicRooms
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : _publicRooms.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("No public rooms. Press refresh."),
                            ),
                          )
                        : SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount: _publicRooms.length,
                              itemBuilder: (context, index) {
                                final room = _publicRooms[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    title: Text(room.name),
                                    subtitle: Text("ID: ${room.roomId}"),
                                    leading: const Icon(
                                      Icons.group_work_outlined,
                                    ),
                                    trailing: Chip(
                                      avatar: const Icon(
                                        Icons.person,
                                        size: 16,
                                      ),
                                      label: Text("${room.participantCount}"),
                                      padding: const EdgeInsets.all(4),
                                      labelStyle: const TextStyle(fontSize: 12),
                                    ),
                                    onTap: controlsEnabled
                                        ? () {
                                            _roomIdController.text =
                                                room.roomId;
                                            _joinRoom();
                                          }
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recorded Sessions",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _isLoadingRecordings || !controlsEnabled
                              ? null
                              : _fetchRecordings,
                        ),
                      ],
                    ),
                    _isLoadingRecordings
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : _recordings.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "No recordings found. Press refresh.",
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount: _recordings.length,
                              itemBuilder: (context, index) {
                                final filename = _recordings[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      filename,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: const Icon(
                                      Icons.movie_creation_outlined,
                                    ),
                                    onTap: controlsEnabled
                                        ? () => _startReplay(filename)
                                        : null,
                                  ),
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
                    onChanged: (value) =>
                        setState(() => _currentStrokeWidth = value),
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
                    color: Colors.grey.withAlpha((0.2 * 255).toInt()),
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
