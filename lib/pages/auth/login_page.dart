import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_assets.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_response.dart';
import 'package:toshokan/config/app_sessions.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/pages/auth/register_page.dart';
import 'package:toshokan/pages/home_page.dart';
import 'package:toshokan/providers/login_provider.dart';
import 'package:toshokan/services/user_service.dart';
import 'package:toshokan/widgets/alert.dart';
import 'package:toshokan/widgets/x_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;

    setLoginStatus(ref, 'loading');

    UserService.login(
      mailController.text,
      passwordController.text,
    ).then((value) {
      String newStatus = '';
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              newStatus = 'Server Error';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            case NotFoundFailure:
              newStatus = 'Error Not Found';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            case ForbiddenFailure:
              newStatus = 'You don\'t have an access';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            case BadRequestFailure:
              newStatus = 'Bad Request';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            case InvalidInputFailure:
              newStatus = 'Invalid Input';
              AppResponse.invalidInput(context, failure.message ?? '{}');
              break;
            case UnauthorizedFailure:
              newStatus = 'Unauthorized';
              alert(context, 'Error', newStatus, ContentType.failure);
              break;
            default:
              newStatus = 'Request Error';
              alert(context, 'Error', newStatus, ContentType.failure);
              newStatus = failure.message ?? '-';
              break;
          }
          setLoginStatus(ref, newStatus);
        },
        (results) {
          AppSession.setUser(results['data']);
          AppSession.setBearerToken(results['token']);
          alert(context, 'Success', 'Login success, Enjoy your day', ContentType.success);
          setLoginStatus(ref, 'Login Success');
          Navo.replace(context, const HomePage());
        },
      );
    });
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
                  height: 125,
                  image: AssetImage(AppAssets.logo),
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
                      ),
                      const Gap(20),
                      XFormField(
                        title: 'Password',
                        type: TextInputType.text,
                        controller: passwordController,
                        obsecure: true,
                      ),
                      const Gap(20),
                      Consumer(builder: (_, wiRef, __) {
                        String status = wiRef.watch(loginStatusProvider);
                        if (status == 'loading') {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        }
                        return ElevatedButton(
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
                        );
                      }),
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
                              'Sign Up',
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
