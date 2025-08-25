import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:sizer/sizer.dart';

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
  final String? backgroundImage;
  final double blurIntensity;
  final Widget? searchBar;
  final double shadowOpacity;

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
    this.backgroundImage,
    this.blurIntensity = 5.0,
    this.searchBar,
    this.shadowOpacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // AppBar Content with constrained blur
        ClipRect(
          child: Container(
            height: preferredSize.height,
            decoration: BoxDecoration(
              image: backgroundImage != null
                  ? DecorationImage(
                      image: AssetImage(backgroundImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurIntensity,
                sigmaY: blurIntensity,
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(shadowOpacity),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  ),
                ),
                child: AppBar(
                  title: (fromDash ?? false)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 10,
                          ),
                          child: Image.asset(
                            'assets/images/logo-top.png',
                            height: context.height * 0.1,
                            width: context.width * .3,
                            color: Colors.white,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        )
                      : title ??
                            (titleText != null
                                ? Text(
                                    titleText!,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4.0,
                                          color: Colors.black.withOpacity(0.5),
                                          offset: const Offset(1.0, 1.0),
                                        ),
                                      ],
                                    ),
                                  )
                                : null),
                  leading: leading,
                  automaticallyImplyLeading: automaticallyImplyLeading,
                  actions: [
                    ...?actions,
                    if (trailing != null)
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10.0,
                          left: 5.w,
                          right: 5.w,
                        ),
                        child: trailing!,
                      ),
                    if (onEndDrawerPressed != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                endDrawerIcon,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              onPressed: onEndDrawerPressed,
                            ),
                          ),
                        ),
                      ),
                  ],
                  backgroundColor: backgroundImage != null
                      ? Colors.transparent
                      : primaryColor,
                  foregroundColor: foregroundColor ?? Colors.white,
                  elevation: 0,
                  titleSpacing:
                      titleSpacing ?? NavigationToolbar.kMiddleSpacing,
                  centerTitle: centerTitle,
                  bottom: bottom,
                  shape: shape,
                  toolbarHeight: toolbarHeight ?? kToolbarHeight,
                ),
              ),
            ),
          ),
        ),

        if (searchBar != null)
          Positioned(bottom: 10, left: 5, right: 5, child: searchBar!),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? kToolbarHeight) +
        (bottom?.preferredSize.height ?? 0) +
        (searchBar != null ? 12.h : 4.h),
  );
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearch;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search ...',
    this.onChanged,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearch,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: false,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: primaryColor),
              onPressed: null,
            ),
          ),
        ),
      ),
    );
  }
}
