import 'package:contact_tracer/model/health_status.dart';
import 'package:contact_tracer/view/feed_card.dart';
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
  _ContactTracerHomePageState createState() => _ContactTracerHomePageState(
    backendUrl: backendUrl
  );
}

class _ContactTracerHomePageState extends State<ContactTracerHomePage> {
  String backendUrl;
  HealthStatus _health = HealthStatus.unknown;
  bool _enabled = false;
  double _broadcastIntervalSec = 10;
  double _rollIntervalSec = 10;

  _ContactTracerHomePageState({this.backendUrl}) : super();

  void _queryHealth(BuildContext context) async {
    var response = await http.get('https://contact-tracer.xyz/api/v1/health');
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Got HTTP ${response.statusCode}'),
          content: Text(response.body),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
    setState(() {
      _health = response.statusCode == 200 ? HealthStatus.healthy : HealthStatus.exposed;
    });
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
                    setState(() {
                      _enabled = value;
                    });
                  },
                ),
                NumberListTile(
                  title: Text('Broadcast Interval'),
                  subtitle: Text('in seconds'),
                  value: _broadcastIntervalSec,
                  onEditingComplete: (value) {
                    setState(() {
                      _broadcastIntervalSec = value;
                    });
                  },
                ),
                NumberListTile(
                  title: Text('Roll Interval'),
                  subtitle: Text('in seconds'),
                  value: _rollIntervalSec,
                  onEditingComplete: (value) {
                    setState(() {
                      _rollIntervalSec = value;
                    });
                  },
                ),
              ],
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
            child: Text('Backend: $backendUrl')
          )
        )
      ),
    );
  }
}
