import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/theme_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Size? fixedSize;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    this.trailingIcon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.fixedSize,
    this.borderSide,
    this.padding,
    this.borderRadius,
    this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: fixedSize ?? Size(90.w, 8.h),
        backgroundColor: backgroundColor ?? primaryColor,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          side: borderSide ?? BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style:
                textStyle ??
                TextStyle(
                  fontFamily: 'NotoKufiArabic',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(
              trailingIcon,
              size: 20,
              color: iconColor ?? textColor ?? Colors.white,
            ),
          ],
        ],
      ),
    );
  }
}
