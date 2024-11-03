import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../src/app_colors.dart';

class MyField extends StatelessWidget {
  const MyField({super.key, required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 10,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '*Empty';
          }
          if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
            return '*Incorrect format';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        inputFormatters: [FilteringTextInputFormatter.deny(' ')],
        textInputAction: TextInputAction.next,
        controller: controller,
        decoration: InputDecoration(
            errorStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            hintText: hint,
            hintStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            filled: true,
            suffixIcon: Icon(
              hint == 'Enter Case Number' ? Icons.cases : Icons.key,
              color: AppColors.primary,
              size: 30,
            ),
            fillColor: AppColors.secondary,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}
