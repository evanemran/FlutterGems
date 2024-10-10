import 'package:fluttergems/models/package_item.dart';

class PackageDetails {
  String title = "";
  String subtitle = "";
  String lastUpdate = "";
  List<PackageItem> packageItem;

  PackageDetails(this.title, this.subtitle, this.lastUpdate, this.packageItem);
}