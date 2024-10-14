import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergems/models/repository.dart';
import 'package:fluttergems/pages/webview_page.dart';
import 'package:fluttergems/scrapper/scrapper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/package_single_item.dart';
import '../utils/colors.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({super.key, required this.endPoint, required this.imgUrl});
  
  final String endPoint;
  final String imgUrl;

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {


  FutureBuilder<PackageSingleItem> _buildDetails(BuildContext context) {

    return FutureBuilder<PackageSingleItem>(
      future: ScrapperManager().fetchFlutterSinglePackageDetails(widget.endPoint),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try{
            final PackageSingleItem details = snapshot.data!;
            final List<Repository> list = snapshot.data!.openSource.where((repo) => repo.name.isNotEmpty).toList();

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    color: Theme.of(context).colorScheme.primary,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Card(
                      elevation: 8,
                      color: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("assets/flutter.png", height: 80, width: 80,),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(details.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 4,),
                              Text(details.publisher, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                              const SizedBox(height: 4,),
                              Text(details.addMethod, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
              
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Card(
                      elevation: 8,
                      color: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Expanded(flex: 1, child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Category", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                SizedBox(height: 4,),
                                Text("Dart 3", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Null safety", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Platform(s)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Dart SDK", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Flutter SDK", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Latest Version", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Created", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Pub Likes", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Pub Points", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("GitHub Stars", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text("Open Issues", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                            const SizedBox(width: 10,),
                            Expanded(flex: 2, child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(":  ${details.category}", maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),),
                                const SizedBox(height: 4,),
                                Text(":  ${details.compatibility}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.nullSafety}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.platforms.join(', ')}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.dartSdk}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.flutterSdk}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.latestVersion}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.createdDate}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.pubLikes}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.pubPoints}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.githubStars}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                const SizedBox(height: 4,),
                                Text(":  ${details.openIssues}",maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 1, child: Visibility(
                                visible: details.pubDevUrl!="",
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage(url: details.pubDevUrl),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    elevation: 8,
                                    minimumSize: const Size(double.maxFinite, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(4.0), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    "Pub.Dev",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 8,),
                              Expanded(flex: 1, child: Visibility(
                                visible: details.sourceCodeUrl!="",
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage(url: details.sourceCodeUrl),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    elevation: 8,
                                    minimumSize: const Size(double.maxFinite, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(4.0), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    "Source Code",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex: 1, child: Visibility(
                                visible: details.docUrl!="",
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage(url: details.docUrl),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    elevation: 8,
                                    minimumSize: const Size(double.maxFinite, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(4.0), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    "Documentation",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 8,),
                              Expanded(flex: 1, child: Visibility(
                                visible: details.apiDocUrl!="",
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage(url: details.apiDocUrl),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    elevation: 8,
                                    minimumSize: const Size(double.maxFinite, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(4.0), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    "API Docs",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  widget.imgUrl!="" ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(widget.imgUrl, width: double.maxFinite,),
                  ) : const SizedBox(),
              
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      children: [
                        Visibility(visible: list.isNotEmpty, child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("🖥️ Open Source Flutter Apps & Projects that use ${details.title} [${list.length}]", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          ),
                        )),
              
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, position) {
                              var item = list[position];
              
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Card(
                                  elevation: 8,
                                  color: Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Container(
                                    color: Theme.of(context).colorScheme.secondary,
                                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WebViewPage(url: list[position].url),
                                          ),
                                        );
                                      },
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(5),
                                      title: Row(
                                        children: [
                                          Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)),
                                          Text("⭐ ${item.stars}", style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),)
                                        ],
                                      ),
                                      subtitle: Text(item.description, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),),
                                    ),
                                  ),
                                ),
                              );
              
                            }),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          catch(e){
            return const Card(color: Colors.white, elevation: 8, child: Center(child: Text("No Data Found!"),),);
          }
        } else {
          return Center(child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blueAccent,
            size: MediaQuery.of(context).size.width/6,
          ),);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Package Info", style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),
        actions: [
          IconButton(onPressed: () {}, padding: const EdgeInsets.all(8), icon: const Icon(Icons.star_border_outlined, color: Colors.white,))
        ],
      ),
      
      body: _buildDetails(context),
    );
  }
}
