import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../screens/fullscreen.dart';
import 'cacheNetworkImageView.dart';

Widget showWallpaperWidget(
    {ScrollController? controller, required List images, String? key}) {
  return GridView.builder(
      key: PageStorageKey(key),
      shrinkWrap: true,
      controller: controller,
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 2,
          crossAxisCount: 3,
          childAspectRatio: 2 / 3,
          mainAxisSpacing: 2),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                  child: FullScreen(
                    imageUrl: images[index]['src']['large2x'],
                  ),
                  type: PageTransitionType.rightToLeft,
                ));
          },
          child: Container(
            color: Colors.white,
            child: CacheNetworkImageView(
              imageUrl: images[index]['src']['tiny'],
            ),
          ),
        );
      });
}

Widget textView({required String text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(text),
  );
}
