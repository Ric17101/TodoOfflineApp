import 'dart:async';
import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:todo_offline_app/persist/storage_engine.dart';
import 'package:flutter/foundation.dart';

// ignore_for_file: omit_local_variable_types
class StatePersistor<St> extends Persistor<St> {
  StatePersistor(this.storageEngine, this.serializer, {this.migration, this.transforms, this.rawTransforms});

  /// Storage engine to save/load from/to.
  final StorageEngine storageEngine;

  /// State serialized used to serialize the state to/from bytes.
  final StateSerializer<St?> serializer;

  /// Transformations on state to be applied on save/load.
  final Transforms<St?>? transforms;

  /// Transformations on raw data to be applied on save/load.
  final RawTransforms? rawTransforms;

  /// Migration applied to the data when version is not up to date.
  final Migration? migration;

  @override
  Future<void> deleteState() async {
    await storageEngine.delete();
  }

  @override
  Future<void> persistDifference({required St? lastPersistedState, required St newState}) async {
    if (lastPersistedState == newState) {
      _printDebug('State has not changed');
    } else {
      St? state = newState;
      if (transforms != null) {
        _printDebug('Running save transformations ...');
        try {
          for (Transformer<St?> transform in transforms!.onSave!) {
            state = transform(state);
          }
        } catch (e) {
          throw TransformationException('On save transformation: ${e.toString()}');
        }
      }
      Map<String, dynamic> json;
      _printDebug('Serializing ...');
      try {
        json = serializer.encode(state);
      } catch (e) {
        throw SerializationException('On serialization: ${e.toString()}');
      }
      if (migration != null) {
        _printDebug('Set Version');
        json = <String, dynamic>{'version': migration!.version, 'state': json};
      }
      Uint8List uint8list = stringToUint8List(jsonEncode(json));
      if (rawTransforms != null) {
        _printDebug('Running save raw transformations ...');
        try {
          for (RawTransformer transform in rawTransforms!.onSave!) {
            uint8list = transform(uint8list);
          }
        } catch (e) {
          throw TransformationException('On save raw transformation: ${e.toString()}');
        }
      }
      _printDebug('Saving to storage ...');
      try {
        await storageEngine.save(uint8list);
      } catch (e) {
        throw StorageException('On save: ${e.toString()}');
      }
      _printDebug('Done saving!');
    }
  }

  @override
  Future<St?> readState() async {
    Uint8List? uint8list;
    _printDebug('Loading from storage ...');
    try {
      uint8list = await storageEngine.load();
    } catch (e) {
      throw StorageException('On load: ${e.toString()}');
    }
    if (uint8list == null) {
      _printDebug('Nothing in storage');
      return null;
    }
    if (rawTransforms != null) {
      _printDebug('Running load raw transformations');
      try {
        for (RawTransformer transform in rawTransforms!.onLoad!) {
          uint8list = transform(uint8list);
        }
      } catch (e) {
        throw TransformationException('On load raw transformation: ${e.toString()}');
      }
    }
    Map<String, dynamic>? json = jsonDecode(uint8ListToString(uint8list!)) as Map<String, dynamic>?;
    if (migration != null) {
      final int? old = json!['version'] as int?;
      if (old != null && old != migration!.version) {
        _printDebug('Migrating');
        try {
          json = migration!.migrate(json['state'] as Map<String, dynamic>?, old);
        } catch (e) {
          throw MigrationException('On migration: ${e.toString()}');
        }
      } else {
        json = json['state'] as Map<String, dynamic>?;
      }
    }
    St? state;
    _printDebug('Deserializing');
    try {
      state = serializer.decode(json);
    } catch (e) {
      throw SerializationException('On deserialization: ${e.toString()}');
    }
    if (transforms != null) {
      _printDebug('Running load transformations');
      try {
        for (Transformer<St?> transform in transforms!.onLoad!) {
          state = transform(state);
        }
      } catch (error) {
        throw TransformationException('On load transformation: ${error.toString()}');
      }
    }
    _printDebug('Done loading!');
    return state;
  }

  @override
  Duration? get throttle => null;
}

/// Serializer interface for turning state [St] into [Map<String, dynamic>], and back
abstract class StateSerializer<St> {
  Map<String, dynamic> encode(St state);

  St decode(Map<String, dynamic>? data);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// StateMigration
abstract class Migration {
  const Migration(this.version);

  final int version;

  Map<String, dynamic> migrate(Map<String, dynamic>? json, int oldVersion);
}

/// Transforms state to new state.
/// Do not mutate original state.
/// Could be ran with null state.
typedef Transformer<St> = St Function(St state);

/// Holds onSave and onLoad transformations.
class Transforms<St> {
  Transforms({this.onSave, this.onLoad});

  /// Transformation performed before saving.
  final List<Transformer<St>>? onSave;

  /// Transformation performed after loading.
  final List<Transformer<St>>? onLoad;
}

/// Transforms byte state data (immutable).
/// Do not mutate original data.
/// Could be ran with null or empty data.
typedef RawTransformer = Uint8List Function(Uint8List? data);

/// Holds onSave and onLoad raw transformations.
class RawTransforms {
  RawTransforms({this.onSave, this.onLoad});

  /// Raw transformation performed before saving.
  final List<RawTransformer>? onSave;

  /// Raw transformation performed after loading.
  final List<RawTransformer>? onLoad;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Uint8List stringToUint8List(String data) => Uint8List.fromList(utf8.encode(data));

String uint8ListToString(Uint8List data) => utf8.decode(data);

void _printDebug(Object object) {
  if (kDebugMode) {
    print('Persistor debug: $object');
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Transformation failed.
class TransformationException implements Exception {
  const TransformationException(this.msg);

  final String msg;

  @override
  String toString() => 'TransformationException: $msg';
}

/// Saving/loading failed.
class StorageException implements Exception {
  const StorageException(this.msg);

  final String msg;

  @override
  String toString() => 'StorageException: $msg';
}

/// Serialization failed.
class SerializationException implements Exception {
  const SerializationException(this.msg);

  final String msg;

  @override
  String toString() => 'SerializationException: $msg';
}

/// Migration failed.
class MigrationException implements Exception {
  const MigrationException(this.msg);

  final String msg;

  @override
  String toString() => 'MigrationException: $msg';
}
