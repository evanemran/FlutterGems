import 'package:fluttergems/models/gems.dart';
import 'package:fluttergems/models/packages.dart';
import 'package:fluttergems/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

import '../models/package_details.dart';
import '../models/package_item.dart';

class ScrapperManager {


  Future<List<Gems>> fetchFlutterGems() async {
    // Step 1: Send a GET request to fetch the HTML content
    final response = await http.get(Uri.parse(AppConstants.baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    // Step 2: Parse the HTML document
    Document document = html_parser.parse(response.body);

    // Step 3: Extract the category groups
    final List<Element> categoryGroups = document.querySelectorAll('.cat-group');

    List<Gems> gemsList = [];

    for (var group in categoryGroups) {
      // Extract the category title (e.g., "User Journey", "Functionality")
      final titleElement = group.querySelector('h2');
      if (titleElement != null) {
        String categoryTitle = titleElement.text.trim();

        // Step 4: Extract all the package names from custom-cards in this category
        List<Element> packageElements = group.querySelectorAll('.custom-card');

        List<Packages> packageList = [];

        for (var card in packageElements) {
          final packageNameElement = card.querySelector('.cat-title');
          final packageCountElement = card.querySelector('.text-muted');

          final imgElement = card.querySelector('.card-img-top');
          String imgSrc = imgElement?.attributes['src'] ?? "";
          String hrefValue = card.attributes['href'] ?? "";

          // If the src is a relative URL, prepend the domain
          if (!imgSrc.startsWith('http')) {
            imgSrc = 'https://fluttergems.dev$imgSrc'; // assuming the base URL is "fluttergems.dev"
          }

          if (packageNameElement != null) {
            String packageName = "${packageNameElement.text.trim()}\n";
            String packageCount = packageCountElement?.text.trim() ?? "";
            String packageImage = imgSrc;
            String packageHref = hrefValue;
            packageList.add(Packages(packageName, packageCount, packageImage, packageHref));
          }
        }

        // Add the Gems category with its list of packages
        gemsList.add(Gems(categoryTitle, packageList));
      }
    }

    return gemsList;
  }


  Future<PackageDetails> fetchFlutterPackageDetails(String endpoint) async {
    // Step 1: Send a GET request to fetch the HTML content
    final response = await http.get(Uri.parse(AppConstants.baseUrl+endpoint));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    // Step 2: Parse the HTML document
    Document document = html_parser.parse(response.body);

    // Step 3: Extract the category groups
    final List<Element> packageGroups = document.querySelectorAll('.pkg-card');
    final Element? titleElement = document.querySelector('h2');
    final Element? lastUpdateElement = document.querySelector('p.text-muted i');
    // final Element? lastUpdateElement = document.querySelector('p.text-muted i');

    String title = titleElement!.text ?? "N/A";
    String lastUpdate = lastUpdateElement!.text ?? "N/A";

    List<PackageItem> packageItemList = [];

    for (var group in packageGroups) {
      final titleElement = group.querySelector('.card-title');
      final maintenanceGoodElement = group.querySelector('h6.badge.bg-success');
      final maintenanceWarningElement = group.querySelector('h6.badge.bg-warning');
      final maintenanceDangerElement = group.querySelector('h6.badge.bg-danger');
      final compatibleElement = group.querySelector('span.badge.bg-primary');
      final detailsElement = group.querySelector('p.card-text');
      final imageElement = group.querySelector('img.card-img-top');
      if (titleElement != null) {
        String packageTitle = "${titleElement.text.trim()}\n\n";
        String compatibility = "";
        String maintenance = "";
        String details = "";
        String imageUrl = "";

        if(maintenanceGoodElement!=null) {
          maintenance = maintenanceGoodElement.text.trim();
        }

        if(maintenanceWarningElement!=null) {
          maintenance = maintenanceWarningElement.text.trim();
        }

        if(maintenanceDangerElement!=null) {
          maintenance = maintenanceDangerElement.text.trim();
        }

        if(compatibleElement!=null) {
          compatibility = compatibleElement.text.trim();
        }

        if(detailsElement!=null) {
          details = "${detailsElement.text.trim()}\n\n\n\n\n";
        }

        if(imageElement!=null) {
          imageUrl = imageElement.attributes['src']!=null ? 'https://fluttergems.dev${imageElement.attributes['src']}' : "";
        }

        // Add the Gems category with its list of packages
        packageItemList.add(PackageItem(packageTitle, compatibility, maintenance, "likes", [], details, imageUrl));
      }
    }

    PackageDetails details = PackageDetails(title, "", lastUpdate, packageItemList);

    return details;
  }



}