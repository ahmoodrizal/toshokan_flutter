import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_navigation.dart';
import 'package:toshokan/config/app_style.dart';
import 'package:toshokan/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Folks',
                              style: AppFonts.darkTextStyle.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              'What kind of book will you read today?, Let\'s find something interesting!',
                              style: AppFonts.darkTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navo.push(context, const ProfilePage()),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
