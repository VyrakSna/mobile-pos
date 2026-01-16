import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PopupDialog {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        width: 160,
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            constraints: BoxConstraints(maxHeight: 120, maxWidth: 120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text(
                  'Please Wait.....',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void dimissLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showError(
    BuildContext context, {
    String title = "Information",
    String? description,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(children: [Text(title), Text(description ?? '')]),
      ),
    );
  }
}
