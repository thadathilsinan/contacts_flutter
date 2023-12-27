import 'package:flutter/material.dart';

class SnackbarUtil {
  static showMessage(BuildContext context, String? message) {
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
