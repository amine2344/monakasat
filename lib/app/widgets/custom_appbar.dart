import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:sizer/sizer.dart';

import '../controllers/theme_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final TextStyle? titleTextStyle;
  final Widget? leading;
  final Widget? trailing;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? titleSpacing;
  final bool centerTitle;
  final IconData? endDrawerIcon;
  final VoidCallback? onEndDrawerPressed;
  final PreferredSizeWidget? bottom;
  final ShapeBorder? shape;
  final bool? fromDash;
  final double? toolbarHeight;

  const CustomAppBar({
    super.key,
    this.title,
    this.fromDash,
    this.titleText,
    this.titleTextStyle,
    this.trailing,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.titleSpacing,
    this.centerTitle = true,
    this.endDrawerIcon = Icons.menu,
    this.onEndDrawerPressed,
    this.bottom,
    this.shape,
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: (fromDash ?? false)
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Image.asset(
                'assets/images/logo-top.png',
                height: context.height * 0.1,
                width: context.width * .3,
                color: lightColor,
                colorBlendMode: BlendMode.srcIn,
              ),
            )
          : title ??
                (titleText != null
                    ? Text(
                        titleText!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: lightColor,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: [
        ...?actions,
        if (trailing != null)
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 5.w, right: 5.w),
            child: trailing!,
          ),
        if (onEndDrawerPressed != null)
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 5),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: lightColor.withOpacity(.8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(endDrawerIcon, color: primaryColor),
                  onPressed: onEndDrawerPressed,
                ),
              ),
            ),
          ),
      ],
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      titleSpacing: titleSpacing ?? theme.appBarTheme.titleSpacing,
      centerTitle: centerTitle,
      bottom: bottom,
      shape: shape,
      toolbarHeight: toolbarHeight ?? theme.appBarTheme.toolbarHeight,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
  );
}
