import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_sessions.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/models/user_model.dart';
import 'package:toshokan/pages/auth/login_page.dart';
import 'package:toshokan/pages/loading_page.dart';
import 'package:toshokan/pages/transaction/user_transactions_page.dart';
import 'package:toshokan/pages/user/update_profile_page.dart';
import 'package:toshokan/services/user_service.dart';
import 'package:toshokan/widgets/info_line.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  logout() {
    UserService.logout().then((value) {
      AppSession.removeUser();
      AppSession.removeBearerToken();
      Navo.replace(context, const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSession.getUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return const LoadingPage();
        UserModel user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile',
              style: AppFonts.subTextStyle.copyWith(color: Colors.white, fontSize: 18),
            ),
            elevation: 0,
          ),
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Information',
                        style: AppFonts.darkTextStyle.copyWith(fontSize: 18),
                      ),
                      const Gap(20),
                      InfoLine(title: 'Name', value: user.name),
                      const Gap(10),
                      InfoLine(title: 'Email', value: user.email),
                      const Gap(10),
                      InfoLine(title: 'Curren Status', value: user.status),
                      const Gap(10),
                      InfoLine(title: 'Phone Number', value: user.phoneNumber ?? 'Not Set'),
                      const Gap(10),
                      InfoLine(title: 'City', value: user.city ?? 'Not Set'),
                      const Gap(10),
                      InfoLine(title: 'Address', value: user.address ?? 'Not Set'),
                      const Gap(10),
                      InfoLine(title: 'Affilation', value: user.affilation ?? 'Not Set'),
                      const Gap(30),
                      ListTile(
                        onTap: () => Navo.push(context, const UserTransactionPage()),
                        contentPadding: const EdgeInsets.symmetric(horizontal: -30),
                        dense: false,
                        horizontalTitleGap: 0,
                        leading: const Icon(Icons.shopify),
                        title: const Text('My Transactions'),
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        onTap: () => Navo.replace(context, UpdateProfilePage(user: user)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: -30),
                        dense: false,
                        horizontalTitleGap: 0,
                        leading: const Icon(Icons.account_circle),
                        title: const Text('Update Profile'),
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        onTap: () {},
                        contentPadding: const EdgeInsets.symmetric(horizontal: -30),
                        dense: false,
                        horizontalTitleGap: 0,
                        leading: const Icon(Icons.help_center),
                        title: const Text('Costumer Support'),
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      ListTile(
                        iconColor: Colors.red,
                        onTap: () => logout(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: -30),
                        dense: false,
                        horizontalTitleGap: 0,
                        leading: const Icon(Icons.close),
                        title: Text('Logout', style: AppFonts.darkTextStyle.copyWith(color: Colors.red)),
                        trailing: const Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
