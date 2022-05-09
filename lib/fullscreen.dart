import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.network(imageUrl)),
    );
  }
}
