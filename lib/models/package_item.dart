import 'dart:ui';

import 'package:flutter/material.dart';

class PackageItem {
  String title = "";
  String compatibility = "";
  String maintenance = "";
  String likes = "";
  List<String> platforms = [];
  String details = "";
  String image = "";
  Color maintenanceColor = Colors.green;
  String href = "";

  PackageItem(this.title, this.compatibility, this.maintenanceColor, this.maintenance, this.likes,
      this.platforms, this.details, this.image, this.href);
}