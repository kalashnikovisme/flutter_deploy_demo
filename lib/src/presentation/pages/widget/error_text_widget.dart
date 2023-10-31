import 'package:flutter/material.dart';
import 'package:test_intern/src/components/text_styles.dart';

class ErrorTextWidget extends StatelessWidget {
  final String message;

  const ErrorTextWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextsStyles.connectionErrorString,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
