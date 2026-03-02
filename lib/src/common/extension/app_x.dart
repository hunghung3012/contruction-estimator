import 'package:flutter/material.dart';

void unfocusKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}