import 'dart:async';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(
      const Duration(
        seconds: 4,
      ),
          () {
        Navigator.of(context).pushNamed('/home');
      },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 270,
          width: 270,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/habit.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}