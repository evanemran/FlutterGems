import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttergems/models/gems.dart';
import 'package:fluttergems/scrapper/scrapper.dart';

import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FutureBuilder<List<Gems>> _buildGemsList(BuildContext context) {

    return FutureBuilder<List<Gems>>(
      future: ScrapperManager().fetchFlutterGems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try{
            final List<Gems> list = snapshot.data!;

            return ListView.builder(
              itemCount: list.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Title
                      Text(
                        list[index].title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // GridView for packages with 2 columns
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1, // Height to width ratio for grid items
                        ),
                        itemCount: list[index].packages.length,
                        itemBuilder: (context, packageIndex) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsPage(
                                endPoint: list[index].packages[packageIndex].href,)
                              ));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Wrap(
                                children: [
                                  Column(
                                    children: [
                                      list[index].packages[packageIndex].image.endsWith(".svg")
                                          ? SvgPicture.network(
                                          list[index].packages[packageIndex].image,
                                        height: 50,
                                      )
                                      : Image.network(
                                        list[index].packages[packageIndex].image,
                                        height: 50,
                                      ),
                                      Text(
                                        list[index].packages[packageIndex].title,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: const TextStyle(color: Colors.black, fontSize: 12),
                                      ),
                                      Text(
                                        list[index].packages[packageIndex].count,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: const TextStyle(color: Colors.green, fontSize: 10),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );


            /*return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, position) {
                  var item = list[position];

                  return Text(item.title);
                }
            );*/
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
        title: Text("Flutter Gems"),
      ),
      
      body: Center(
        child: _buildGemsList(context),
      ),
    );
  }
}
