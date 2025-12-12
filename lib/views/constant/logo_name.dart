import 'package:flutter/material.dart';

class LogoName extends StatelessWidget {
  const LogoName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Spacer(),
          Image.asset(
            'assets/quran_logo.png',
            height: 200,
          ),
        ],
      ),
    );
  }
}
