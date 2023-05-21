// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.inputFormatters,
    this.validator,
    this.hintStyle,
    this.keyboardType,
    this.textCapitalization,
    this.maxLines,
  });
  final String? hintText;
  final void Function(String value)? onChanged;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String value)? onFieldSubmitted;
  final void Function(String? value)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value)? validator;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.black,
      ),
    );
    return TextFormField(
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: 12,
        ),
        isDense: true,
        border: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        disabledBorder: outlineInputBorder,
        hintStyle: hintStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
        hintText: hintText,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.backgroundColor,
    required this.label,
    required this.onPressed,
    this.labelColor,
    this.height,
    this.width,
    this.isBusy,
  });
  final Color? backgroundColor;
  final Color? labelColor;
  final String label;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final bool? isBusy;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      color: backgroundColor ?? Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      height: height ?? 47,
      minWidth: width,
      // ?? double.infinity,
      onPressed: isBusy ?? false ? () {} : onPressed,
      child: Visibility(
        visible: isBusy ?? false,
        replacement: Text(
          label,
          style: TextStyle(
            color: labelColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: const CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }
}
