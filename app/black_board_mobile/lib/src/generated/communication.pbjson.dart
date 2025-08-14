// This is a generated file - do not edit.
//
// Generated from communication.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use clientToServerDescriptor instead')
const ClientToServer$json = {
  '1': 'ClientToServer',
  '2': [
    {
      '1': 'initial_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.communication.InitialRequest',
      '9': 0,
      '10': 'initialRequest'
    },
    {
      '1': 'room_message',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.RoomMessage',
      '9': 0,
      '10': 'roomMessage'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `ClientToServer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientToServerDescriptor = $convert.base64Decode(
    'Cg5DbGllbnRUb1NlcnZlchJICg9pbml0aWFsX3JlcXVlc3QYASABKAsyHS5jb21tdW5pY2F0aW'
    '9uLkluaXRpYWxSZXF1ZXN0SABSDmluaXRpYWxSZXF1ZXN0Ej8KDHJvb21fbWVzc2FnZRgCIAEo'
    'CzIaLmNvbW11bmljYXRpb24uUm9vbU1lc3NhZ2VIAFILcm9vbU1lc3NhZ2VCCQoHcGF5bG9hZA'
    '==');

@$core.Deprecated('Use initialRequestDescriptor instead')
const InitialRequest$json = {
  '1': 'InitialRequest',
  '2': [
    {
      '1': 'create_room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.communication.CreateRoomRequest',
      '9': 0,
      '10': 'createRoom'
    },
    {
      '1': 'join_room',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.JoinRoomRequest',
      '9': 0,
      '10': 'joinRoom'
    },
    {
      '1': 'replay_room',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.communication.ReplayRoomRequest',
      '9': 0,
      '10': 'replayRoom'
    },
    {
      '1': 'list_recordings',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.communication.ListRecordingsRequest',
      '9': 0,
      '10': 'listRecordings'
    },
    {
      '1': 'list_public_rooms',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.communication.ListPublicRoomsRequest',
      '9': 0,
      '10': 'listPublicRooms'
    },
  ],
  '8': [
    {'1': 'request_type'},
  ],
};

/// Descriptor for `InitialRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initialRequestDescriptor = $convert.base64Decode(
    'Cg5Jbml0aWFsUmVxdWVzdBJDCgtjcmVhdGVfcm9vbRgBIAEoCzIgLmNvbW11bmljYXRpb24uQ3'
    'JlYXRlUm9vbVJlcXVlc3RIAFIKY3JlYXRlUm9vbRI9Cglqb2luX3Jvb20YAiABKAsyHi5jb21t'
    'dW5pY2F0aW9uLkpvaW5Sb29tUmVxdWVzdEgAUghqb2luUm9vbRJDCgtyZXBsYXlfcm9vbRgDIA'
    'EoCzIgLmNvbW11bmljYXRpb24uUmVwbGF5Um9vbVJlcXVlc3RIAFIKcmVwbGF5Um9vbRJPCg9s'
    'aXN0X3JlY29yZGluZ3MYBCABKAsyJC5jb21tdW5pY2F0aW9uLkxpc3RSZWNvcmRpbmdzUmVxdW'
    'VzdEgAUg5saXN0UmVjb3JkaW5ncxJTChFsaXN0X3B1YmxpY19yb29tcxgFIAEoCzIlLmNvbW11'
    'bmljYXRpb24uTGlzdFB1YmxpY1Jvb21zUmVxdWVzdEgAUg9saXN0UHVibGljUm9vbXNCDgoMcm'
    'VxdWVzdF90eXBl');

@$core.Deprecated('Use listRecordingsRequestDescriptor instead')
const ListRecordingsRequest$json = {
  '1': 'ListRecordingsRequest',
};

/// Descriptor for `ListRecordingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRecordingsRequestDescriptor =
    $convert.base64Decode('ChVMaXN0UmVjb3JkaW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use listPublicRoomsRequestDescriptor instead')
const ListPublicRoomsRequest$json = {
  '1': 'ListPublicRoomsRequest',
};

/// Descriptor for `ListPublicRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPublicRoomsRequestDescriptor =
    $convert.base64Decode('ChZMaXN0UHVibGljUm9vbXNSZXF1ZXN0');

@$core.Deprecated('Use createRoomRequestDescriptor instead')
const CreateRoomRequest$json = {
  '1': 'CreateRoomRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `CreateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVSb29tUmVxdWVzdBIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWU=');

@$core.Deprecated('Use joinRoomRequestDescriptor instead')
const JoinRoomRequest$json = {
  '1': 'JoinRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `JoinRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomRequestDescriptor = $convert.base64Decode(
    'Cg9Kb2luUm9vbVJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEhoKCHVzZXJuYW1lGA'
    'IgASgJUgh1c2VybmFtZQ==');

@$core.Deprecated('Use replayRoomRequestDescriptor instead')
const ReplayRoomRequest$json = {
  '1': 'ReplayRoomRequest',
  '2': [
    {'1': 'log_filename', '3': 1, '4': 1, '5': 9, '10': 'logFilename'},
  ],
};

/// Descriptor for `ReplayRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replayRoomRequestDescriptor = $convert.base64Decode(
    'ChFSZXBsYXlSb29tUmVxdWVzdBIhCgxsb2dfZmlsZW5hbWUYASABKAlSC2xvZ0ZpbGVuYW1l');

@$core.Deprecated('Use roomMessageDescriptor instead')
const RoomMessage$json = {
  '1': 'RoomMessage',
  '2': [
    {
      '1': 'canvas_command',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.communication.CanvasCommand',
      '9': 0,
      '10': 'canvasCommand'
    },
    {
      '1': 'audio_chunk',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.AudioChunk',
      '9': 0,
      '10': 'audioChunk'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `RoomMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomMessageDescriptor = $convert.base64Decode(
    'CgtSb29tTWVzc2FnZRJFCg5jYW52YXNfY29tbWFuZBgBIAEoCzIcLmNvbW11bmljYXRpb24uQ2'
    'FudmFzQ29tbWFuZEgAUg1jYW52YXNDb21tYW5kEjwKC2F1ZGlvX2NodW5rGAIgASgLMhkuY29t'
    'bXVuaWNhdGlvbi5BdWRpb0NodW5rSABSCmF1ZGlvQ2h1bmtCCQoHcGF5bG9hZA==');

@$core.Deprecated('Use pointDescriptor instead')
const Point$json = {
  '1': 'Point',
  '2': [
    {'1': 'dx', '3': 1, '4': 1, '5': 2, '10': 'dx'},
    {'1': 'dy', '3': 2, '4': 1, '5': 2, '10': 'dy'},
  ],
};

/// Descriptor for `Point`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pointDescriptor = $convert
    .base64Decode('CgVQb2ludBIOCgJkeBgBIAEoAlICZHgSDgoCZHkYAiABKAJSAmR5');

@$core.Deprecated('Use pathStartDescriptor instead')
const PathStart$json = {
  '1': 'PathStart',
  '2': [
    {'1': 'path_id', '3': 1, '4': 1, '5': 4, '10': 'pathId'},
    {
      '1': 'point',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.Point',
      '10': 'point'
    },
    {'1': 'color', '3': 3, '4': 1, '5': 13, '10': 'color'},
    {'1': 'stroke_width', '3': 4, '4': 1, '5': 2, '10': 'strokeWidth'},
  ],
};

/// Descriptor for `PathStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathStartDescriptor = $convert.base64Decode(
    'CglQYXRoU3RhcnQSFwoHcGF0aF9pZBgBIAEoBFIGcGF0aElkEioKBXBvaW50GAIgASgLMhQuY2'
    '9tbXVuaWNhdGlvbi5Qb2ludFIFcG9pbnQSFAoFY29sb3IYAyABKA1SBWNvbG9yEiEKDHN0cm9r'
    'ZV93aWR0aBgEIAEoAlILc3Ryb2tlV2lkdGg=');

@$core.Deprecated('Use pathAppendDescriptor instead')
const PathAppend$json = {
  '1': 'PathAppend',
  '2': [
    {'1': 'path_id', '3': 1, '4': 1, '5': 4, '10': 'pathId'},
    {
      '1': 'point',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.Point',
      '10': 'point'
    },
  ],
};

/// Descriptor for `PathAppend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathAppendDescriptor = $convert.base64Decode(
    'CgpQYXRoQXBwZW5kEhcKB3BhdGhfaWQYASABKARSBnBhdGhJZBIqCgVwb2ludBgCIAEoCzIULm'
    'NvbW11bmljYXRpb24uUG9pbnRSBXBvaW50');

@$core.Deprecated('Use pathEndDescriptor instead')
const PathEnd$json = {
  '1': 'PathEnd',
  '2': [
    {'1': 'path_id', '3': 1, '4': 1, '5': 4, '10': 'pathId'},
  ],
};

/// Descriptor for `PathEnd`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathEndDescriptor =
    $convert.base64Decode('CgdQYXRoRW5kEhcKB3BhdGhfaWQYASABKARSBnBhdGhJZA==');

@$core.Deprecated('Use pathFullDescriptor instead')
const PathFull$json = {
  '1': 'PathFull',
  '2': [
    {'1': 'path_id', '3': 1, '4': 1, '5': 4, '10': 'pathId'},
    {
      '1': 'points',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.communication.Point',
      '10': 'points'
    },
    {'1': 'color', '3': 3, '4': 1, '5': 13, '10': 'color'},
    {'1': 'stroke_width', '3': 4, '4': 1, '5': 2, '10': 'strokeWidth'},
  ],
};

/// Descriptor for `PathFull`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathFullDescriptor = $convert.base64Decode(
    'CghQYXRoRnVsbBIXCgdwYXRoX2lkGAEgASgEUgZwYXRoSWQSLAoGcG9pbnRzGAIgAygLMhQuY2'
    '9tbXVuaWNhdGlvbi5Qb2ludFIGcG9pbnRzEhQKBWNvbG9yGAMgASgNUgVjb2xvchIhCgxzdHJv'
    'a2Vfd2lkdGgYBCABKAJSC3N0cm9rZVdpZHRo');

@$core.Deprecated('Use canvasCommandDescriptor instead')
const CanvasCommand$json = {
  '1': 'CanvasCommand',
  '2': [
    {'1': 'timestamp_ms', '3': 1, '4': 1, '5': 3, '10': 'timestampMs'},
    {
      '1': 'path_start',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.PathStart',
      '9': 0,
      '10': 'pathStart'
    },
    {
      '1': 'path_append',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.communication.PathAppend',
      '9': 0,
      '10': 'pathAppend'
    },
    {
      '1': 'path_end',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.communication.PathEnd',
      '9': 0,
      '10': 'pathEnd'
    },
  ],
  '8': [
    {'1': 'command_type'},
  ],
};

/// Descriptor for `CanvasCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List canvasCommandDescriptor = $convert.base64Decode(
    'Cg1DYW52YXNDb21tYW5kEiEKDHRpbWVzdGFtcF9tcxgBIAEoA1ILdGltZXN0YW1wTXMSOQoKcG'
    'F0aF9zdGFydBgCIAEoCzIYLmNvbW11bmljYXRpb24uUGF0aFN0YXJ0SABSCXBhdGhTdGFydBI8'
    'CgtwYXRoX2FwcGVuZBgDIAEoCzIZLmNvbW11bmljYXRpb24uUGF0aEFwcGVuZEgAUgpwYXRoQX'
    'BwZW5kEjMKCHBhdGhfZW5kGAQgASgLMhYuY29tbXVuaWNhdGlvbi5QYXRoRW5kSABSB3BhdGhF'
    'bmRCDgoMY29tbWFuZF90eXBl');

@$core.Deprecated('Use audioChunkDescriptor instead')
const AudioChunk$json = {
  '1': 'AudioChunk',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'sequence', '3': 2, '4': 1, '5': 3, '10': 'sequence'},
  ],
};

/// Descriptor for `AudioChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioChunkDescriptor = $convert.base64Decode(
    'CgpBdWRpb0NodW5rEhIKBGRhdGEYASABKAxSBGRhdGESGgoIc2VxdWVuY2UYAiABKANSCHNlcX'
    'VlbmNl');

@$core.Deprecated('Use serverToClientDescriptor instead')
const ServerToClient$json = {
  '1': 'ServerToClient',
  '2': [
    {
      '1': 'initial_response',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.communication.InitialResponse',
      '9': 0,
      '10': 'initialResponse'
    },
    {
      '1': 'room_event',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.RoomEvent',
      '9': 0,
      '10': 'roomEvent'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `ServerToClient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverToClientDescriptor = $convert.base64Decode(
    'Cg5TZXJ2ZXJUb0NsaWVudBJLChBpbml0aWFsX3Jlc3BvbnNlGAEgASgLMh4uY29tbXVuaWNhdG'
    'lvbi5Jbml0aWFsUmVzcG9uc2VIAFIPaW5pdGlhbFJlc3BvbnNlEjkKCnJvb21fZXZlbnQYAiAB'
    'KAsyGC5jb21tdW5pY2F0aW9uLlJvb21FdmVudEgAUglyb29tRXZlbnRCCQoHcGF5bG9hZA==');

@$core.Deprecated('Use initialResponseDescriptor instead')
const InitialResponse$json = {
  '1': 'InitialResponse',
  '2': [
    {
      '1': 'create_room_response',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.communication.CreateRoomResponse',
      '9': 0,
      '10': 'createRoomResponse'
    },
    {
      '1': 'join_room_response',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.JoinRoomResponse',
      '9': 0,
      '10': 'joinRoomResponse'
    },
    {
      '1': 'error_response',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.communication.ErrorResponse',
      '9': 0,
      '10': 'errorResponse'
    },
    {
      '1': 'list_recordings_response',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.communication.ListRecordingsResponse',
      '9': 0,
      '10': 'listRecordingsResponse'
    },
    {
      '1': 'list_public_rooms_response',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.communication.ListPublicRoomsResponse',
      '9': 0,
      '10': 'listPublicRoomsResponse'
    },
  ],
  '8': [
    {'1': 'response_type'},
  ],
};

/// Descriptor for `InitialResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initialResponseDescriptor = $convert.base64Decode(
    'Cg9Jbml0aWFsUmVzcG9uc2USVQoUY3JlYXRlX3Jvb21fcmVzcG9uc2UYASABKAsyIS5jb21tdW'
    '5pY2F0aW9uLkNyZWF0ZVJvb21SZXNwb25zZUgAUhJjcmVhdGVSb29tUmVzcG9uc2USTwoSam9p'
    'bl9yb29tX3Jlc3BvbnNlGAIgASgLMh8uY29tbXVuaWNhdGlvbi5Kb2luUm9vbVJlc3BvbnNlSA'
    'BSEGpvaW5Sb29tUmVzcG9uc2USRQoOZXJyb3JfcmVzcG9uc2UYAyABKAsyHC5jb21tdW5pY2F0'
    'aW9uLkVycm9yUmVzcG9uc2VIAFINZXJyb3JSZXNwb25zZRJhChhsaXN0X3JlY29yZGluZ3Nfcm'
    'VzcG9uc2UYBCABKAsyJS5jb21tdW5pY2F0aW9uLkxpc3RSZWNvcmRpbmdzUmVzcG9uc2VIAFIW'
    'bGlzdFJlY29yZGluZ3NSZXNwb25zZRJlChpsaXN0X3B1YmxpY19yb29tc19yZXNwb25zZRgFIA'
    'EoCzImLmNvbW11bmljYXRpb24uTGlzdFB1YmxpY1Jvb21zUmVzcG9uc2VIAFIXbGlzdFB1Ymxp'
    'Y1Jvb21zUmVzcG9uc2VCDwoNcmVzcG9uc2VfdHlwZQ==');

@$core.Deprecated('Use listRecordingsResponseDescriptor instead')
const ListRecordingsResponse$json = {
  '1': 'ListRecordingsResponse',
  '2': [
    {'1': 'filenames', '3': 1, '4': 3, '5': 9, '10': 'filenames'},
  ],
};

/// Descriptor for `ListRecordingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRecordingsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0UmVjb3JkaW5nc1Jlc3BvbnNlEhwKCWZpbGVuYW1lcxgBIAMoCVIJZmlsZW5hbWVz');

@$core.Deprecated('Use publicRoomInfoDescriptor instead')
const PublicRoomInfo$json = {
  '1': 'PublicRoomInfo',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'participant_count',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'participantCount'
    },
  ],
};

/// Descriptor for `PublicRoomInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicRoomInfoDescriptor = $convert.base64Decode(
    'Cg5QdWJsaWNSb29tSW5mbxIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSEgoEbmFtZRgCIAEoCV'
    'IEbmFtZRIrChFwYXJ0aWNpcGFudF9jb3VudBgDIAEoDVIQcGFydGljaXBhbnRDb3VudA==');

@$core.Deprecated('Use listPublicRoomsResponseDescriptor instead')
const ListPublicRoomsResponse$json = {
  '1': 'ListPublicRoomsResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.communication.PublicRoomInfo',
      '10': 'rooms'
    },
  ],
};

/// Descriptor for `ListPublicRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPublicRoomsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UHVibGljUm9vbXNSZXNwb25zZRIzCgVyb29tcxgBIAMoCzIdLmNvbW11bmljYXRpb2'
        '4uUHVibGljUm9vbUluZm9SBXJvb21z');

@$core.Deprecated('Use createRoomResponseDescriptor instead')
const CreateRoomResponse$json = {
  '1': 'CreateRoomResponse',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'participant_id', '3': 2, '4': 1, '5': 13, '10': 'participantId'},
  ],
};

/// Descriptor for `CreateRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVSb29tUmVzcG9uc2USFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEiUKDnBhcnRpY2'
    'lwYW50X2lkGAIgASgNUg1wYXJ0aWNpcGFudElk');

@$core.Deprecated('Use canvasSnapshotDescriptor instead')
const CanvasSnapshot$json = {
  '1': 'CanvasSnapshot',
  '2': [
    {
      '1': 'paths',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.communication.PathFull',
      '10': 'paths'
    },
  ],
};

/// Descriptor for `CanvasSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List canvasSnapshotDescriptor = $convert.base64Decode(
    'Cg5DYW52YXNTbmFwc2hvdBItCgVwYXRocxgBIAMoCzIXLmNvbW11bmljYXRpb24uUGF0aEZ1bG'
    'xSBXBhdGhz');

@$core.Deprecated('Use joinRoomResponseDescriptor instead')
const JoinRoomResponse$json = {
  '1': 'JoinRoomResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {'1': 'participant_id', '3': 2, '4': 1, '5': 13, '10': 'participantId'},
    {
      '1': 'initial_canvas_state',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.communication.CanvasSnapshot',
      '9': 0,
      '10': 'initialCanvasState',
      '17': true
    },
  ],
  '8': [
    {'1': '_initial_canvas_state'},
  ],
};

/// Descriptor for `JoinRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomResponseDescriptor = $convert.base64Decode(
    'ChBKb2luUm9vbVJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2USJQoOcGFydGljaX'
    'BhbnRfaWQYAiABKA1SDXBhcnRpY2lwYW50SWQSVAoUaW5pdGlhbF9jYW52YXNfc3RhdGUYAyAB'
    'KAsyHS5jb21tdW5pY2F0aW9uLkNhbnZhc1NuYXBzaG90SABSEmluaXRpYWxDYW52YXNTdGF0ZY'
    'gBAUIXChVfaW5pdGlhbF9jYW52YXNfc3RhdGU=');

@$core.Deprecated('Use errorResponseDescriptor instead')
const ErrorResponse$json = {
  '1': 'ErrorResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ErrorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorResponseDescriptor = $convert
    .base64Decode('Cg1FcnJvclJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use roomEventDescriptor instead')
const RoomEvent$json = {
  '1': 'RoomEvent',
  '2': [
    {
      '1': 'user_joined',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.communication.UserJoined',
      '9': 0,
      '10': 'userJoined'
    },
    {
      '1': 'user_left',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.UserLeft',
      '9': 0,
      '10': 'userLeft'
    },
    {
      '1': 'canvas_command',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.communication.BroadcastedCanvasCommand',
      '9': 0,
      '10': 'canvasCommand'
    },
    {
      '1': 'audio_chunk',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.communication.BroadcastedAudioChunk',
      '9': 0,
      '10': 'audioChunk'
    },
    {
      '1': 'host_ended_session',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.communication.HostEndedSession',
      '9': 0,
      '10': 'hostEndedSession'
    },
    {
      '1': 'canvas_snapshot',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.communication.CanvasSnapshot',
      '9': 0,
      '10': 'canvasSnapshot'
    },
  ],
  '8': [
    {'1': 'event_type'},
  ],
};

/// Descriptor for `RoomEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomEventDescriptor = $convert.base64Decode(
    'CglSb29tRXZlbnQSPAoLdXNlcl9qb2luZWQYASABKAsyGS5jb21tdW5pY2F0aW9uLlVzZXJKb2'
    'luZWRIAFIKdXNlckpvaW5lZBI2Cgl1c2VyX2xlZnQYAiABKAsyFy5jb21tdW5pY2F0aW9uLlVz'
    'ZXJMZWZ0SABSCHVzZXJMZWZ0ElAKDmNhbnZhc19jb21tYW5kGAMgASgLMicuY29tbXVuaWNhdG'
    'lvbi5Ccm9hZGNhc3RlZENhbnZhc0NvbW1hbmRIAFINY2FudmFzQ29tbWFuZBJHCgthdWRpb19j'
    'aHVuaxgEIAEoCzIkLmNvbW11bmljYXRpb24uQnJvYWRjYXN0ZWRBdWRpb0NodW5rSABSCmF1ZG'
    'lvQ2h1bmsSTwoSaG9zdF9lbmRlZF9zZXNzaW9uGAUgASgLMh8uY29tbXVuaWNhdGlvbi5Ib3N0'
    'RW5kZWRTZXNzaW9uSABSEGhvc3RFbmRlZFNlc3Npb24SSAoPY2FudmFzX3NuYXBzaG90GAYgAS'
    'gLMh0uY29tbXVuaWNhdGlvbi5DYW52YXNTbmFwc2hvdEgAUg5jYW52YXNTbmFwc2hvdEIMCgpl'
    'dmVudF90eXBl');

@$core.Deprecated('Use hostEndedSessionDescriptor instead')
const HostEndedSession$json = {
  '1': 'HostEndedSession',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `HostEndedSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostEndedSessionDescriptor = $convert.base64Decode(
    'ChBIb3N0RW5kZWRTZXNzaW9uEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use userJoinedDescriptor instead')
const UserJoined$json = {
  '1': 'UserJoined',
  '2': [
    {'1': 'participant_id', '3': 1, '4': 1, '5': 13, '10': 'participantId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'client_id_uuid', '3': 3, '4': 1, '5': 9, '10': 'clientIdUuid'},
  ],
};

/// Descriptor for `UserJoined`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userJoinedDescriptor = $convert.base64Decode(
    'CgpVc2VySm9pbmVkEiUKDnBhcnRpY2lwYW50X2lkGAEgASgNUg1wYXJ0aWNpcGFudElkEhoKCH'
    'VzZXJuYW1lGAIgASgJUgh1c2VybmFtZRIkCg5jbGllbnRfaWRfdXVpZBgDIAEoCVIMY2xpZW50'
    'SWRVdWlk');

@$core.Deprecated('Use userLeftDescriptor instead')
const UserLeft$json = {
  '1': 'UserLeft',
  '2': [
    {'1': 'participant_id', '3': 1, '4': 1, '5': 13, '10': 'participantId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `UserLeft`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userLeftDescriptor = $convert.base64Decode(
    'CghVc2VyTGVmdBIlCg5wYXJ0aWNpcGFudF9pZBgBIAEoDVINcGFydGljaXBhbnRJZBIaCgh1c2'
    'VybmFtZRgCIAEoCVIIdXNlcm5hbWU=');

@$core.Deprecated('Use broadcastedCanvasCommandDescriptor instead')
const BroadcastedCanvasCommand$json = {
  '1': 'BroadcastedCanvasCommand',
  '2': [
    {
      '1': 'from_participant_id',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'fromParticipantId'
    },
    {
      '1': 'command',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.CanvasCommand',
      '10': 'command'
    },
  ],
};

/// Descriptor for `BroadcastedCanvasCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastedCanvasCommandDescriptor = $convert.base64Decode(
    'ChhCcm9hZGNhc3RlZENhbnZhc0NvbW1hbmQSLgoTZnJvbV9wYXJ0aWNpcGFudF9pZBgBIAEoDV'
    'IRZnJvbVBhcnRpY2lwYW50SWQSNgoHY29tbWFuZBgCIAEoCzIcLmNvbW11bmljYXRpb24uQ2Fu'
    'dmFzQ29tbWFuZFIHY29tbWFuZA==');

@$core.Deprecated('Use broadcastedAudioChunkDescriptor instead')
const BroadcastedAudioChunk$json = {
  '1': 'BroadcastedAudioChunk',
  '2': [
    {
      '1': 'from_participant_id',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'fromParticipantId'
    },
    {
      '1': 'chunk',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.communication.AudioChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `BroadcastedAudioChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastedAudioChunkDescriptor = $convert.base64Decode(
    'ChVCcm9hZGNhc3RlZEF1ZGlvQ2h1bmsSLgoTZnJvbV9wYXJ0aWNpcGFudF9pZBgBIAEoDVIRZn'
    'JvbVBhcnRpY2lwYW50SWQSLwoFY2h1bmsYAiABKAsyGS5jb21tdW5pY2F0aW9uLkF1ZGlvQ2h1'
    'bmtSBWNodW5r');
