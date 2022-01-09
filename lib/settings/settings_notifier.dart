import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends ChangeNotifier {
  SharedPreferences? sharedPreferences;

  Future setWorkspaceDirectory(String path) async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    return sharedPreferences?.setString(_workspaceDirectory, path);
  }

  Future<String?> getWorkspaceDirectory() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    return sharedPreferences?.getString(_workspaceDirectory);
  }

  static const _workspaceDirectory = "workspace";
}
