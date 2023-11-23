import 'package:flutter/material.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_sessions.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/pages/auth/login_page.dart';
import 'package:toshokan/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  logout() {
    UserService.logout().then((value) {
      AppSession.removeUser();
      AppSession.removeBearerToken();
      Navo.replace(context, const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => logout(),
            child: Text(
              'Logout',
              style: AppFonts.subTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
