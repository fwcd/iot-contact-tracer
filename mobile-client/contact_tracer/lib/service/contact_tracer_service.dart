import 'dart:async';
import 'dart:math';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

const _broadcastInterval = Duration(seconds: 10);
const _identifier = "iot-contact-tracer";
const _identBits = 16;
const _identBytes = _identBits * 8;
const _maxIdent = 1 << _identBits;
const _magicUUIDPrefix = "d1e58b99-ddfb-4f13-a8db-aa401904"; // ...missing 2 bytes at the end

class ContactTracerService {
  final rx = flutterBeacon;
  final tx = BeaconBroadcast();
  final Stream<int> currentIdentifier = _startGeneratingIdentifiers();

  bool initialized = false;
  bool running = false;
  List<StreamSubscription> _subscriptions = [];

  Future<void> initialize() async {
    if (initialized) {
      return;
    }
    initialized = true;
    await rx.initializeAndCheckScanning;

    // Magic UUID constant that is the same across all contact tracing nodes
    tx.setIdentifier(_identifier); // TODO: iOS only, unfortunately
    tx.setUUID(_encodeAsUUID(Random().nextInt(_maxIdent)));
    currentIdentifier.listen((ident) { 
      tx.setUUID(_encodeAsUUID(ident));
    });
  }

  /// Starts the contact tracer and returns the stream of identifiers.
  Future<Stream<int>> start() async {
    if (running) {
      return Stream.empty();
    }
    running = true;
    await _startTx();
    return _startRx();
  }

  /// Stops the contact tracer.
  Future<void> stop() async {
    if (!running) {
      return;
    }
    await tx.stop();
    _subscriptions.forEach((sub) { sub.cancel(); });
    _subscriptions = [];
    running = false;
  }

  static Stream<int> _startGeneratingIdentifiers() {
    var rng = Random();
    return Stream.periodic(
      _broadcastInterval,
      (_) {
        return rng.nextInt(_maxIdent);
      }
    );
  }

  Stream<int> _startRx() {
    return rx
      .ranging(<Region>[Region(identifier: _identifier)])
      .expand((event) {
        // TODO: Filter based on proximity (above a certain threshold?)
        return event.beacons
          .map((b) => _decodeFromUUID(b.proximityUUID));
      });
  }

  Future<void> _startTx() async {
    await tx.start();
  }

  static String _encodeAsUUID(int ident) {
    return '$_magicUUIDPrefix${ident.toRadixString(16)}';
  }

  static int _decodeFromUUID(String uuid) {
    return int.parse(uuid.substring(uuid.length - (_identBytes * 2)), radix: 16);
  }
}
