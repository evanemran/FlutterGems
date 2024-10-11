import 'package:fluttergems/models/repository.dart';

class PackageSingleItem {
  String title = "";
  String publisher = "";
  String addMethod = "";
  String pubDevUrl = "";
  String sourceCodeUrl = "";
  String docUrl = "";
  String apiDocUrl = "";

  String category = "";
  String compatibility = "";
  String nullSafety = "";
  List<String> platforms = [];
  String dartSdk = "";
  String flutterSdk = "";
  String latestVersion = "";
  String createdDate = "";
  String pubLikes = "";
  String pubPoints = "";
  String githubStars = "";
  String openIssues = "";

  String aboutTitle = "";
  String aboutDescription = "";

  String openSourceTitle = "";
  List<Repository> openSource = [];
  String imageUrl = "";

  PackageSingleItem(
      this.title,
      this.publisher,
      this.addMethod,
      this.pubDevUrl,
      this.sourceCodeUrl,
      this.docUrl,
      this.apiDocUrl,
      this.category,
      this.compatibility,
      this.nullSafety,
      this.platforms,
      this.dartSdk,
      this.flutterSdk,
      this.latestVersion,
      this.createdDate,
      this.pubLikes,
      this.pubPoints,
      this.githubStars,
      this.openIssues,
      this.aboutTitle,
      this.aboutDescription,
      this.openSourceTitle,
      this.openSource,
      this.imageUrl);
}
