import 'package:flutter/material.dart';

import '../screens/category.dart';

class CategoriesTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  CategoriesTile({required this.imgUrl, required this.title});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categories(
                      categoryName: title.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black26,
                height: 150,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
