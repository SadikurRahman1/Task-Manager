import 'package:flutter/material.dart';

void showSnackBarMassage(BuildContext context, String massage,
    [bool isError = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(massage),
      backgroundColor: isError ? Colors.red : null,
    ),
  );
}
