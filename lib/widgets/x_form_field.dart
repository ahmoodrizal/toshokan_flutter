import 'package:flutter/material.dart';
import 'package:toshokan/config/app_style.dart';

class XFormField extends StatelessWidget {
  final String title;
  final TextInputType type;
  final TextEditingController controller;
  final bool obsecure;
  const XFormField({
    super.key,
    required this.title,
    required this.type,
    required this.controller,
    this.obsecure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecure,
      validator: (value) => value!.isEmpty ? '$title is required' : null,
      controller: controller,
      keyboardType: type,
      style: AppFonts.darkTextStyle.copyWith(fontSize: 16),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: AppColors.primaryColor,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.indigo[300]!,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        label: Text(
          title,
          style: AppFonts.darkTextStyle,
        ),
      ),
    );
  }
}
