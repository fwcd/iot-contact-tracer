import 'package:contact_tracer/service/contact_tracer_service.dart';
import 'package:flutter/material.dart';

import 'view/home_page.dart';

void main() async {
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
      home: ContactTracerHomePage(
        title: 'IoT Contact Tracer',
        backendUrl: 'https://contact-tracer.xyz',
      ),
    );
  }
}
