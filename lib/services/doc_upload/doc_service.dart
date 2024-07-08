import 'dart:async';
import 'dart:convert';
import 'package:app_amic_dental_2024/models/doc_upload/file_upload.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocService extends ChangeNotifier {
  List<FileUpload> files = [];
  static const delay = Duration(seconds: 3);
  List<FileUpload> get filesToUpload {
    return files;
  }

  int countRequest = 0;
  String baseUrl = "https://demo.infoexpo.com.mx/docs-carga-service/public/api";
  set updateRequest(int increment) {
    increment > 0 ? countRequest++ : countRequest--;
    notifyListeners();
  }

  get countReq => countRequest;

  uploadFile(String base64File, String name, String type) async {
    final connection = await getConnection();
    try {
      if (!connection) {
        EasyLoading.showInfo("No tienes conexion a Internet.");
        await Future.delayed(delay, () => EasyLoading.dismiss());
        return null;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      name = name.replaceAll(" ", "");
      var token = prefs.getString("token");
      var idVisitor = prefs.getInt("idVisitor");
      var url = Uri.parse("$baseUrl/attendee-docs/$idVisitor");

      String b64 = base64File != ""
          ? "'data:application/${type};base64,${base64File}'"
          : "";
      var data = {};
      data[name] = b64;
      var json = jsonEncode({"data": data, "token": token});

      var res =
          await http.patch(url, body: json).timeout(const Duration(minutes: 1));

      return res;
    } on TimeoutException catch (_) {
      EasyLoading.showInfo("Revisa tu conexion a Internet.");
      await Future.delayed(delay, () => EasyLoading.dismiss());
      return null;
    } on http.ClientException catch (_) {
      EasyLoading.showInfo("Revisa tu conexion a Internet.");
      await Future.delayed(delay, () => EasyLoading.dismiss());
      return null;
    }
  }

  searchVisitorData(idVisitor) async {
    final connection = await getConnection();
    try {
      if (!connection) {
        EasyLoading.showInfo("No tienes conexion a Internet.");
        await Future.delayed(delay, () => EasyLoading.dismiss());
        return null;
      }
      var uri = Uri.parse("$baseUrl/attendee-docs/$idVisitor");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var res = await http.get(uri).timeout(const Duration(seconds: 30));
      var jsonResponse = jsonDecode(res.body);
      if (!jsonResponse["status"]) return jsonResponse;
      var data = jsonResponse["data"];
      prefs.setString("token", jsonResponse["token"]);
      prefs.setInt("idVisitor", data["idVisitante"]);
      return jsonResponse;
    } on TimeoutException catch (_) {
      EasyLoading.showInfo("Revisa tu conexion a Internet.");
      await Future.delayed(delay, () => EasyLoading.dismiss());
      return null;
    }
  }

  getDocument(String documentName) async {
    final connection = await getConnection();
    try {
      if (!connection) {
        EasyLoading.showInfo("No tienes conexion a Internet.");
        await Future.delayed(delay, () => EasyLoading.dismiss());
        return null;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      documentName = documentName.replaceAll(" ", "");
      var token = prefs.getString("token");
      var idVisitor = prefs.getInt("idVisitor");
      var uri = Uri.parse("$baseUrl/attendee-docs/$idVisitor/$documentName");
      var res = await http.get(uri).timeout(const Duration(minutes: 1));
      var jsonResponse = jsonDecode(res.body);
      if (!jsonResponse["status"]) return jsonResponse;
      return jsonResponse["data"];
    } on TimeoutException catch (_) {
      EasyLoading.showInfo("Revisa tu conexion a Internet.");
      await Future.delayed(delay, () => EasyLoading.dismiss());
      return null;
    }
  }

  static Future<bool> getConnection() async {
    final Connectivity connection = Connectivity();
    final connectivityResult = await connection.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      try {
        final res = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 3));
        return res.statusCode == 200 ? true : false;
      } on TimeoutException catch (_) {
        return false;
      } on http.ClientException catch (e) {
        EasyLoading.show(status: e.toString());
      }
    }
    return false;
  }
}
