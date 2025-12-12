import 'package:flutter/material.dart';
import '../nav_bar/view.dart';
import '../../core/helper_methods.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  _goNext() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    navigateTo(page: const NavBarView(), withHistory: false);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: Image(
                image: AssetImage("assets/quran_logo.png"),
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
