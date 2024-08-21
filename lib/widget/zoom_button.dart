import 'package:flutter/material.dart';

class ZoomButton extends StatelessWidget {
  final void Function()? onTap;
  final IconData? icon;
  const ZoomButton({super.key, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Icon(icon, color: Colors.grey),
        ),
      ),
    );
  }
}
