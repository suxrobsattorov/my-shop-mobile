import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Widget child;
  final String number;

  const CustomCart({required this.number, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            alignment: Alignment.center,
            height: 12,
            width: 12,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
