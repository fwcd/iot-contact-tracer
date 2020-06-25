import 'dart:async';
import 'dart:math';

import 'package:beacon_broadcast/beacon_broadcast.dart';

const _broadcastInterval = Duration(seconds: 10);

class ContactTracerService {
  final tx = BeaconBroadcast();
  final Stream<int> currentIdentifier = _startGeneratingIdentifiers();

  List<StreamSubscription> _subscriptions = [];

  ContactTracerService() {
    // Magic UUID constant that is the same across all contact tracing nodes
    tx.setUUID("d1e58b99-ddfb-4f13-a8db-aa4019043fd3");
    currentIdentifier.listen((ident) { 
      tx.setIdentifier(ident.toString()); // TODO: iOS only, unfortunately
    });
  }

  static Stream<int> _startGeneratingIdentifiers() {
    var rng = Random();
    return Stream.periodic(
      _broadcastInterval,
      (_) {
        return rng.nextInt(1 << 16);
      }
    );
  }

  Future<void> _startRx() async {
    // TODO
  }

  Future<void> _startTx() async {
    // TODO
  }

  Future<void> start() async {
    await Future.wait([_startRx(), _startTx()]);
  }

  Future<void> stop() async {
    // TODO
  }
}
