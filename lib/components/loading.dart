import 'package:flutter/material.dart';

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton = LoadingIndicatorDialog._internal();
  BuildContext? _context;
  bool isDisplayed = false;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  LoadingIndicatorDialog._internal();

  void show(BuildContext context) {
    if (isDisplayed) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent, // Transparent barrier color
      builder: (BuildContext dialogContext) {
        _context = dialogContext;
        isDisplayed = true;
        return Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54, // Semi-transparent background
              borderRadius: BorderRadius.circular(8),
            ),
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void dismiss() {
    if (isDisplayed && _context != null && Navigator.of(_context!).canPop()) {
      Navigator.of(_context!).pop();
      isDisplayed = false;
      _context = null;
    }
  }
}
