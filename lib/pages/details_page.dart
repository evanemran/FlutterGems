import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttergems/models/package_details.dart';
import 'package:fluttergems/models/package_item.dart';
import 'package:fluttergems/pages/package_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../scrapper/scrapper.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';

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
          try {
            final PackageDetails details = snapshot.data!;
            final List<PackageItem> list = snapshot.data!.packageItem;

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).colorScheme.secondary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        details.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(details.lastUpdate,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal)),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(details.subtitle,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: list.length,
                    itemBuilder: (context, packageIndex) {
                      return GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: [
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Wrap(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          list[packageIndex].image.isNotEmpty
                                              ? Image.network(
                                              list[packageIndex].image, width: double.maxFinite,)
                                              : Image.asset("assets/flutter.png"),
                                          Text(
                                            list[packageIndex].title,
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: list[packageIndex]
                                                  .maintenanceColor,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.verified_outlined, color: Colors.white, size: 14,),
                                                const SizedBox(width: 4,),
                                                Text(
                                                  list[packageIndex].maintenance.replaceAll("Status", ""),
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Text(
                                              list[packageIndex].compatibility,
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                            list[packageIndex].details,
                                            textAlign: TextAlign.start,
                                            maxLines: 4,
                                            style: const TextStyle(
                                                fontSize: 12),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {

                                              Navigator.of(context).push(RouteManager().createRoute(PackagePage(
                                                endPoint:
                                                list[packageIndex]
                                                    .href,
                                                imgUrl:
                                                list[packageIndex]
                                                    .image,
                                              )));

                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blueAccent,
                                              minimumSize: const Size(
                                                  double.maxFinite, 36),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0), // Rounded corners
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
                                  )),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: Card(
                                    color: Colors.white,
                                    elevation: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Text(
                                        list[packageIndex].likes,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ))),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          } catch (e) {
            return const Card(
              color: Colors.white,
              elevation: 8,
              child: Center(
                child: Text("No Data Found!"),
              ),
            );
          }
        } else {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.blueAccent,
              size: MediaQuery.of(context).size.width / 6,
            ),
          );
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
        title: const Text("Details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: const EdgeInsets.all(4),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),

        actions: [
          IconButton(
              onPressed: () {
              },
              icon: Image.asset("assets/filter.png", height: 20, width: 20, color: Colors.white))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: _buildDetails(context),
        ),
      ),
    );
  }
}
