import 'package:contact_tracer/feed_card.dart';
import 'package:contact_tracer/number_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ContactTracerApp());
}

class ContactTracerApp extends StatelessWidget {
  // The root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Contact Tracer',
      theme: ThemeData(
        // Primary application theme
        primarySwatch: Colors.blueGrey,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ContactTracerHomePage(title: 'IoT Contact Tracer'),
    );
  }
}

class ContactTracerHomePage extends StatefulWidget {
  ContactTracerHomePage({Key key, this.title}) : super(key: key);

  // Home page of the application.
  // Fields are always final in a widget subclass.

  final String title;

  @override
  _ContactTracerHomePageState createState() => _ContactTracerHomePageState();
}

class _ContactTracerHomePageState extends State<ContactTracerHomePage> {
  bool _healthy = false;
  bool _enabled = false;
  double _broadcastIntervalSec = 10;
  double _rollIntervalSec = 10;

  void _toggleExposed() {
    setState(() {
      _healthy = !_healthy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          FeedCard(
            color: _healthy ? Colors.green[700] : Colors.red,
            child: Column(
              children: <Widget>[
                Text(
                  _healthy ? 'Healthy' : 'Exposed',
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
        onPressed: _toggleExposed,
        tooltip: 'Set Exposed',
        child: Icon(Icons.error),
      ),
    );
  }
}
