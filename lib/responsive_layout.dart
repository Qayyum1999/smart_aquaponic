import 'package:flutter/material.dart';
import 'dimensions.dart';
import 'globals.dart' as globals;

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  ResponsiveLayout({Key key, @required this.mobileBody, @required this.desktopBody});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        globals.isLoggedIn = true;
        if (constraints.maxWidth < mobileWidth) {
          return mobileBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}