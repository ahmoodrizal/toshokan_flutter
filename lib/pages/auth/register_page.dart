import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_assets.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_response.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/pages/auth/login_page.dart';
import 'package:toshokan/providers/register_provider.dart';
import 'package:toshokan/services/user_service.dart';
import 'package:toshokan/widgets/alert.dart';
import 'package:toshokan/widgets/x_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;

    setRegisterStatus(ref, 'loading');

    UserService.register(
      name: nameController.text,
      email: mailController.text,
      password: passwordController.text,
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
          setRegisterStatus(ref, newStatus);
        },
        (results) {
          nameController.clear();
          mailController.clear();
          passwordController.clear();
          alert(context, 'Success', 'Register success, Sign in to continue', ContentType.success);
          setRegisterStatus(ref, 'Register success');
          Navo.replace(context, const LoginPage());
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
                  'Please fill form with a valid data',
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
                        title: 'Name',
                        type: TextInputType.text,
                        controller: nameController,
                      ),
                      const Gap(20),
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
                        String status = wiRef.watch(registerStatusProvider);
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
                            'Sign Up',
                            style: AppFonts.subTextStyle.copyWith(color: Colors.white),
                          ),
                        );
                      }),
                      const Gap(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have and account ? ',
                            style: AppFonts.darkTextStyle,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Sign In',
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
