import 'package:flutter/material.dart';
import 'package:flutter_demo/auth_service.dart';
import 'package:flutter_demo/home.dart';
import 'package:flutter_demo/main.dart';
import 'package:lottie/lottie.dart';



class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SafeArea(
                child: Center(
                  child: Lottie.network(
                    'https://lottie.host/9dbd1032-6366-49e9-847f-3c0569d29cc1/gcDqMe5UYa.lottie',
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              widget = HomeScreen();
            } else {
              widget = pageIfNotConnected ?? const WelcomeScreen();
            }
            return widget;
          },
        );
      },
    );
  }
}
