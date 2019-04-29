import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final Uri uri;

  ImageView({
    this.uri,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.network(
        uri.toString(),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
