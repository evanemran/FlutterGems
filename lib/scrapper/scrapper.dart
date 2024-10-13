import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:fluttergems/models/gems.dart';
import 'package:fluttergems/models/packages.dart';
import 'package:fluttergems/models/repository.dart';
import 'package:fluttergems/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

import '../models/package_details.dart';
import '../models/package_item.dart';
import '../models/package_single_item.dart';

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
    final List<Element> categoryGroups =
        document.querySelectorAll('.cat-group');

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
            imgSrc =
                'https://fluttergems.dev$imgSrc'; // assuming the base URL is "fluttergems.dev"
          }

          if (packageNameElement != null) {
            String packageName = "${packageNameElement.text.trim()}\n";
            String packageCount = packageCountElement?.text.trim() ?? "";
            String packageImage = imgSrc;
            String packageHref = hrefValue;
            packageList.add(
                Packages(packageName, packageCount, packageImage, packageHref));
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
    final response = await http.get(Uri.parse(AppConstants.baseUrl + endpoint));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    // Step 2: Parse the HTML document
    Document document = html_parser.parse(response.body);

    // Step 3: Extract the category groups
    final List<Element> packageGroups = document.querySelectorAll('.pkg-card');
    final Element? titleElement = document.querySelector('h2');
    final Element? lastUpdateElement = document.querySelector('p.text-muted i');
    final Element descriptionElement = document.querySelectorAll('p')[1];
    // final Element? lastUpdateElement = document.querySelector('p.text-muted i');

    String title = titleElement!.text ?? "N/A";
    String lastUpdate = lastUpdateElement!.text ?? "N/A";
    String description = descriptionElement.text ?? "N/A";

    List<PackageItem> packageItemList = [];

    for (var group in packageGroups) {
      final titleElement = group.querySelector('.card-title');
      final maintenanceGoodElement = group.querySelector('h6.badge.bg-success');
      final maintenanceWarningElement =
          group.querySelector('h6.badge.bg-warning');
      final maintenanceDangerElement =
          group.querySelector('h6.badge.bg-danger');
      final compatibleElement = group.querySelector('span.badge.bg-primary');
      final detailsElement = group.querySelector('p.card-text');
      final imageElement = group.querySelector('img.card-img-top');
      final likeElement = group.querySelector('h6.card-subtitle.text-muted');
      final hrefElement = group.querySelector('div.d-grid.gap-2 a');
      if (titleElement != null) {
        String packageTitle = "${titleElement.text.trim()}";
        String compatibility = "";
        String maintenance = "";
        String details = "";
        String imageUrl = "";
        String likeCount = "0";
        Color maintenanceColor = material.Colors.green;
        String hrefEndPoint = "";

        if (maintenanceGoodElement != null) {
          maintenance = maintenanceGoodElement.text.trim();
          maintenanceColor = material.Colors.green;
        }

        if (maintenanceWarningElement != null) {
          maintenance = maintenanceWarningElement.text.trim();
          maintenanceColor = material.Colors.orange;
        }

        if (maintenanceDangerElement != null) {
          maintenance = maintenanceDangerElement.text.trim();
          maintenanceColor = material.Colors.red;
        }

        if (compatibleElement != null) {
          compatibility = compatibleElement.text.trim();
        }

        if (detailsElement != null) {
          details = detailsElement.text.trim();
        }

        if (imageElement != null) {
          imageUrl = imageElement.attributes['src'] != null
              ? 'https://fluttergems.dev${imageElement.attributes['src']}'
              : "";
        }

        if (likeElement != null) {
          // Extract the text content (including the like count)
          String likeText = likeElement.text;

          // Use a regular expression to extract the number from the like count (e.g., 1.69K)
          RegExp regExp = RegExp(r'👍\s(\d+(\.\d+)?[K]?)');
          Match? match = regExp.firstMatch(likeText);

          if (match != null) {
            likeCount = "👍 ${match.group(1)!}";
          } else {
            likeCount = "👍 0";
          }
        }

        hrefEndPoint = hrefElement?.attributes['href'] ?? "";

        // Add the Gems category with its list of packages
        packageItemList.add(PackageItem(
            packageTitle,
            compatibility,
            maintenanceColor,
            maintenance,
            likeCount,
            [],
            details,
            imageUrl,
            hrefEndPoint));
      }
    }

    PackageDetails details =
        PackageDetails(title, description, lastUpdate, packageItemList);

    return details;
  }

  Future<PackageSingleItem> fetchFlutterSinglePackageDetails(String endpoint) async {
    final response = await http.get(Uri.parse(AppConstants.baseUrl + endpoint));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    Document document = html_parser.parse(response.body);

    List<Element> linkElements = document.querySelectorAll('a');
    List<Element> projectElements = document.querySelectorAll('.col-12.col-lg-6');

    String pubDevLink = "";
    String sourceCodeLink = "";
    String docLink = "";
    String apiDocsLink = "";

    try {
      pubDevLink = linkElements
          .firstWhere((link) => link.text.contains("pub.dev"))
          .attributes['href'] ?? "";

      sourceCodeLink = linkElements
          .firstWhere((link) => link.text.contains("Source Code"))
          .attributes['href'] ?? "";

      docLink = linkElements
          .firstWhere((link) => link.text.contains("Documentation"))
          .attributes['href'] ?? "";

      apiDocsLink = linkElements
          .firstWhere((link) => link.text.contains("API Docs"))
          .attributes['href'] ?? "";
    }
    catch(e) {
      print(e);
    }

    String title = document.querySelector('h2')?.text ?? '';
    String publisher = document.querySelector('p.text-muted a')?.text ?? '';
    String addMethod = document.querySelector('code')?.text ?? '';

    String imgUrl = document.querySelector('img')?.attributes['src'] ?? "";

    String pubDevUrl = pubDevLink;
    String sourceCodeUrl = sourceCodeLink;
    String docUrl = docLink;
    String apiDocUrl = apiDocsLink;

    String category =
        document.querySelector('tr:nth-child(1) td a')?.text.trim() ?? '';
    String compatibility =
        document.querySelector('tr:nth-child(5) td span')?.text.trim() ?? '';
    String nullSafety =
        document.querySelector('tr:nth-child(3) td span')?.text.trim() ?? '';
    List<String> platforms = document
        .querySelectorAll('tr:nth-child(7) td span')
        .map((e) => e.text.trim())
        .toList();
    String dartSdk =
        document.querySelector('tr:nth-child(9) td span')?.text.trim() ?? '';
    String flutterSdk =
        document.querySelector('tr:nth-child(11) td span')?.text.trim() ?? '';
    String latestVersion =
        document.querySelector('tr:nth-child(13) td span')?.text.trim() ?? '';
    String createdDate =
        document.querySelector('tr:nth-child(15) td span')?.text.trim() ?? '';
    String pubLikes =
        document.querySelector('tr:nth-child(17) td span')?.text.trim() ?? '';
    String pubPoints =
        document.querySelector('tr:nth-child(19) td span')?.text.trim() ?? '';
    String githubStars =
        document.querySelector('tr:nth-child(21) td span')?.text.trim() ?? '';
    String openIssues =
        document.querySelector('tr:nth-child(23) td span')?.text.trim() ?? '';

    List<Repository> projects = [];

    for (Element projectElement in projectElements) {
      // Extract the name, description, stars, and link
      String name = projectElement.querySelector('h5.cat-title')?.text ?? '';
      String description =
          projectElement.querySelector('p.card-text')?.text ?? '';
      String stars = projectElement.querySelector('small')?.text.trim() ?? '';
      String link = projectElement.querySelector('a')?.attributes['href'] ?? '';

      // Add the project to the list
      projects.add(Repository(name, description, stars, link));
    }

    print(imgUrl);

    return PackageSingleItem(
        title,
        publisher,
        addMethod,
        pubDevUrl,
        sourceCodeUrl,
        docUrl,
        apiDocUrl,
        category,
        compatibility,
        nullSafety,
        platforms,
        dartSdk,
        flutterSdk,
        latestVersion,
        createdDate,
        pubLikes,
        pubPoints,
        githubStars,
        openIssues,
        "",
        "",
        "",
        projects,
    imgUrl);
  }
}
