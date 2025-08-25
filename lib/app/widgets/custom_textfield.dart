import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/theme_config.dart';
import '../controllers/theme_controller.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final TextStyle? textStyle;
  final Color? fillColor;
  final Color? borderColor;
  final bool isDropdown;
  final TextDirection? textDirection;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.prefixIcon,
    this.textDirection,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.textStyle,
    this.fillColor,
    this.borderColor,
    this.isDropdown = false,
    this.onTap,
    this.onChanged,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => TextFormField(
        controller: widget.controller,

        decoration: InputDecoration(
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: primaryColor)
              : null,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: primaryColor,
                  ),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                )
              : widget.isDropdown
              ? Icon(Icons.arrow_drop_down, color: primaryColor)
              : widget.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          filled: true,
          fillColor: widget.fillColor ?? Colors.grey[200],
          labelStyle: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            color: darkColor,
          ),
        ),
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText && _isObscured,
        cursorColor: primaryColor,
        maxLines: widget.maxLines,
        style:
            widget.textStyle ??
            const TextStyle(fontFamily: 'NotoKufiArabic', color: darkColor),
        validator: widget.validator,
        readOnly: widget.isDropdown,
        onTap: widget.isDropdown ? widget.onTap : null,
        onChanged: widget.onChanged,
        textDirection: themeController.textDirection.value,
        textAlign: themeController.textDirection.value == TextDirection.rtl
            ? TextAlign.right
            : TextAlign.left,
      ),
    );
  }
}
