// This is a generated file - do not edit.
//
// Generated from communication.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum ClientToServer_Payload { initialRequest, roomMessage, notSet }

class ClientToServer extends $pb.GeneratedMessage {
  factory ClientToServer({
    InitialRequest? initialRequest,
    RoomMessage? roomMessage,
  }) {
    final result = create();
    if (initialRequest != null) result.initialRequest = initialRequest;
    if (roomMessage != null) result.roomMessage = roomMessage;
    return result;
  }

  ClientToServer._();

  factory ClientToServer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientToServer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ClientToServer_Payload>
      _ClientToServer_PayloadByTag = {
    1: ClientToServer_Payload.initialRequest,
    2: ClientToServer_Payload.roomMessage,
    0: ClientToServer_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientToServer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<InitialRequest>(1, _omitFieldNames ? '' : 'initialRequest',
        subBuilder: InitialRequest.create)
    ..aOM<RoomMessage>(2, _omitFieldNames ? '' : 'roomMessage',
        subBuilder: RoomMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientToServer clone() => ClientToServer()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientToServer copyWith(void Function(ClientToServer) updates) =>
      super.copyWith((message) => updates(message as ClientToServer))
          as ClientToServer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientToServer create() => ClientToServer._();
  @$core.override
  ClientToServer createEmptyInstance() => create();
  static $pb.PbList<ClientToServer> createRepeated() =>
      $pb.PbList<ClientToServer>();
  @$core.pragma('dart2js:noInline')
  static ClientToServer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientToServer>(create);
  static ClientToServer? _defaultInstance;

  ClientToServer_Payload whichPayload() =>
      _ClientToServer_PayloadByTag[$_whichOneof(0)]!;
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  InitialRequest get initialRequest => $_getN(0);
  @$pb.TagNumber(1)
  set initialRequest(InitialRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInitialRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  InitialRequest ensureInitialRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  RoomMessage get roomMessage => $_getN(1);
  @$pb.TagNumber(2)
  set roomMessage(RoomMessage value) => $_setField(2, value);
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
  listRecordings,
  notSet
}

class InitialRequest extends $pb.GeneratedMessage {
  factory InitialRequest({
    CreateRoomRequest? createRoom,
    JoinRoomRequest? joinRoom,
    ReplayRoomRequest? replayRoom,
    ListRecordingsRequest? listRecordings,
  }) {
    final result = create();
    if (createRoom != null) result.createRoom = createRoom;
    if (joinRoom != null) result.joinRoom = joinRoom;
    if (replayRoom != null) result.replayRoom = replayRoom;
    if (listRecordings != null) result.listRecordings = listRecordings;
    return result;
  }

  InitialRequest._();

  factory InitialRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InitialRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, InitialRequest_RequestType>
      _InitialRequest_RequestTypeByTag = {
    1: InitialRequest_RequestType.createRoom,
    2: InitialRequest_RequestType.joinRoom,
    3: InitialRequest_RequestType.replayRoom,
    4: InitialRequest_RequestType.listRecordings,
    0: InitialRequest_RequestType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InitialRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<CreateRoomRequest>(1, _omitFieldNames ? '' : 'createRoom',
        subBuilder: CreateRoomRequest.create)
    ..aOM<JoinRoomRequest>(2, _omitFieldNames ? '' : 'joinRoom',
        subBuilder: JoinRoomRequest.create)
    ..aOM<ReplayRoomRequest>(3, _omitFieldNames ? '' : 'replayRoom',
        subBuilder: ReplayRoomRequest.create)
    ..aOM<ListRecordingsRequest>(4, _omitFieldNames ? '' : 'listRecordings',
        subBuilder: ListRecordingsRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitialRequest clone() => InitialRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitialRequest copyWith(void Function(InitialRequest) updates) =>
      super.copyWith((message) => updates(message as InitialRequest))
          as InitialRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitialRequest create() => InitialRequest._();
  @$core.override
  InitialRequest createEmptyInstance() => create();
  static $pb.PbList<InitialRequest> createRepeated() =>
      $pb.PbList<InitialRequest>();
  @$core.pragma('dart2js:noInline')
  static InitialRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InitialRequest>(create);
  static InitialRequest? _defaultInstance;

  InitialRequest_RequestType whichRequestType() =>
      _InitialRequest_RequestTypeByTag[$_whichOneof(0)]!;
  void clearRequestType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CreateRoomRequest get createRoom => $_getN(0);
  @$pb.TagNumber(1)
  set createRoom(CreateRoomRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCreateRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateRoomRequest ensureCreateRoom() => $_ensure(0);

  @$pb.TagNumber(2)
  JoinRoomRequest get joinRoom => $_getN(1);
  @$pb.TagNumber(2)
  set joinRoom(JoinRoomRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJoinRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearJoinRoom() => $_clearField(2);
  @$pb.TagNumber(2)
  JoinRoomRequest ensureJoinRoom() => $_ensure(1);

  @$pb.TagNumber(3)
  ReplayRoomRequest get replayRoom => $_getN(2);
  @$pb.TagNumber(3)
  set replayRoom(ReplayRoomRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReplayRoom() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplayRoom() => $_clearField(3);
  @$pb.TagNumber(3)
  ReplayRoomRequest ensureReplayRoom() => $_ensure(2);

  /// *** درخواست جدید برای گرفتن لیست جلسات ضبط شده ***
  @$pb.TagNumber(4)
  ListRecordingsRequest get listRecordings => $_getN(3);
  @$pb.TagNumber(4)
  set listRecordings(ListRecordingsRequest value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasListRecordings() => $_has(3);
  @$pb.TagNumber(4)
  void clearListRecordings() => $_clearField(4);
  @$pb.TagNumber(4)
  ListRecordingsRequest ensureListRecordings() => $_ensure(3);
}

/// *** پیام جدید برای درخواست لیست ***
class ListRecordingsRequest extends $pb.GeneratedMessage {
  factory ListRecordingsRequest() => create();

  ListRecordingsRequest._();

  factory ListRecordingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRecordingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRecordingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecordingsRequest clone() =>
      ListRecordingsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecordingsRequest copyWith(
          void Function(ListRecordingsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRecordingsRequest))
          as ListRecordingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRecordingsRequest create() => ListRecordingsRequest._();
  @$core.override
  ListRecordingsRequest createEmptyInstance() => create();
  static $pb.PbList<ListRecordingsRequest> createRepeated() =>
      $pb.PbList<ListRecordingsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRecordingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRecordingsRequest>(create);
  static ListRecordingsRequest? _defaultInstance;
}

class CreateRoomRequest extends $pb.GeneratedMessage {
  factory CreateRoomRequest({
    $core.String? username,
  }) {
    final result = create();
    if (username != null) result.username = username;
    return result;
  }

  CreateRoomRequest._();

  factory CreateRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomRequest clone() => CreateRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomRequest copyWith(void Function(CreateRoomRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRoomRequest))
          as CreateRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest create() => CreateRoomRequest._();
  @$core.override
  CreateRoomRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRoomRequest> createRepeated() =>
      $pb.PbList<CreateRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomRequest>(create);
  static CreateRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
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
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (username != null) result.username = username;
    return result;
  }

  JoinRoomRequest._();

  factory JoinRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomRequest clone() => JoinRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomRequest copyWith(void Function(JoinRoomRequest) updates) =>
      super.copyWith((message) => updates(message as JoinRoomRequest))
          as JoinRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest create() => JoinRoomRequest._();
  @$core.override
  JoinRoomRequest createEmptyInstance() => create();
  static $pb.PbList<JoinRoomRequest> createRepeated() =>
      $pb.PbList<JoinRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRoomRequest>(create);
  static JoinRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);
}

class ReplayRoomRequest extends $pb.GeneratedMessage {
  factory ReplayRoomRequest({
    $core.String? logFilename,
  }) {
    final result = create();
    if (logFilename != null) result.logFilename = logFilename;
    return result;
  }

  ReplayRoomRequest._();

  factory ReplayRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplayRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplayRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'logFilename')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplayRoomRequest clone() => ReplayRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplayRoomRequest copyWith(void Function(ReplayRoomRequest) updates) =>
      super.copyWith((message) => updates(message as ReplayRoomRequest))
          as ReplayRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplayRoomRequest create() => ReplayRoomRequest._();
  @$core.override
  ReplayRoomRequest createEmptyInstance() => create();
  static $pb.PbList<ReplayRoomRequest> createRepeated() =>
      $pb.PbList<ReplayRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static ReplayRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplayRoomRequest>(create);
  static ReplayRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get logFilename => $_getSZ(0);
  @$pb.TagNumber(1)
  set logFilename($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLogFilename() => $_has(0);
  @$pb.TagNumber(1)
  void clearLogFilename() => $_clearField(1);
}

enum RoomMessage_Payload { canvasCommand, audioChunk, notSet }

class RoomMessage extends $pb.GeneratedMessage {
  factory RoomMessage({
    CanvasCommand? canvasCommand,
    AudioChunk? audioChunk,
  }) {
    final result = create();
    if (canvasCommand != null) result.canvasCommand = canvasCommand;
    if (audioChunk != null) result.audioChunk = audioChunk;
    return result;
  }

  RoomMessage._();

  factory RoomMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RoomMessage_Payload>
      _RoomMessage_PayloadByTag = {
    1: RoomMessage_Payload.canvasCommand,
    2: RoomMessage_Payload.audioChunk,
    0: RoomMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<CanvasCommand>(1, _omitFieldNames ? '' : 'canvasCommand',
        subBuilder: CanvasCommand.create)
    ..aOM<AudioChunk>(2, _omitFieldNames ? '' : 'audioChunk',
        subBuilder: AudioChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMessage clone() => RoomMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMessage copyWith(void Function(RoomMessage) updates) =>
      super.copyWith((message) => updates(message as RoomMessage))
          as RoomMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomMessage create() => RoomMessage._();
  @$core.override
  RoomMessage createEmptyInstance() => create();
  static $pb.PbList<RoomMessage> createRepeated() => $pb.PbList<RoomMessage>();
  @$core.pragma('dart2js:noInline')
  static RoomMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomMessage>(create);
  static RoomMessage? _defaultInstance;

  RoomMessage_Payload whichPayload() =>
      _RoomMessage_PayloadByTag[$_whichOneof(0)]!;
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CanvasCommand get canvasCommand => $_getN(0);
  @$pb.TagNumber(1)
  set canvasCommand(CanvasCommand value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCanvasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCanvasCommand() => $_clearField(1);
  @$pb.TagNumber(1)
  CanvasCommand ensureCanvasCommand() => $_ensure(0);

  @$pb.TagNumber(2)
  AudioChunk get audioChunk => $_getN(1);
  @$pb.TagNumber(2)
  set audioChunk(AudioChunk value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAudioChunk() => $_has(1);
  @$pb.TagNumber(2)
  void clearAudioChunk() => $_clearField(2);
  @$pb.TagNumber(2)
  AudioChunk ensureAudioChunk() => $_ensure(1);
}

class Point extends $pb.GeneratedMessage {
  factory Point({
    $core.double? dx,
    $core.double? dy,
  }) {
    final result = create();
    if (dx != null) result.dx = dx;
    if (dy != null) result.dy = dy;
    return result;
  }

  Point._();

  factory Point.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Point.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Point',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'dx', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'dy', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Point clone() => Point()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Point copyWith(void Function(Point) updates) =>
      super.copyWith((message) => updates(message as Point)) as Point;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point create() => Point._();
  @$core.override
  Point createEmptyInstance() => create();
  static $pb.PbList<Point> createRepeated() => $pb.PbList<Point>();
  @$core.pragma('dart2js:noInline')
  static Point getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point>(create);
  static Point? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get dx => $_getN(0);
  @$pb.TagNumber(1)
  set dx($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDx() => $_has(0);
  @$pb.TagNumber(1)
  void clearDx() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get dy => $_getN(1);
  @$pb.TagNumber(2)
  set dy($core.double value) => $_setDouble(1, value);
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
    final result = create();
    if (id != null) result.id = id;
    if (point != null) result.point = point;
    if (color != null) result.color = color;
    if (strokeWidth != null) result.strokeWidth = strokeWidth;
    return result;
  }

  PathStart._();

  factory PathStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PathStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PathStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Point>(2, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'color', $pb.PbFieldType.OU3)
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'strokeWidth', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PathStart clone() => PathStart()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PathStart copyWith(void Function(PathStart) updates) =>
      super.copyWith((message) => updates(message as PathStart)) as PathStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathStart create() => PathStart._();
  @$core.override
  PathStart createEmptyInstance() => create();
  static $pb.PbList<PathStart> createRepeated() => $pb.PbList<PathStart>();
  @$core.pragma('dart2js:noInline')
  static PathStart getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathStart>(create);
  static PathStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Point get point => $_getN(1);
  @$pb.TagNumber(2)
  set point(Point value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoint() => $_clearField(2);
  @$pb.TagNumber(2)
  Point ensurePoint() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get color => $_getIZ(2);
  @$pb.TagNumber(3)
  set color($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get strokeWidth => $_getN(3);
  @$pb.TagNumber(4)
  set strokeWidth($core.double value) => $_setDouble(3, value);
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
    final result = create();
    if (id != null) result.id = id;
    if (point != null) result.point = point;
    return result;
  }

  PathAppend._();

  factory PathAppend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PathAppend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PathAppend',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Point>(2, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PathAppend clone() => PathAppend()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PathAppend copyWith(void Function(PathAppend) updates) =>
      super.copyWith((message) => updates(message as PathAppend)) as PathAppend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathAppend create() => PathAppend._();
  @$core.override
  PathAppend createEmptyInstance() => create();
  static $pb.PbList<PathAppend> createRepeated() => $pb.PbList<PathAppend>();
  @$core.pragma('dart2js:noInline')
  static PathAppend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PathAppend>(create);
  static PathAppend? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Point get point => $_getN(1);
  @$pb.TagNumber(2)
  set point(Point value) => $_setField(2, value);
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
    final result = create();
    if (id != null) result.id = id;
    if (points != null) result.points.addAll(points);
    if (color != null) result.color = color;
    if (strokeWidth != null) result.strokeWidth = strokeWidth;
    return result;
  }

  PathFull._();

  factory PathFull.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PathFull.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PathFull',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..pc<Point>(2, _omitFieldNames ? '' : 'points', $pb.PbFieldType.PM,
        subBuilder: Point.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'color', $pb.PbFieldType.OU3)
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'strokeWidth', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PathFull clone() => PathFull()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PathFull copyWith(void Function(PathFull) updates) =>
      super.copyWith((message) => updates(message as PathFull)) as PathFull;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathFull create() => PathFull._();
  @$core.override
  PathFull createEmptyInstance() => create();
  static $pb.PbList<PathFull> createRepeated() => $pb.PbList<PathFull>();
  @$core.pragma('dart2js:noInline')
  static PathFull getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathFull>(create);
  static PathFull? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Point> get points => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get color => $_getIZ(2);
  @$pb.TagNumber(3)
  set color($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get strokeWidth => $_getN(3);
  @$pb.TagNumber(4)
  set strokeWidth($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStrokeWidth() => $_has(3);
  @$pb.TagNumber(4)
  void clearStrokeWidth() => $_clearField(4);
}

enum CanvasCommand_CommandType { pathStart, pathAppend, pathFull, notSet }

class CanvasCommand extends $pb.GeneratedMessage {
  factory CanvasCommand({
    $fixnum.Int64? timestampMs,
    PathStart? pathStart,
    PathAppend? pathAppend,
    PathFull? pathFull,
  }) {
    final result = create();
    if (timestampMs != null) result.timestampMs = timestampMs;
    if (pathStart != null) result.pathStart = pathStart;
    if (pathAppend != null) result.pathAppend = pathAppend;
    if (pathFull != null) result.pathFull = pathFull;
    return result;
  }

  CanvasCommand._();

  factory CanvasCommand.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CanvasCommand.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CanvasCommand_CommandType>
      _CanvasCommand_CommandTypeByTag = {
    2: CanvasCommand_CommandType.pathStart,
    3: CanvasCommand_CommandType.pathAppend,
    4: CanvasCommand_CommandType.pathFull,
    0: CanvasCommand_CommandType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CanvasCommand',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aInt64(1, _omitFieldNames ? '' : 'timestampMs')
    ..aOM<PathStart>(2, _omitFieldNames ? '' : 'pathStart',
        subBuilder: PathStart.create)
    ..aOM<PathAppend>(3, _omitFieldNames ? '' : 'pathAppend',
        subBuilder: PathAppend.create)
    ..aOM<PathFull>(4, _omitFieldNames ? '' : 'pathFull',
        subBuilder: PathFull.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanvasCommand clone() => CanvasCommand()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanvasCommand copyWith(void Function(CanvasCommand) updates) =>
      super.copyWith((message) => updates(message as CanvasCommand))
          as CanvasCommand;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CanvasCommand create() => CanvasCommand._();
  @$core.override
  CanvasCommand createEmptyInstance() => create();
  static $pb.PbList<CanvasCommand> createRepeated() =>
      $pb.PbList<CanvasCommand>();
  @$core.pragma('dart2js:noInline')
  static CanvasCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CanvasCommand>(create);
  static CanvasCommand? _defaultInstance;

  CanvasCommand_CommandType whichCommandType() =>
      _CanvasCommand_CommandTypeByTag[$_whichOneof(0)]!;
  void clearCommandType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestampMs => $_getI64(0);
  @$pb.TagNumber(1)
  set timestampMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestampMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampMs() => $_clearField(1);

  @$pb.TagNumber(2)
  PathStart get pathStart => $_getN(1);
  @$pb.TagNumber(2)
  set pathStart(PathStart value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPathStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPathStart() => $_clearField(2);
  @$pb.TagNumber(2)
  PathStart ensurePathStart() => $_ensure(1);

  @$pb.TagNumber(3)
  PathAppend get pathAppend => $_getN(2);
  @$pb.TagNumber(3)
  set pathAppend(PathAppend value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPathAppend() => $_has(2);
  @$pb.TagNumber(3)
  void clearPathAppend() => $_clearField(3);
  @$pb.TagNumber(3)
  PathAppend ensurePathAppend() => $_ensure(2);

  @$pb.TagNumber(4)
  PathFull get pathFull => $_getN(3);
  @$pb.TagNumber(4)
  set pathFull(PathFull value) => $_setField(4, value);
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
    final result = create();
    if (data != null) result.data = data;
    if (sequence != null) result.sequence = sequence;
    return result;
  }

  AudioChunk._();

  factory AudioChunk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AudioChunk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AudioChunk',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'sequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioChunk clone() => AudioChunk()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioChunk copyWith(void Function(AudioChunk) updates) =>
      super.copyWith((message) => updates(message as AudioChunk)) as AudioChunk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioChunk create() => AudioChunk._();
  @$core.override
  AudioChunk createEmptyInstance() => create();
  static $pb.PbList<AudioChunk> createRepeated() => $pb.PbList<AudioChunk>();
  @$core.pragma('dart2js:noInline')
  static AudioChunk getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AudioChunk>(create);
  static AudioChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sequence => $_getI64(1);
  @$pb.TagNumber(2)
  set sequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearSequence() => $_clearField(2);
}

enum ServerToClient_Payload { initialResponse, roomEvent, notSet }

class ServerToClient extends $pb.GeneratedMessage {
  factory ServerToClient({
    InitialResponse? initialResponse,
    RoomEvent? roomEvent,
  }) {
    final result = create();
    if (initialResponse != null) result.initialResponse = initialResponse;
    if (roomEvent != null) result.roomEvent = roomEvent;
    return result;
  }

  ServerToClient._();

  factory ServerToClient.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerToClient.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerToClient_Payload>
      _ServerToClient_PayloadByTag = {
    1: ServerToClient_Payload.initialResponse,
    2: ServerToClient_Payload.roomEvent,
    0: ServerToClient_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerToClient',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<InitialResponse>(1, _omitFieldNames ? '' : 'initialResponse',
        subBuilder: InitialResponse.create)
    ..aOM<RoomEvent>(2, _omitFieldNames ? '' : 'roomEvent',
        subBuilder: RoomEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerToClient clone() => ServerToClient()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerToClient copyWith(void Function(ServerToClient) updates) =>
      super.copyWith((message) => updates(message as ServerToClient))
          as ServerToClient;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerToClient create() => ServerToClient._();
  @$core.override
  ServerToClient createEmptyInstance() => create();
  static $pb.PbList<ServerToClient> createRepeated() =>
      $pb.PbList<ServerToClient>();
  @$core.pragma('dart2js:noInline')
  static ServerToClient getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerToClient>(create);
  static ServerToClient? _defaultInstance;

  ServerToClient_Payload whichPayload() =>
      _ServerToClient_PayloadByTag[$_whichOneof(0)]!;
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  InitialResponse get initialResponse => $_getN(0);
  @$pb.TagNumber(1)
  set initialResponse(InitialResponse value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInitialResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialResponse() => $_clearField(1);
  @$pb.TagNumber(1)
  InitialResponse ensureInitialResponse() => $_ensure(0);

  @$pb.TagNumber(2)
  RoomEvent get roomEvent => $_getN(1);
  @$pb.TagNumber(2)
  set roomEvent(RoomEvent value) => $_setField(2, value);
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
  listRecordingsResponse,
  notSet
}

class InitialResponse extends $pb.GeneratedMessage {
  factory InitialResponse({
    CreateRoomResponse? createRoomResponse,
    JoinRoomResponse? joinRoomResponse,
    ErrorResponse? errorResponse,
    ListRecordingsResponse? listRecordingsResponse,
  }) {
    final result = create();
    if (createRoomResponse != null)
      result.createRoomResponse = createRoomResponse;
    if (joinRoomResponse != null) result.joinRoomResponse = joinRoomResponse;
    if (errorResponse != null) result.errorResponse = errorResponse;
    if (listRecordingsResponse != null)
      result.listRecordingsResponse = listRecordingsResponse;
    return result;
  }

  InitialResponse._();

  factory InitialResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InitialResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, InitialResponse_ResponseType>
      _InitialResponse_ResponseTypeByTag = {
    1: InitialResponse_ResponseType.createRoomResponse,
    2: InitialResponse_ResponseType.joinRoomResponse,
    3: InitialResponse_ResponseType.errorResponse,
    4: InitialResponse_ResponseType.listRecordingsResponse,
    0: InitialResponse_ResponseType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InitialResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<CreateRoomResponse>(1, _omitFieldNames ? '' : 'createRoomResponse',
        subBuilder: CreateRoomResponse.create)
    ..aOM<JoinRoomResponse>(2, _omitFieldNames ? '' : 'joinRoomResponse',
        subBuilder: JoinRoomResponse.create)
    ..aOM<ErrorResponse>(3, _omitFieldNames ? '' : 'errorResponse',
        subBuilder: ErrorResponse.create)
    ..aOM<ListRecordingsResponse>(
        4, _omitFieldNames ? '' : 'listRecordingsResponse',
        subBuilder: ListRecordingsResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitialResponse clone() => InitialResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitialResponse copyWith(void Function(InitialResponse) updates) =>
      super.copyWith((message) => updates(message as InitialResponse))
          as InitialResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitialResponse create() => InitialResponse._();
  @$core.override
  InitialResponse createEmptyInstance() => create();
  static $pb.PbList<InitialResponse> createRepeated() =>
      $pb.PbList<InitialResponse>();
  @$core.pragma('dart2js:noInline')
  static InitialResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InitialResponse>(create);
  static InitialResponse? _defaultInstance;

  InitialResponse_ResponseType whichResponseType() =>
      _InitialResponse_ResponseTypeByTag[$_whichOneof(0)]!;
  void clearResponseType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CreateRoomResponse get createRoomResponse => $_getN(0);
  @$pb.TagNumber(1)
  set createRoomResponse(CreateRoomResponse value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCreateRoomResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateRoomResponse() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateRoomResponse ensureCreateRoomResponse() => $_ensure(0);

  @$pb.TagNumber(2)
  JoinRoomResponse get joinRoomResponse => $_getN(1);
  @$pb.TagNumber(2)
  set joinRoomResponse(JoinRoomResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJoinRoomResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearJoinRoomResponse() => $_clearField(2);
  @$pb.TagNumber(2)
  JoinRoomResponse ensureJoinRoomResponse() => $_ensure(1);

  @$pb.TagNumber(3)
  ErrorResponse get errorResponse => $_getN(2);
  @$pb.TagNumber(3)
  set errorResponse(ErrorResponse value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorResponse() => $_clearField(3);
  @$pb.TagNumber(3)
  ErrorResponse ensureErrorResponse() => $_ensure(2);

  /// *** پاسخ جدید شامل لیست نام فایل‌ها ***
  @$pb.TagNumber(4)
  ListRecordingsResponse get listRecordingsResponse => $_getN(3);
  @$pb.TagNumber(4)
  set listRecordingsResponse(ListRecordingsResponse value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasListRecordingsResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearListRecordingsResponse() => $_clearField(4);
  @$pb.TagNumber(4)
  ListRecordingsResponse ensureListRecordingsResponse() => $_ensure(3);
}

/// *** پیام جدید برای پاسخ لیست ***
class ListRecordingsResponse extends $pb.GeneratedMessage {
  factory ListRecordingsResponse({
    $core.Iterable<$core.String>? filenames,
  }) {
    final result = create();
    if (filenames != null) result.filenames.addAll(filenames);
    return result;
  }

  ListRecordingsResponse._();

  factory ListRecordingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRecordingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRecordingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'filenames')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecordingsResponse clone() =>
      ListRecordingsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecordingsResponse copyWith(
          void Function(ListRecordingsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRecordingsResponse))
          as ListRecordingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRecordingsResponse create() => ListRecordingsResponse._();
  @$core.override
  ListRecordingsResponse createEmptyInstance() => create();
  static $pb.PbList<ListRecordingsResponse> createRepeated() =>
      $pb.PbList<ListRecordingsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListRecordingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRecordingsResponse>(create);
  static ListRecordingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get filenames => $_getList(0);
}

class CreateRoomResponse extends $pb.GeneratedMessage {
  factory CreateRoomResponse({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  CreateRoomResponse._();

  factory CreateRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomResponse clone() => CreateRoomResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomResponse copyWith(void Function(CreateRoomResponse) updates) =>
      super.copyWith((message) => updates(message as CreateRoomResponse))
          as CreateRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse create() => CreateRoomResponse._();
  @$core.override
  CreateRoomResponse createEmptyInstance() => create();
  static $pb.PbList<CreateRoomResponse> createRepeated() =>
      $pb.PbList<CreateRoomResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomResponse>(create);
  static CreateRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class JoinRoomResponse extends $pb.GeneratedMessage {
  factory JoinRoomResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  JoinRoomResponse._();

  factory JoinRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomResponse clone() => JoinRoomResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomResponse copyWith(void Function(JoinRoomResponse) updates) =>
      super.copyWith((message) => updates(message as JoinRoomResponse))
          as JoinRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse create() => JoinRoomResponse._();
  @$core.override
  JoinRoomResponse createEmptyInstance() => create();
  static $pb.PbList<JoinRoomResponse> createRepeated() =>
      $pb.PbList<JoinRoomResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRoomResponse>(create);
  static JoinRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class ErrorResponse extends $pb.GeneratedMessage {
  factory ErrorResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  ErrorResponse._();

  factory ErrorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResponse clone() => ErrorResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResponse copyWith(void Function(ErrorResponse) updates) =>
      super.copyWith((message) => updates(message as ErrorResponse))
          as ErrorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorResponse create() => ErrorResponse._();
  @$core.override
  ErrorResponse createEmptyInstance() => create();
  static $pb.PbList<ErrorResponse> createRepeated() =>
      $pb.PbList<ErrorResponse>();
  @$core.pragma('dart2js:noInline')
  static ErrorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorResponse>(create);
  static ErrorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
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
    final result = create();
    if (userJoined != null) result.userJoined = userJoined;
    if (userLeft != null) result.userLeft = userLeft;
    if (canvasCommand != null) result.canvasCommand = canvasCommand;
    if (audioChunk != null) result.audioChunk = audioChunk;
    if (hostEndedSession != null) result.hostEndedSession = hostEndedSession;
    return result;
  }

  RoomEvent._();

  factory RoomEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RoomEvent_EventType>
      _RoomEvent_EventTypeByTag = {
    1: RoomEvent_EventType.userJoined,
    2: RoomEvent_EventType.userLeft,
    3: RoomEvent_EventType.canvasCommand,
    4: RoomEvent_EventType.audioChunk,
    5: RoomEvent_EventType.hostEndedSession,
    0: RoomEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<UserJoined>(1, _omitFieldNames ? '' : 'userJoined',
        subBuilder: UserJoined.create)
    ..aOM<UserLeft>(2, _omitFieldNames ? '' : 'userLeft',
        subBuilder: UserLeft.create)
    ..aOM<BroadcastedCanvasCommand>(3, _omitFieldNames ? '' : 'canvasCommand',
        subBuilder: BroadcastedCanvasCommand.create)
    ..aOM<BroadcastedAudioChunk>(4, _omitFieldNames ? '' : 'audioChunk',
        subBuilder: BroadcastedAudioChunk.create)
    ..aOM<HostEndedSession>(5, _omitFieldNames ? '' : 'hostEndedSession',
        subBuilder: HostEndedSession.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomEvent clone() => RoomEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomEvent copyWith(void Function(RoomEvent) updates) =>
      super.copyWith((message) => updates(message as RoomEvent)) as RoomEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomEvent create() => RoomEvent._();
  @$core.override
  RoomEvent createEmptyInstance() => create();
  static $pb.PbList<RoomEvent> createRepeated() => $pb.PbList<RoomEvent>();
  @$core.pragma('dart2js:noInline')
  static RoomEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomEvent>(create);
  static RoomEvent? _defaultInstance;

  RoomEvent_EventType whichEventType() =>
      _RoomEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  UserJoined get userJoined => $_getN(0);
  @$pb.TagNumber(1)
  set userJoined(UserJoined value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUserJoined() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserJoined() => $_clearField(1);
  @$pb.TagNumber(1)
  UserJoined ensureUserJoined() => $_ensure(0);

  @$pb.TagNumber(2)
  UserLeft get userLeft => $_getN(1);
  @$pb.TagNumber(2)
  set userLeft(UserLeft value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserLeft() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserLeft() => $_clearField(2);
  @$pb.TagNumber(2)
  UserLeft ensureUserLeft() => $_ensure(1);

  @$pb.TagNumber(3)
  BroadcastedCanvasCommand get canvasCommand => $_getN(2);
  @$pb.TagNumber(3)
  set canvasCommand(BroadcastedCanvasCommand value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCanvasCommand() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanvasCommand() => $_clearField(3);
  @$pb.TagNumber(3)
  BroadcastedCanvasCommand ensureCanvasCommand() => $_ensure(2);

  @$pb.TagNumber(4)
  BroadcastedAudioChunk get audioChunk => $_getN(3);
  @$pb.TagNumber(4)
  set audioChunk(BroadcastedAudioChunk value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAudioChunk() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudioChunk() => $_clearField(4);
  @$pb.TagNumber(4)
  BroadcastedAudioChunk ensureAudioChunk() => $_ensure(3);

  @$pb.TagNumber(5)
  HostEndedSession get hostEndedSession => $_getN(4);
  @$pb.TagNumber(5)
  set hostEndedSession(HostEndedSession value) => $_setField(5, value);
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
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  HostEndedSession._();

  factory HostEndedSession.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HostEndedSession.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostEndedSession',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostEndedSession clone() => HostEndedSession()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostEndedSession copyWith(void Function(HostEndedSession) updates) =>
      super.copyWith((message) => updates(message as HostEndedSession))
          as HostEndedSession;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HostEndedSession create() => HostEndedSession._();
  @$core.override
  HostEndedSession createEmptyInstance() => create();
  static $pb.PbList<HostEndedSession> createRepeated() =>
      $pb.PbList<HostEndedSession>();
  @$core.pragma('dart2js:noInline')
  static HostEndedSession getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostEndedSession>(create);
  static HostEndedSession? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
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
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (username != null) result.username = username;
    return result;
  }

  UserJoined._();

  factory UserJoined.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserJoined.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserJoined',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserJoined clone() => UserJoined()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserJoined copyWith(void Function(UserJoined) updates) =>
      super.copyWith((message) => updates(message as UserJoined)) as UserJoined;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserJoined create() => UserJoined._();
  @$core.override
  UserJoined createEmptyInstance() => create();
  static $pb.PbList<UserJoined> createRepeated() => $pb.PbList<UserJoined>();
  @$core.pragma('dart2js:noInline')
  static UserJoined getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserJoined>(create);
  static UserJoined? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
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
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (username != null) result.username = username;
    return result;
  }

  UserLeft._();

  factory UserLeft.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserLeft.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserLeft',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLeft clone() => UserLeft()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLeft copyWith(void Function(UserLeft) updates) =>
      super.copyWith((message) => updates(message as UserLeft)) as UserLeft;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserLeft create() => UserLeft._();
  @$core.override
  UserLeft createEmptyInstance() => create();
  static $pb.PbList<UserLeft> createRepeated() => $pb.PbList<UserLeft>();
  @$core.pragma('dart2js:noInline')
  static UserLeft getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserLeft>(create);
  static UserLeft? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
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
    final result = create();
    if (fromClientId != null) result.fromClientId = fromClientId;
    if (command != null) result.command = command;
    return result;
  }

  BroadcastedCanvasCommand._();

  factory BroadcastedCanvasCommand.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BroadcastedCanvasCommand.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BroadcastedCanvasCommand',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromClientId')
    ..aOM<CanvasCommand>(2, _omitFieldNames ? '' : 'command',
        subBuilder: CanvasCommand.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BroadcastedCanvasCommand clone() =>
      BroadcastedCanvasCommand()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BroadcastedCanvasCommand copyWith(
          void Function(BroadcastedCanvasCommand) updates) =>
      super.copyWith((message) => updates(message as BroadcastedCanvasCommand))
          as BroadcastedCanvasCommand;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BroadcastedCanvasCommand create() => BroadcastedCanvasCommand._();
  @$core.override
  BroadcastedCanvasCommand createEmptyInstance() => create();
  static $pb.PbList<BroadcastedCanvasCommand> createRepeated() =>
      $pb.PbList<BroadcastedCanvasCommand>();
  @$core.pragma('dart2js:noInline')
  static BroadcastedCanvasCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BroadcastedCanvasCommand>(create);
  static BroadcastedCanvasCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromClientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromClientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  CanvasCommand get command => $_getN(1);
  @$pb.TagNumber(2)
  set command(CanvasCommand value) => $_setField(2, value);
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
    final result = create();
    if (fromClientId != null) result.fromClientId = fromClientId;
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  BroadcastedAudioChunk._();

  factory BroadcastedAudioChunk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BroadcastedAudioChunk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BroadcastedAudioChunk',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'communication'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromClientId')
    ..aOM<AudioChunk>(2, _omitFieldNames ? '' : 'chunk',
        subBuilder: AudioChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BroadcastedAudioChunk clone() =>
      BroadcastedAudioChunk()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BroadcastedAudioChunk copyWith(
          void Function(BroadcastedAudioChunk) updates) =>
      super.copyWith((message) => updates(message as BroadcastedAudioChunk))
          as BroadcastedAudioChunk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BroadcastedAudioChunk create() => BroadcastedAudioChunk._();
  @$core.override
  BroadcastedAudioChunk createEmptyInstance() => create();
  static $pb.PbList<BroadcastedAudioChunk> createRepeated() =>
      $pb.PbList<BroadcastedAudioChunk>();
  @$core.pragma('dart2js:noInline')
  static BroadcastedAudioChunk getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BroadcastedAudioChunk>(create);
  static BroadcastedAudioChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromClientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromClientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  AudioChunk get chunk => $_getN(1);
  @$pb.TagNumber(2)
  set chunk(AudioChunk value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChunk() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunk() => $_clearField(2);
  @$pb.TagNumber(2)
  AudioChunk ensureChunk() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
