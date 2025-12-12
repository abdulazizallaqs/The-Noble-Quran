import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hafzon/core/color_manager.dart';
import 'package:hafzon/provider/theme_provider.dart';

class ChangeThemeButton extends StatefulWidget {
  const ChangeThemeButton({super.key});

  @override
  State<ChangeThemeButton> createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Switch.adaptive(
      activeColor: themeProvider.getTheme == darkTheme
          ? ColorManager.orangeColor
          : ColorManager.grey,
      value: themeProvider.getTheme == darkTheme,
      onChanged: (value) {
        themeProvider.changeTheme();
        setState(() {});
      },
    );
  }
}
