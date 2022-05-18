import 'package:flutter/material.dart';

class Linha extends StatelessWidget {
  final double height;
  final Color? cor;

  const Linha({
    Key? key,
    required this.height,
    this.cor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      color: cor ?? Colors.blue,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
    );
  }
}
