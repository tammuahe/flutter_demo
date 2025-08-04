import 'package:flutter/material.dart';
import 'package:flutter_demo/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.value.signOut();
          },
          child: Text('Đăng xuất'),
        ),
      ),
    );
  }
}
