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
                primarySwatch: Colors.green,
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
    int _counter = 0;

    void _incrementCounter() {
        setState(() {
            _counter++;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Text('You have pressed the button this many times:'),
                        Text(
                            '$_counter',
                            style: Theme.of(context).textTheme.headline4,
                        ),
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: Icon(Icons.add),
            ),
        );
    }
}
