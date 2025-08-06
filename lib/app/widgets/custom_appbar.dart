import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final TextStyle? titleTextStyle;
  final Widget? leading;
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
                'assets/images/logo.png',
                height: context.height * 0.06,
                width: context.width * .2,
              ),
            )
          : title ?? (titleText != null ? Text(titleText!) : null),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: [
        ...?actions,
        if (onEndDrawerPressed != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Card(
              elevation: 1,
              color: primaryColor,
              child: Center(
                child: IconButton(
                  icon: Icon(endDrawerIcon),
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
