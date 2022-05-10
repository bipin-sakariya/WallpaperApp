import 'package:flutter/material.dart';
import 'package:wallpaper/widgets/cacheNetworkImageView.dart';

class FullScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CacheNetworkImageView(
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}
