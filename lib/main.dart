import 'package:flutter/material.dart';
import 'package:photouploader_frontend/upload.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

void main() {
  FlavorConfig(variables: {
    "baseUrl": "https://photouploader.ddnsfree.com",
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FlavorBanner(
      child: MaterialApp(
        title: 'Upload Photos',
        home: UploadYourPhotos(),
      ),
    );
  }
}
