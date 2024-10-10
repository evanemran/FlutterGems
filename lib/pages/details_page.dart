import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergems/models/package_details.dart';
import 'package:fluttergems/models/package_item.dart';

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

                Text(details.title),

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
                      child: Container(
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
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.all(4),
                                    color: Colors.green,
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
                                    color: Colors.blue,
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
                    );
                  },
                ),
              ],
            );

            /*return ListView.builder(itemCount: list.length, itemBuilder: (context, position) {
              var item = list[position];

              return ListTile(
                tileColor: Colors.white,
                leading: AspectRatio(
                  aspectRatio: 1, // 1:1 aspect ratio
                  // child: Image.network(product.images![0].toString().replaceAll("https", "http")),
                  child: Image.asset(
                    "assets/flutter.png",
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item.title, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                subtitle: Text(item.maintenance, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
              );
            });*/
          }
          catch(e){
            return const Card(color: Colors.white, elevation: 8, child: Center(child: Text("No Data Found!"),),);
          }
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),

      body: SingleChildScrollView(
        child: _buildDetails(context),
      ),
    );
  }
}
