import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/pages/auth/register_page.dart';
import 'package:toshokan/widgets/x_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;

    print('login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  height: 150,
                  image: AssetImage('assets/toshokan.png'),
                  fit: BoxFit.cover,
                ),
                const Gap(10),
                Text(
                  'Please Sign In With a valid\nEmail and Password',
                  style: AppFonts.darkTextStyle.copyWith(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      XFormField(
                        title: 'Email',
                        type: TextInputType.emailAddress,
                        controller: mailController,
                        obsecure: false,
                      ),
                      const Gap(20),
                      XFormField(
                        title: 'Password',
                        type: TextInputType.text,
                        controller: passwordController,
                        obsecure: true,
                      ),
                      const Gap(20),
                      ElevatedButton(
                        onPressed: () => execute(),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(25),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: AppFonts.subTextStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      const Gap(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not have an account ? ',
                            style: AppFonts.darkTextStyle,
                          ),
                          GestureDetector(
                            onTap: () => Navo.push(context, const RegisterPage()),
                            child: Text(
                              'Register here',
                              style: AppFonts.darkTextStyle.copyWith(
                                color: Colors.indigoAccent,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
