import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_response.dart';
import 'package:toshokan/config/app_sessions.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/models/user_model.dart';
import 'package:toshokan/pages/profile_page.dart';
import 'package:toshokan/providers/update_profile_provider.dart';
import 'package:toshokan/services/user_service.dart';
import 'package:toshokan/widgets/alert.dart';
import 'package:toshokan/widgets/x_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const UpdateProfilePage({super.key, required this.user});

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final affilationController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  update() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;

    setUpdateProfileStatus(ref, 'loading');

    UserService.updateProfile(
            name: nameController.text,
            email: mailController.text,
            phoneNumber: phoneNumberController.text,
            city: cityController.text,
            address: addressController.text,
            affilation: affilationController.text)
        .then((value) {
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
          setUpdateProfileStatus(ref, newStatus);
        },
        (results) {
          AppSession.setUser(results['user']);
          alert(context, 'Success', 'Login success, Enjoy your day', ContentType.success);
          setUpdateProfileStatus(ref, 'update profile success');
          Navo.replace(context, const ProfilePage());
        },
      );
    });
  }

  @override
  void initState() {
    nameController.text = widget.user.name;
    mailController.text = widget.user.email;
    cityController.text = widget.user.city ?? '';
    addressController.text = widget.user.address ?? '';
    phoneNumberController.text = widget.user.phoneNumber ?? '';
    affilationController.text = widget.user.affilation ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navo.replace(context, const ProfilePage()),
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Update Profile',
          style: AppFonts.subTextStyle.copyWith(color: Colors.white, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            Text(
              'Please fill in the following form with the latest data that matches your identity',
              style: AppFonts.darkTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(30),
                  XFormField(title: 'Name', type: TextInputType.text, controller: nameController),
                  const Gap(20),
                  XFormField(title: 'Email', type: TextInputType.emailAddress, controller: mailController),
                  const Gap(20),
                  Row(
                    children: [
                      Flexible(
                        child: XFormField(title: 'Phone Number', type: TextInputType.number, controller: phoneNumberController),
                      ),
                      const Gap(10),
                      Flexible(
                        child: XFormField(title: 'City', type: TextInputType.emailAddress, controller: cityController),
                      ),
                    ],
                  ),
                  const Gap(20),
                  XFormField(title: 'Address', type: TextInputType.text, controller: addressController),
                  const Gap(20),
                  XFormField(title: 'Affilation', type: TextInputType.text, controller: affilationController),
                  const Gap(40),
                  Consumer(builder: (_, wiRef, __) {
                    String status = wiRef.watch(updateProfileStatusProvider);
                    if (status == 'loading') {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () => update(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(20),
                      ),
                      child: Text(
                        'Update Profile',
                        style: AppFonts.subTextStyle.copyWith(color: Colors.white),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
