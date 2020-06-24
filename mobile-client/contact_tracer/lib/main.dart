import 'package:flutter/material.dart';

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
            body: Column(
                children: <Widget>[
                    Card(
                        color: _healthy ? Colors.green[700] : Colors.red,
                        child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                    children: <Widget>[
                                        Text(
                                            _healthy ? "Healthy" : "Exposed",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                    ],
                                )
                            )
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
