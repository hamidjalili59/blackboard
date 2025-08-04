//
//  Generated code. Do not modify.
//  source: communication.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum ClientToServer_Payload {
  initialRequest, 
  roomMessage, 
  notSet
}

class ClientToServer extends $pb.GeneratedMessage {
  factory ClientToServer({
    InitialRequest? initialRequest,
    RoomMessage? roomMessage,
  }) {
    final $result = create();
    if (initialRequest != null) {
      $result.initialRequest = initialRequest;
    }
    if (roomMessage != null) {
      $result.roomMessage = roomMessage;
    }
    return $result;
  }
  ClientToServer._() : super();
  factory ClientToServer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClientToServer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ClientToServer_Payload> _ClientToServer_PayloadByTag = {
    1 : ClientToServer_Payload.initialRequest,
    2 : ClientToServer_Payload.roomMessage,
    0 : ClientToServer_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClientToServer', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<InitialRequest>(1, _omitFieldNames ? '' : 'initialRequest', subBuilder: InitialRequest.create)
    ..aOM<RoomMessage>(2, _omitFieldNames ? '' : 'roomMessage', subBuilder: RoomMessage.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClientToServer clone() => ClientToServer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClientToServer copyWith(void Function(ClientToServer) updates) => super.copyWith((message) => updates(message as ClientToServer)) as ClientToServer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientToServer create() => ClientToServer._();
  ClientToServer createEmptyInstance() => create();
  static $pb.PbList<ClientToServer> createRepeated() => $pb.PbList<ClientToServer>();
  @$core.pragma('dart2js:noInline')
  static ClientToServer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientToServer>(create);
  static ClientToServer? _defaultInstance;

  ClientToServer_Payload whichPayload() => _ClientToServer_PayloadByTag[$_whichOneof(0)]!;
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  InitialRequest get initialRequest => $_getN(0);
  @$pb.TagNumber(1)
  set initialRequest(InitialRequest v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInitialRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  InitialRequest ensureInitialRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  RoomMessage get roomMessage => $_getN(1);
  @$pb.TagNumber(2)
  set roomMessage(RoomMessage v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomMessage() => $_clearField(2);
  @$pb.TagNumber(2)
  RoomMessage ensureRoomMessage() => $_ensure(1);
}

enum InitialRequest_RequestType {
  createRoom, 
  joinRoom, 
  replayRoom, 
  notSet
}

class InitialRequest extends $pb.GeneratedMessage {
  factory InitialRequest({
    CreateRoomRequest? createRoom,
    JoinRoomRequest? joinRoom,
    ReplayRoomRequest? replayRoom,
  }) {
    final $result = create();
    if (createRoom != null) {
      $result.createRoom = createRoom;
    }
    if (joinRoom != null) {
      $result.joinRoom = joinRoom;
    }
    if (replayRoom != null) {
      $result.replayRoom = replayRoom;
    }
    return $result;
  }
  InitialRequest._() : super();
  factory InitialRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitialRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, InitialRequest_RequestType> _InitialRequest_RequestTypeByTag = {
    1 : InitialRequest_RequestType.createRoom,
    2 : InitialRequest_RequestType.joinRoom,
    3 : InitialRequest_RequestType.replayRoom,
    0 : InitialRequest_RequestType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InitialRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<CreateRoomRequest>(1, _omitFieldNames ? '' : 'createRoom', subBuilder: CreateRoomRequest.create)
    ..aOM<JoinRoomRequest>(2, _omitFieldNames ? '' : 'joinRoom', subBuilder: JoinRoomRequest.create)
    ..aOM<ReplayRoomRequest>(3, _omitFieldNames ? '' : 'replayRoom', subBuilder: ReplayRoomRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitialRequest clone() => InitialRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitialRequest copyWith(void Function(InitialRequest) updates) => super.copyWith((message) => updates(message as InitialRequest)) as InitialRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitialRequest create() => InitialRequest._();
  InitialRequest createEmptyInstance() => create();
  static $pb.PbList<InitialRequest> createRepeated() => $pb.PbList<InitialRequest>();
  @$core.pragma('dart2js:noInline')
  static InitialRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitialRequest>(create);
  static InitialRequest? _defaultInstance;

  InitialRequest_RequestType whichRequestType() => _InitialRequest_RequestTypeByTag[$_whichOneof(0)]!;
  void clearRequestType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CreateRoomRequest get createRoom => $_getN(0);
  @$pb.TagNumber(1)
  set createRoom(CreateRoomRequest v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreateRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateRoomRequest ensureCreateRoom() => $_ensure(0);

  @$pb.TagNumber(2)
  JoinRoomRequest get joinRoom => $_getN(1);
  @$pb.TagNumber(2)
  set joinRoom(JoinRoomRequest v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasJoinRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearJoinRoom() => $_clearField(2);
  @$pb.TagNumber(2)
  JoinRoomRequest ensureJoinRoom() => $_ensure(1);

  @$pb.TagNumber(3)
  ReplayRoomRequest get replayRoom => $_getN(2);
  @$pb.TagNumber(3)
  set replayRoom(ReplayRoomRequest v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReplayRoom() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplayRoom() => $_clearField(3);
  @$pb.TagNumber(3)
  ReplayRoomRequest ensureReplayRoom() => $_ensure(2);
}

class CreateRoomRequest extends $pb.GeneratedMessage {
  factory CreateRoomRequest({
    $core.String? username,
  }) {
    final $result = create();
    if (username != null) {
      $result.username = username;
    }
    return $result;
  }
  CreateRoomRequest._() : super();
  factory CreateRoomRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRoomRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRoomRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRoomRequest clone() => CreateRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRoomRequest copyWith(void Function(CreateRoomRequest) updates) => super.copyWith((message) => updates(message as CreateRoomRequest)) as CreateRoomRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest create() => CreateRoomRequest._();
  CreateRoomRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRoomRequest> createRepeated() => $pb.PbList<CreateRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRoomRequest>(create);
  static CreateRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);
}

class JoinRoomRequest extends $pb.GeneratedMessage {
  factory JoinRoomRequest({
    $core.String? roomId,
    $core.String? username,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    if (username != null) {
      $result.username = username;
    }
    return $result;
  }
  JoinRoomRequest._() : super();
  factory JoinRoomRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRoomRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinRoomRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinRoomRequest clone() => JoinRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinRoomRequest copyWith(void Function(JoinRoomRequest) updates) => super.copyWith((message) => updates(message as JoinRoomRequest)) as JoinRoomRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest create() => JoinRoomRequest._();
  JoinRoomRequest createEmptyInstance() => create();
  static $pb.PbList<JoinRoomRequest> createRepeated() => $pb.PbList<JoinRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRoomRequest>(create);
  static JoinRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);
}

class ReplayRoomRequest extends $pb.GeneratedMessage {
  factory ReplayRoomRequest({
    $core.String? logFilename,
  }) {
    final $result = create();
    if (logFilename != null) {
      $result.logFilename = logFilename;
    }
    return $result;
  }
  ReplayRoomRequest._() : super();
  factory ReplayRoomRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReplayRoomRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReplayRoomRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'logFilename')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReplayRoomRequest clone() => ReplayRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReplayRoomRequest copyWith(void Function(ReplayRoomRequest) updates) => super.copyWith((message) => updates(message as ReplayRoomRequest)) as ReplayRoomRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplayRoomRequest create() => ReplayRoomRequest._();
  ReplayRoomRequest createEmptyInstance() => create();
  static $pb.PbList<ReplayRoomRequest> createRepeated() => $pb.PbList<ReplayRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static ReplayRoomRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReplayRoomRequest>(create);
  static ReplayRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get logFilename => $_getSZ(0);
  @$pb.TagNumber(1)
  set logFilename($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLogFilename() => $_has(0);
  @$pb.TagNumber(1)
  void clearLogFilename() => $_clearField(1);
}

enum RoomMessage_Payload {
  canvasCommand, 
  audioChunk, 
  notSet
}

class RoomMessage extends $pb.GeneratedMessage {
  factory RoomMessage({
    CanvasCommand? canvasCommand,
    AudioChunk? audioChunk,
  }) {
    final $result = create();
    if (canvasCommand != null) {
      $result.canvasCommand = canvasCommand;
    }
    if (audioChunk != null) {
      $result.audioChunk = audioChunk;
    }
    return $result;
  }
  RoomMessage._() : super();
  factory RoomMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, RoomMessage_Payload> _RoomMessage_PayloadByTag = {
    1 : RoomMessage_Payload.canvasCommand,
    2 : RoomMessage_Payload.audioChunk,
    0 : RoomMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<CanvasCommand>(1, _omitFieldNames ? '' : 'canvasCommand', subBuilder: CanvasCommand.create)
    ..aOM<AudioChunk>(2, _omitFieldNames ? '' : 'audioChunk', subBuilder: AudioChunk.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomMessage clone() => RoomMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomMessage copyWith(void Function(RoomMessage) updates) => super.copyWith((message) => updates(message as RoomMessage)) as RoomMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomMessage create() => RoomMessage._();
  RoomMessage createEmptyInstance() => create();
  static $pb.PbList<RoomMessage> createRepeated() => $pb.PbList<RoomMessage>();
  @$core.pragma('dart2js:noInline')
  static RoomMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomMessage>(create);
  static RoomMessage? _defaultInstance;

  RoomMessage_Payload whichPayload() => _RoomMessage_PayloadByTag[$_whichOneof(0)]!;
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CanvasCommand get canvasCommand => $_getN(0);
  @$pb.TagNumber(1)
  set canvasCommand(CanvasCommand v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCanvasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCanvasCommand() => $_clearField(1);
  @$pb.TagNumber(1)
  CanvasCommand ensureCanvasCommand() => $_ensure(0);

  @$pb.TagNumber(2)
  AudioChunk get audioChunk => $_getN(1);
  @$pb.TagNumber(2)
  set audioChunk(AudioChunk v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAudioChunk() => $_has(1);
  @$pb.TagNumber(2)
  void clearAudioChunk() => $_clearField(2);
  @$pb.TagNumber(2)
  AudioChunk ensureAudioChunk() => $_ensure(1);
}

/// *** بخش بهینه شده CanvasCommand ***
class Point extends $pb.GeneratedMessage {
  factory Point({
    $core.double? dx,
    $core.double? dy,
  }) {
    final $result = create();
    if (dx != null) {
      $result.dx = dx;
    }
    if (dy != null) {
      $result.dy = dy;
    }
    return $result;
  }
  Point._() : super();
  factory Point.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Point.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Point', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'dx', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'dy', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Point clone() => Point()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Point copyWith(void Function(Point) updates) => super.copyWith((message) => updates(message as Point)) as Point;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point create() => Point._();
  Point createEmptyInstance() => create();
  static $pb.PbList<Point> createRepeated() => $pb.PbList<Point>();
  @$core.pragma('dart2js:noInline')
  static Point getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point>(create);
  static Point? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get dx => $_getN(0);
  @$pb.TagNumber(1)
  set dx($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDx() => $_has(0);
  @$pb.TagNumber(1)
  void clearDx() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get dy => $_getN(1);
  @$pb.TagNumber(2)
  set dy($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDy() => $_has(1);
  @$pb.TagNumber(2)
  void clearDy() => $_clearField(2);
}

class PathStart extends $pb.GeneratedMessage {
  factory PathStart({
    $core.String? id,
    Point? point,
    $core.int? color,
    $core.double? strokeWidth,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (point != null) {
      $result.point = point;
    }
    if (color != null) {
      $result.color = color;
    }
    if (strokeWidth != null) {
      $result.strokeWidth = strokeWidth;
    }
    return $result;
  }
  PathStart._() : super();
  factory PathStart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PathStart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PathStart', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Point>(2, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'color', $pb.PbFieldType.OU3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'strokeWidth', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PathStart clone() => PathStart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PathStart copyWith(void Function(PathStart) updates) => super.copyWith((message) => updates(message as PathStart)) as PathStart;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathStart create() => PathStart._();
  PathStart createEmptyInstance() => create();
  static $pb.PbList<PathStart> createRepeated() => $pb.PbList<PathStart>();
  @$core.pragma('dart2js:noInline')
  static PathStart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathStart>(create);
  static PathStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Point get point => $_getN(1);
  @$pb.TagNumber(2)
  set point(Point v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoint() => $_clearField(2);
  @$pb.TagNumber(2)
  Point ensurePoint() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get color => $_getIZ(2);
  @$pb.TagNumber(3)
  set color($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get strokeWidth => $_getN(3);
  @$pb.TagNumber(4)
  set strokeWidth($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStrokeWidth() => $_has(3);
  @$pb.TagNumber(4)
  void clearStrokeWidth() => $_clearField(4);
}

class PathAppend extends $pb.GeneratedMessage {
  factory PathAppend({
    $core.String? id,
    Point? point,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (point != null) {
      $result.point = point;
    }
    return $result;
  }
  PathAppend._() : super();
  factory PathAppend.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PathAppend.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PathAppend', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Point>(2, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PathAppend clone() => PathAppend()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PathAppend copyWith(void Function(PathAppend) updates) => super.copyWith((message) => updates(message as PathAppend)) as PathAppend;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathAppend create() => PathAppend._();
  PathAppend createEmptyInstance() => create();
  static $pb.PbList<PathAppend> createRepeated() => $pb.PbList<PathAppend>();
  @$core.pragma('dart2js:noInline')
  static PathAppend getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathAppend>(create);
  static PathAppend? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Point get point => $_getN(1);
  @$pb.TagNumber(2)
  set point(Point v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoint() => $_clearField(2);
  @$pb.TagNumber(2)
  Point ensurePoint() => $_ensure(1);
}

class PathFull extends $pb.GeneratedMessage {
  factory PathFull({
    $core.String? id,
    $core.Iterable<Point>? points,
    $core.int? color,
    $core.double? strokeWidth,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (points != null) {
      $result.points.addAll(points);
    }
    if (color != null) {
      $result.color = color;
    }
    if (strokeWidth != null) {
      $result.strokeWidth = strokeWidth;
    }
    return $result;
  }
  PathFull._() : super();
  factory PathFull.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PathFull.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PathFull', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..pc<Point>(2, _omitFieldNames ? '' : 'points', $pb.PbFieldType.PM, subBuilder: Point.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'color', $pb.PbFieldType.OU3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'strokeWidth', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PathFull clone() => PathFull()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PathFull copyWith(void Function(PathFull) updates) => super.copyWith((message) => updates(message as PathFull)) as PathFull;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathFull create() => PathFull._();
  PathFull createEmptyInstance() => create();
  static $pb.PbList<PathFull> createRepeated() => $pb.PbList<PathFull>();
  @$core.pragma('dart2js:noInline')
  static PathFull getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathFull>(create);
  static PathFull? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Point> get points => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get color => $_getIZ(2);
  @$pb.TagNumber(3)
  set color($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get strokeWidth => $_getN(3);
  @$pb.TagNumber(4)
  set strokeWidth($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStrokeWidth() => $_has(3);
  @$pb.TagNumber(4)
  void clearStrokeWidth() => $_clearField(4);
}

enum CanvasCommand_CommandType {
  pathStart, 
  pathAppend, 
  pathFull, 
  notSet
}

class CanvasCommand extends $pb.GeneratedMessage {
  factory CanvasCommand({
    $fixnum.Int64? timestampMs,
    PathStart? pathStart,
    PathAppend? pathAppend,
    PathFull? pathFull,
  }) {
    final $result = create();
    if (timestampMs != null) {
      $result.timestampMs = timestampMs;
    }
    if (pathStart != null) {
      $result.pathStart = pathStart;
    }
    if (pathAppend != null) {
      $result.pathAppend = pathAppend;
    }
    if (pathFull != null) {
      $result.pathFull = pathFull;
    }
    return $result;
  }
  CanvasCommand._() : super();
  factory CanvasCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CanvasCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, CanvasCommand_CommandType> _CanvasCommand_CommandTypeByTag = {
    2 : CanvasCommand_CommandType.pathStart,
    3 : CanvasCommand_CommandType.pathAppend,
    4 : CanvasCommand_CommandType.pathFull,
    0 : CanvasCommand_CommandType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CanvasCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aInt64(1, _omitFieldNames ? '' : 'timestampMs')
    ..aOM<PathStart>(2, _omitFieldNames ? '' : 'pathStart', subBuilder: PathStart.create)
    ..aOM<PathAppend>(3, _omitFieldNames ? '' : 'pathAppend', subBuilder: PathAppend.create)
    ..aOM<PathFull>(4, _omitFieldNames ? '' : 'pathFull', subBuilder: PathFull.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CanvasCommand clone() => CanvasCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CanvasCommand copyWith(void Function(CanvasCommand) updates) => super.copyWith((message) => updates(message as CanvasCommand)) as CanvasCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CanvasCommand create() => CanvasCommand._();
  CanvasCommand createEmptyInstance() => create();
  static $pb.PbList<CanvasCommand> createRepeated() => $pb.PbList<CanvasCommand>();
  @$core.pragma('dart2js:noInline')
  static CanvasCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CanvasCommand>(create);
  static CanvasCommand? _defaultInstance;

  CanvasCommand_CommandType whichCommandType() => _CanvasCommand_CommandTypeByTag[$_whichOneof(0)]!;
  void clearCommandType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestampMs => $_getI64(0);
  @$pb.TagNumber(1)
  set timestampMs($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestampMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampMs() => $_clearField(1);

  @$pb.TagNumber(2)
  PathStart get pathStart => $_getN(1);
  @$pb.TagNumber(2)
  set pathStart(PathStart v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPathStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPathStart() => $_clearField(2);
  @$pb.TagNumber(2)
  PathStart ensurePathStart() => $_ensure(1);

  @$pb.TagNumber(3)
  PathAppend get pathAppend => $_getN(2);
  @$pb.TagNumber(3)
  set pathAppend(PathAppend v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPathAppend() => $_has(2);
  @$pb.TagNumber(3)
  void clearPathAppend() => $_clearField(3);
  @$pb.TagNumber(3)
  PathAppend ensurePathAppend() => $_ensure(2);

  @$pb.TagNumber(4)
  PathFull get pathFull => $_getN(3);
  @$pb.TagNumber(4)
  set pathFull(PathFull v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPathFull() => $_has(3);
  @$pb.TagNumber(4)
  void clearPathFull() => $_clearField(4);
  @$pb.TagNumber(4)
  PathFull ensurePathFull() => $_ensure(3);
}

class AudioChunk extends $pb.GeneratedMessage {
  factory AudioChunk({
    $core.List<$core.int>? data,
    $fixnum.Int64? sequence,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (sequence != null) {
      $result.sequence = sequence;
    }
    return $result;
  }
  AudioChunk._() : super();
  factory AudioChunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioChunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AudioChunk', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'sequence')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioChunk clone() => AudioChunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioChunk copyWith(void Function(AudioChunk) updates) => super.copyWith((message) => updates(message as AudioChunk)) as AudioChunk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioChunk create() => AudioChunk._();
  AudioChunk createEmptyInstance() => create();
  static $pb.PbList<AudioChunk> createRepeated() => $pb.PbList<AudioChunk>();
  @$core.pragma('dart2js:noInline')
  static AudioChunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioChunk>(create);
  static AudioChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sequence => $_getI64(1);
  @$pb.TagNumber(2)
  set sequence($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearSequence() => $_clearField(2);
}

enum ServerToClient_Payload {
  initialResponse, 
  roomEvent, 
  notSet
}

class ServerToClient extends $pb.GeneratedMessage {
  factory ServerToClient({
    InitialResponse? initialResponse,
    RoomEvent? roomEvent,
  }) {
    final $result = create();
    if (initialResponse != null) {
      $result.initialResponse = initialResponse;
    }
    if (roomEvent != null) {
      $result.roomEvent = roomEvent;
    }
    return $result;
  }
  ServerToClient._() : super();
  factory ServerToClient.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerToClient.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ServerToClient_Payload> _ServerToClient_PayloadByTag = {
    1 : ServerToClient_Payload.initialResponse,
    2 : ServerToClient_Payload.roomEvent,
    0 : ServerToClient_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerToClient', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<InitialResponse>(1, _omitFieldNames ? '' : 'initialResponse', subBuilder: InitialResponse.create)
    ..aOM<RoomEvent>(2, _omitFieldNames ? '' : 'roomEvent', subBuilder: RoomEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerToClient clone() => ServerToClient()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerToClient copyWith(void Function(ServerToClient) updates) => super.copyWith((message) => updates(message as ServerToClient)) as ServerToClient;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerToClient create() => ServerToClient._();
  ServerToClient createEmptyInstance() => create();
  static $pb.PbList<ServerToClient> createRepeated() => $pb.PbList<ServerToClient>();
  @$core.pragma('dart2js:noInline')
  static ServerToClient getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerToClient>(create);
  static ServerToClient? _defaultInstance;

  ServerToClient_Payload whichPayload() => _ServerToClient_PayloadByTag[$_whichOneof(0)]!;
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  InitialResponse get initialResponse => $_getN(0);
  @$pb.TagNumber(1)
  set initialResponse(InitialResponse v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInitialResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialResponse() => $_clearField(1);
  @$pb.TagNumber(1)
  InitialResponse ensureInitialResponse() => $_ensure(0);

  @$pb.TagNumber(2)
  RoomEvent get roomEvent => $_getN(1);
  @$pb.TagNumber(2)
  set roomEvent(RoomEvent v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomEvent() => $_clearField(2);
  @$pb.TagNumber(2)
  RoomEvent ensureRoomEvent() => $_ensure(1);
}

enum InitialResponse_ResponseType {
  createRoomResponse, 
  joinRoomResponse, 
  errorResponse, 
  notSet
}

class InitialResponse extends $pb.GeneratedMessage {
  factory InitialResponse({
    CreateRoomResponse? createRoomResponse,
    JoinRoomResponse? joinRoomResponse,
    ErrorResponse? errorResponse,
  }) {
    final $result = create();
    if (createRoomResponse != null) {
      $result.createRoomResponse = createRoomResponse;
    }
    if (joinRoomResponse != null) {
      $result.joinRoomResponse = joinRoomResponse;
    }
    if (errorResponse != null) {
      $result.errorResponse = errorResponse;
    }
    return $result;
  }
  InitialResponse._() : super();
  factory InitialResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitialResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, InitialResponse_ResponseType> _InitialResponse_ResponseTypeByTag = {
    1 : InitialResponse_ResponseType.createRoomResponse,
    2 : InitialResponse_ResponseType.joinRoomResponse,
    3 : InitialResponse_ResponseType.errorResponse,
    0 : InitialResponse_ResponseType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InitialResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<CreateRoomResponse>(1, _omitFieldNames ? '' : 'createRoomResponse', subBuilder: CreateRoomResponse.create)
    ..aOM<JoinRoomResponse>(2, _omitFieldNames ? '' : 'joinRoomResponse', subBuilder: JoinRoomResponse.create)
    ..aOM<ErrorResponse>(3, _omitFieldNames ? '' : 'errorResponse', subBuilder: ErrorResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitialResponse clone() => InitialResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitialResponse copyWith(void Function(InitialResponse) updates) => super.copyWith((message) => updates(message as InitialResponse)) as InitialResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitialResponse create() => InitialResponse._();
  InitialResponse createEmptyInstance() => create();
  static $pb.PbList<InitialResponse> createRepeated() => $pb.PbList<InitialResponse>();
  @$core.pragma('dart2js:noInline')
  static InitialResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitialResponse>(create);
  static InitialResponse? _defaultInstance;

  InitialResponse_ResponseType whichResponseType() => _InitialResponse_ResponseTypeByTag[$_whichOneof(0)]!;
  void clearResponseType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CreateRoomResponse get createRoomResponse => $_getN(0);
  @$pb.TagNumber(1)
  set createRoomResponse(CreateRoomResponse v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreateRoomResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateRoomResponse() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateRoomResponse ensureCreateRoomResponse() => $_ensure(0);

  @$pb.TagNumber(2)
  JoinRoomResponse get joinRoomResponse => $_getN(1);
  @$pb.TagNumber(2)
  set joinRoomResponse(JoinRoomResponse v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasJoinRoomResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearJoinRoomResponse() => $_clearField(2);
  @$pb.TagNumber(2)
  JoinRoomResponse ensureJoinRoomResponse() => $_ensure(1);

  @$pb.TagNumber(3)
  ErrorResponse get errorResponse => $_getN(2);
  @$pb.TagNumber(3)
  set errorResponse(ErrorResponse v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorResponse() => $_clearField(3);
  @$pb.TagNumber(3)
  ErrorResponse ensureErrorResponse() => $_ensure(2);
}

class CreateRoomResponse extends $pb.GeneratedMessage {
  factory CreateRoomResponse({
    $core.String? roomId,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    return $result;
  }
  CreateRoomResponse._() : super();
  factory CreateRoomResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRoomResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRoomResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRoomResponse clone() => CreateRoomResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRoomResponse copyWith(void Function(CreateRoomResponse) updates) => super.copyWith((message) => updates(message as CreateRoomResponse)) as CreateRoomResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse create() => CreateRoomResponse._();
  CreateRoomResponse createEmptyInstance() => create();
  static $pb.PbList<CreateRoomResponse> createRepeated() => $pb.PbList<CreateRoomResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRoomResponse>(create);
  static CreateRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class JoinRoomResponse extends $pb.GeneratedMessage {
  factory JoinRoomResponse({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  JoinRoomResponse._() : super();
  factory JoinRoomResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRoomResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinRoomResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinRoomResponse clone() => JoinRoomResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinRoomResponse copyWith(void Function(JoinRoomResponse) updates) => super.copyWith((message) => updates(message as JoinRoomResponse)) as JoinRoomResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse create() => JoinRoomResponse._();
  JoinRoomResponse createEmptyInstance() => create();
  static $pb.PbList<JoinRoomResponse> createRepeated() => $pb.PbList<JoinRoomResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRoomResponse>(create);
  static JoinRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class ErrorResponse extends $pb.GeneratedMessage {
  factory ErrorResponse({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  ErrorResponse._() : super();
  factory ErrorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ErrorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ErrorResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ErrorResponse clone() => ErrorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ErrorResponse copyWith(void Function(ErrorResponse) updates) => super.copyWith((message) => updates(message as ErrorResponse)) as ErrorResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorResponse create() => ErrorResponse._();
  ErrorResponse createEmptyInstance() => create();
  static $pb.PbList<ErrorResponse> createRepeated() => $pb.PbList<ErrorResponse>();
  @$core.pragma('dart2js:noInline')
  static ErrorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ErrorResponse>(create);
  static ErrorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

enum RoomEvent_EventType {
  userJoined, 
  userLeft, 
  canvasCommand, 
  audioChunk, 
  hostEndedSession, 
  notSet
}

class RoomEvent extends $pb.GeneratedMessage {
  factory RoomEvent({
    UserJoined? userJoined,
    UserLeft? userLeft,
    BroadcastedCanvasCommand? canvasCommand,
    BroadcastedAudioChunk? audioChunk,
    HostEndedSession? hostEndedSession,
  }) {
    final $result = create();
    if (userJoined != null) {
      $result.userJoined = userJoined;
    }
    if (userLeft != null) {
      $result.userLeft = userLeft;
    }
    if (canvasCommand != null) {
      $result.canvasCommand = canvasCommand;
    }
    if (audioChunk != null) {
      $result.audioChunk = audioChunk;
    }
    if (hostEndedSession != null) {
      $result.hostEndedSession = hostEndedSession;
    }
    return $result;
  }
  RoomEvent._() : super();
  factory RoomEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, RoomEvent_EventType> _RoomEvent_EventTypeByTag = {
    1 : RoomEvent_EventType.userJoined,
    2 : RoomEvent_EventType.userLeft,
    3 : RoomEvent_EventType.canvasCommand,
    4 : RoomEvent_EventType.audioChunk,
    5 : RoomEvent_EventType.hostEndedSession,
    0 : RoomEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<UserJoined>(1, _omitFieldNames ? '' : 'userJoined', subBuilder: UserJoined.create)
    ..aOM<UserLeft>(2, _omitFieldNames ? '' : 'userLeft', subBuilder: UserLeft.create)
    ..aOM<BroadcastedCanvasCommand>(3, _omitFieldNames ? '' : 'canvasCommand', subBuilder: BroadcastedCanvasCommand.create)
    ..aOM<BroadcastedAudioChunk>(4, _omitFieldNames ? '' : 'audioChunk', subBuilder: BroadcastedAudioChunk.create)
    ..aOM<HostEndedSession>(5, _omitFieldNames ? '' : 'hostEndedSession', subBuilder: HostEndedSession.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomEvent clone() => RoomEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomEvent copyWith(void Function(RoomEvent) updates) => super.copyWith((message) => updates(message as RoomEvent)) as RoomEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomEvent create() => RoomEvent._();
  RoomEvent createEmptyInstance() => create();
  static $pb.PbList<RoomEvent> createRepeated() => $pb.PbList<RoomEvent>();
  @$core.pragma('dart2js:noInline')
  static RoomEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomEvent>(create);
  static RoomEvent? _defaultInstance;

  RoomEvent_EventType whichEventType() => _RoomEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  UserJoined get userJoined => $_getN(0);
  @$pb.TagNumber(1)
  set userJoined(UserJoined v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserJoined() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserJoined() => $_clearField(1);
  @$pb.TagNumber(1)
  UserJoined ensureUserJoined() => $_ensure(0);

  @$pb.TagNumber(2)
  UserLeft get userLeft => $_getN(1);
  @$pb.TagNumber(2)
  set userLeft(UserLeft v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserLeft() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserLeft() => $_clearField(2);
  @$pb.TagNumber(2)
  UserLeft ensureUserLeft() => $_ensure(1);

  @$pb.TagNumber(3)
  BroadcastedCanvasCommand get canvasCommand => $_getN(2);
  @$pb.TagNumber(3)
  set canvasCommand(BroadcastedCanvasCommand v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCanvasCommand() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanvasCommand() => $_clearField(3);
  @$pb.TagNumber(3)
  BroadcastedCanvasCommand ensureCanvasCommand() => $_ensure(2);

  @$pb.TagNumber(4)
  BroadcastedAudioChunk get audioChunk => $_getN(3);
  @$pb.TagNumber(4)
  set audioChunk(BroadcastedAudioChunk v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAudioChunk() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudioChunk() => $_clearField(4);
  @$pb.TagNumber(4)
  BroadcastedAudioChunk ensureAudioChunk() => $_ensure(3);

  @$pb.TagNumber(5)
  HostEndedSession get hostEndedSession => $_getN(4);
  @$pb.TagNumber(5)
  set hostEndedSession(HostEndedSession v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasHostEndedSession() => $_has(4);
  @$pb.TagNumber(5)
  void clearHostEndedSession() => $_clearField(5);
  @$pb.TagNumber(5)
  HostEndedSession ensureHostEndedSession() => $_ensure(4);
}

class HostEndedSession extends $pb.GeneratedMessage {
  factory HostEndedSession({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  HostEndedSession._() : super();
  factory HostEndedSession.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HostEndedSession.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HostEndedSession', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HostEndedSession clone() => HostEndedSession()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HostEndedSession copyWith(void Function(HostEndedSession) updates) => super.copyWith((message) => updates(message as HostEndedSession)) as HostEndedSession;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HostEndedSession create() => HostEndedSession._();
  HostEndedSession createEmptyInstance() => create();
  static $pb.PbList<HostEndedSession> createRepeated() => $pb.PbList<HostEndedSession>();
  @$core.pragma('dart2js:noInline')
  static HostEndedSession getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HostEndedSession>(create);
  static HostEndedSession? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class UserJoined extends $pb.GeneratedMessage {
  factory UserJoined({
    $core.String? clientId,
    $core.String? username,
  }) {
    final $result = create();
    if (clientId != null) {
      $result.clientId = clientId;
    }
    if (username != null) {
      $result.username = username;
    }
    return $result;
  }
  UserJoined._() : super();
  factory UserJoined.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserJoined.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserJoined', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserJoined clone() => UserJoined()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserJoined copyWith(void Function(UserJoined) updates) => super.copyWith((message) => updates(message as UserJoined)) as UserJoined;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserJoined create() => UserJoined._();
  UserJoined createEmptyInstance() => create();
  static $pb.PbList<UserJoined> createRepeated() => $pb.PbList<UserJoined>();
  @$core.pragma('dart2js:noInline')
  static UserJoined getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserJoined>(create);
  static UserJoined? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);
}

class UserLeft extends $pb.GeneratedMessage {
  factory UserLeft({
    $core.String? clientId,
    $core.String? username,
  }) {
    final $result = create();
    if (clientId != null) {
      $result.clientId = clientId;
    }
    if (username != null) {
      $result.username = username;
    }
    return $result;
  }
  UserLeft._() : super();
  factory UserLeft.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserLeft.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserLeft', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserLeft clone() => UserLeft()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserLeft copyWith(void Function(UserLeft) updates) => super.copyWith((message) => updates(message as UserLeft)) as UserLeft;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserLeft create() => UserLeft._();
  UserLeft createEmptyInstance() => create();
  static $pb.PbList<UserLeft> createRepeated() => $pb.PbList<UserLeft>();
  @$core.pragma('dart2js:noInline')
  static UserLeft getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserLeft>(create);
  static UserLeft? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);
}

class BroadcastedCanvasCommand extends $pb.GeneratedMessage {
  factory BroadcastedCanvasCommand({
    $core.String? fromClientId,
    CanvasCommand? command,
  }) {
    final $result = create();
    if (fromClientId != null) {
      $result.fromClientId = fromClientId;
    }
    if (command != null) {
      $result.command = command;
    }
    return $result;
  }
  BroadcastedCanvasCommand._() : super();
  factory BroadcastedCanvasCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastedCanvasCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BroadcastedCanvasCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromClientId')
    ..aOM<CanvasCommand>(2, _omitFieldNames ? '' : 'command', subBuilder: CanvasCommand.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastedCanvasCommand clone() => BroadcastedCanvasCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastedCanvasCommand copyWith(void Function(BroadcastedCanvasCommand) updates) => super.copyWith((message) => updates(message as BroadcastedCanvasCommand)) as BroadcastedCanvasCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BroadcastedCanvasCommand create() => BroadcastedCanvasCommand._();
  BroadcastedCanvasCommand createEmptyInstance() => create();
  static $pb.PbList<BroadcastedCanvasCommand> createRepeated() => $pb.PbList<BroadcastedCanvasCommand>();
  @$core.pragma('dart2js:noInline')
  static BroadcastedCanvasCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastedCanvasCommand>(create);
  static BroadcastedCanvasCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromClientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromClientId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFromClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  CanvasCommand get command => $_getN(1);
  @$pb.TagNumber(2)
  set command(CanvasCommand v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCommand() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommand() => $_clearField(2);
  @$pb.TagNumber(2)
  CanvasCommand ensureCommand() => $_ensure(1);
}

class BroadcastedAudioChunk extends $pb.GeneratedMessage {
  factory BroadcastedAudioChunk({
    $core.String? fromClientId,
    AudioChunk? chunk,
  }) {
    final $result = create();
    if (fromClientId != null) {
      $result.fromClientId = fromClientId;
    }
    if (chunk != null) {
      $result.chunk = chunk;
    }
    return $result;
  }
  BroadcastedAudioChunk._() : super();
  factory BroadcastedAudioChunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastedAudioChunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BroadcastedAudioChunk', package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromClientId')
    ..aOM<AudioChunk>(2, _omitFieldNames ? '' : 'chunk', subBuilder: AudioChunk.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastedAudioChunk clone() => BroadcastedAudioChunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastedAudioChunk copyWith(void Function(BroadcastedAudioChunk) updates) => super.copyWith((message) => updates(message as BroadcastedAudioChunk)) as BroadcastedAudioChunk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BroadcastedAudioChunk create() => BroadcastedAudioChunk._();
  BroadcastedAudioChunk createEmptyInstance() => create();
  static $pb.PbList<BroadcastedAudioChunk> createRepeated() => $pb.PbList<BroadcastedAudioChunk>();
  @$core.pragma('dart2js:noInline')
  static BroadcastedAudioChunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastedAudioChunk>(create);
  static BroadcastedAudioChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromClientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromClientId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFromClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  AudioChunk get chunk => $_getN(1);
  @$pb.TagNumber(2)
  set chunk(AudioChunk v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasChunk() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunk() => $_clearField(2);
  @$pb.TagNumber(2)
  AudioChunk ensureChunk() => $_ensure(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
