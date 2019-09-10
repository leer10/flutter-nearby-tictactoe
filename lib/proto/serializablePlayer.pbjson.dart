///
//  Generated code. Do not modify.
//  source: serializablePlayer.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const SerializablePlayer$json = const {
  '1': 'SerializablePlayer',
  '2': const [
    const {'1': 'fancyName', '3': 1, '4': 1, '5': 9, '10': 'fancyName'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'randomID', '3': 7, '4': 1, '5': 5, '10': 'randomID'},
    const {'1': 'isCreator', '3': 3, '4': 1, '5': 8, '10': 'isCreator'},
    const {'1': 'isHost', '3': 4, '4': 1, '5': 8, '10': 'isHost'},
    const {'1': 'isSpectator', '3': 5, '4': 1, '5': 8, '10': 'isSpectator'},
    const {'1': 'intentPlay', '3': 6, '4': 1, '5': 8, '10': 'intentPlay'},
    const {'1': 'connectionType', '3': 8, '4': 1, '5': 14, '6': '.minigames.SerializablePlayer.ConnectionType', '10': 'connectionType'},
    const {'1': 'nearbyID', '3': 9, '4': 1, '5': 9, '9': 0, '10': 'nearbyID'},
  ],
  '4': const [SerializablePlayer_ConnectionType$json],
  '8': const [
    const {'1': 'connectionID'},
  ],
};

const SerializablePlayer_ConnectionType$json = const {
  '1': 'ConnectionType',
  '2': const [
    const {'1': 'Unknown', '2': 0},
    const {'1': 'Loopback', '2': 1},
    const {'1': 'Nearby', '2': 2},
  ],
};

const SerializablePlayerList$json = const {
  '1': 'SerializablePlayerList',
  '2': const [
    const {'1': 'players', '3': 1, '4': 3, '5': 11, '6': '.minigames.SerializablePlayer', '10': 'players'},
  ],
};

