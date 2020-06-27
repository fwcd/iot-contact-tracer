import 'dart:async';
import 'dart:convert';

import 'package:contact_tracer/model/health_status.dart';
import 'package:contact_tracer/service/contact_tracer_service.dart';
import 'package:contact_tracer/view/basic_alert_dialog.dart';
import 'package:contact_tracer/view/feed_card.dart';
import 'package:contact_tracer/view/identifier_list.dart';
import 'package:contact_tracer/view/number_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactTracerHomePage extends StatefulWidget {
  final String backendUrl;
  final String title;

  ContactTracerHomePage({Key key, this.backendUrl, this.title}) : super(key: key);

  // Home page of the application.
  // Fields are always final in a widget subclass.

  @override
  _ContactTracerHomePageState createState() =>_ContactTracerHomePageState(
    backendUrl: backendUrl
  );
}

class _ContactTracerHomePageState extends State<ContactTracerHomePage> {
  final String backendUrl;

  HealthStatus _health = HealthStatus.unknown;
  List<String> _exposedIdents = [];

  int _latestReceivedIdent;
  bool _enabled = false;
  bool _simulateExposure = false;

  ContactTracerService _contactTracer = ContactTracerService();
  Set<String> _ownIdents = Set();
  List<StreamSubscription> _contactTracingSubscriptions = [];

  _ContactTracerHomePageState({this.backendUrl});

  void _queryHealth(BuildContext context) async {
    var response = await http.get('https://contact-tracer.xyz/api/v1/exposures');
    var decoded = json.decode(response.body);
    List<String> exposures = decoded.map((e) => e['id']).toList().cast<String>();
    Set<String> exposureSet = exposures.toSet();
    bool exposed = _ownIdents.any((ident) => exposureSet.contains(ident)) || _simulateExposure;

    if (exposed && _health != HealthStatus.exposed) {
      await showDialog(
        context: context,
        builder: (context) => BasicAlertDialog(
          title: Text('You are at risk of being exposed to COVID-19! Your identifiers will now be uploaded to the server.'),
          content: Text(response.body),
        ),

        // TODO: Upload identifiers
      );
    }

    setState(() {
      _exposedIdents = exposures;
      _health = exposed ? HealthStatus.exposed : HealthStatus.healthy;
    });
  }

  void _setContactTracingEnabled(bool enabled, BuildContext context) async {
    try {
      if (_enabled != enabled) {
        if (enabled) {
          await _contactTracer.initialize();
          var stream = await _contactTracer.start();
          var sub = stream.listen((ident) {
            // TODO: Automatically perform health check,
            // perhaps in a throttled way?
            _ownIdents.add(ident.toRadixString(16));
            _latestReceivedIdent = ident;
          });
          _contactTracingSubscriptions.add(sub);
        } else {
          await _contactTracer.stop();
          _contactTracingSubscriptions.forEach((sub) { sub.cancel(); });
          _contactTracingSubscriptions = [];
        }
        setState(() {
          _enabled = enabled;
        });
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => BasicAlertDialog(
          title: Text('Could not toggle contact tracing'),
          content: Text(e.toString())
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color healthColor;

    switch (_health) {
      case HealthStatus.healthy:
        healthColor = Colors.green[700];
        break;
      case HealthStatus.exposed:
        healthColor = Colors.red;
        break;
      default:
        healthColor = Colors.grey;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          FeedCard(
            color: healthColor,
            child: Column(
              children: <Widget>[
                Text(
                  _health.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  )
                ),
              ],
            )
          ),
          FeedCard(
            child: Text(
              'The IoT contact tracer is an app that helps you stay stafe during the COVID-19 pandemic by detecting possible exposures through decentralized contact tracing.',
              style: TextStyle(
                color: Colors.grey[800]
              )
            )
          ),
          FeedCard(
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  value: _enabled,
                  title: Text('Enable Contact Tracing'),
                  subtitle: Text('Periodically broadcast identifiers to nearby devices.'),
                  onChanged: (value) {
                    _setContactTracingEnabled(value, context);
                  },
                ),
                SwitchListTile(
                  value: _simulateExposure,
                  title: Text('Simulate Exposure'),
                  subtitle: Text('Every health check is treated as an exposure.'),
                  onChanged: (value) {
                    setState(() {
                      _simulateExposure = value;
                    });
                  },
                )
              ],
            )
          ),
          FeedCard(
            child: IdentifierList(
              title: "Exposed Identifiers",
              identifiers: _exposedIdents,
            )
          ),
          FeedCard(
            child: IdentifierList(
              title: "Own Identifiers",
              identifiers: _ownIdents.toList(),
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _queryHealth(context); },
        tooltip: 'Check Health',
        child: Icon(Icons.healing),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 40.0,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: _latestReceivedIdent == null
              ? Text('Backend: $backendUrl')
              : Text('Latest Received Identifier: $_latestReceivedIdent')
          )
        )
      ),
    );
  }
}
