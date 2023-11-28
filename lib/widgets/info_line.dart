import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toshokan/config/app_style.dart';

class InfoLine extends StatelessWidget {
  final String title;
  final String value;
  const InfoLine({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppFonts.darkTextStyle,
        ),
        const Gap(70),
        Expanded(
            child: Text(
          value,
          style: AppFonts.darkTextStyle,
          textAlign: TextAlign.right,
        )),
      ],
    );
  }
}
