import 'package:flutter/material.dart';

class DialogUtils {
  Future<void> dialog(BuildContext context, {required Widget widget}) async {
    showDialog(
      context: context,
      builder: (context) => widget,
    );
  }
}
