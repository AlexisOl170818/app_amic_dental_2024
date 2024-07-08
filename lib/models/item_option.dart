import 'dart:convert';

import 'package:flutter/material.dart';

class ItemOption {
  IconData icon;
  String name;
  String urlImage;
  Function? function;
  bool showItem;
  ItemOption(
      {required this.icon,
      required this.name,
      required this.urlImage,
      this.function,
      required this.showItem});

  factory ItemOption.fromJson(String str) =>
      ItemOption.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemOption.fromMap(Map<String, dynamic> json) => ItemOption(
        icon: json["icon"],
        name: json["name"],
        urlImage: json["urlImage"],
        function: json["function"],
        showItem: json["showItem"],
      );

  Map<String, dynamic> toMap() => {
        "icon": icon,
        "name": name,
        "urlImage": urlImage,
        "function": function,
        "showItem": showItem,
      };
}
