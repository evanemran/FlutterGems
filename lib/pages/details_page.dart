import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergems/models/package_details.dart';
import 'package:fluttergems/models/package_item.dart';
import 'package:fluttergems/pages/package_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../scrapper/scrapper.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.endPoint});

  final String endPoint;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  FutureBuilder<PackageDetails> _buildDetails(BuildContext context) {

    return FutureBuilder<PackageDetails>(
      future: ScrapperManager().fetchFlutterPackageDetails(widget.endPoint),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try{
            final PackageDetails details = snapshot.data!;
            final List<PackageItem> list = snapshot.data!.packageItem;

            return Column(
              children: [
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(details.title, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 8,),
                      Text(details.lastUpdate, style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.normal)),
                      const SizedBox(height: 8,),
                      Text(details.subtitle, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),

                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1/2.25, // Height to width ratio for grid items
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, packageIndex) {
                    return GestureDetector(
                      onTap: () {

                      },
                      child: Stack(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Wrap(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      list[packageIndex].image.isNotEmpty ? AspectRatio(
                                        aspectRatio: 1, // 1:1 aspect ratio
                                        // child: Image.network(product.images![0].toString().replaceAll("https", "http")),
                                        child: Image.network(
                                            list[packageIndex].image
                                        ),
                                      ) : Image.asset("assets/flutter.png"),
                                      Text(
                                        list[packageIndex].title,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      /*Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: list[packageIndex].maintenanceColor,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: Text(
                                          list[packageIndex].maintenance,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),*/
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: list[packageIndex].maintenanceColor,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: Text(
                                          list[packageIndex].maintenance,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: Text(
                                          list[packageIndex].compatibility,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                      Text(
                                        list[packageIndex].details,
                                        textAlign: TextAlign.start,
                                        maxLines: 4,
                                        style: const TextStyle(color: Colors.black, fontSize: 12),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PackagePage(endPoint: list[packageIndex].href,)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          minimumSize: const Size(double.maxFinite, 36),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(4.0), // Rounded corners
                                          ),
                                        ),
                                        child: const Text(
                                          "READ MORE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          ),
                          Positioned(top: 0, right: 0, child: Card(color: Colors.white, elevation: 8, margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(list[packageIndex].likes, style: const TextStyle(color: Colors.black, fontSize: 12),),
                          ))),
                        ],
                      ),
                    );
                  },
                ),
              ],
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: _buildDetails(context),
        ),
      ),
    );
  }
}
