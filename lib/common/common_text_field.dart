import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trendiq/common/colors.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    this.controller,
    this.initialText,
    this.inputDecoration,
    this.inputFormatters,
    this.keyboardType,
    this.validator,
    this.hintText,
    this.labelText,
  });
  final TextEditingController? controller;
  final String? initialText;
  final InputDecoration? inputDecoration;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final String? hintText;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialText,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      validator: validator,
      decoration:
          inputDecoration ??
          InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: TextStyle(color: MyColors.primaryColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
    );
  }
}
