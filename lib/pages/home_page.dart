import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttergems/models/gems.dart';
import 'package:fluttergems/pages/favorites_page.dart';
import 'package:fluttergems/scrapper/scrapper.dart';
import 'package:fluttergems/utils/colors.dart';
import 'package:fluttergems/utils/menus.dart';
import 'package:fluttergems/utils/routes.dart';
import 'package:fluttergems/widgets/custom_switch.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onThemeChanged});

  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  final ValueNotifier<bool> isIconChanged = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isModeChanged = ValueNotifier<bool>(false);

  FutureBuilder<List<Gems>> _buildGemsList(BuildContext context) {

    return FutureBuilder<List<Gems>>(
      future: ScrapperManager().fetchFlutterGems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try{
            final List<Gems> list = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.blueAccent,
                  title: const Text("Flutter Gems", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  leading: IconButton(onPressed: () {
                    isIconChanged.value = !isIconChanged.value;
                    _key.currentState?.toggle();
                  }, icon: ValueListenableBuilder<bool>(
                      valueListenable: isIconChanged,
                      builder: (context, value, child) {
                        return value ? Image.asset("assets/cross.png", width: 20, height: 20, color: Colors.white,)
                            : Image.asset("assets/menu.png", width: 20, height: 20, color: Colors.white,);
                      }
                  )),
                  actions: [
                    IconButton(onPressed: () {
                      Navigator.of(context).push(RouteManager().createRoute(const FavoritesPage()));
                    }, padding: const EdgeInsets.all(8), icon: Image.asset("assets/star.png", width: 20, height: 20, color: Colors.white))
                  ],
                  centerTitle: true,
                  expandedHeight: 120.0, // Height of the expanded container
                  floating: false, // It will stay fixed at the top when collapsed
                  pinned: true, // It stays pinned when scrolling down
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax, // Pins the title when collapsed
                    background: Container(
                      color: Colors.blueAccent,
                      alignment: Alignment.bottomCenter,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Flutter Gems is a curated list of 6000+ useful Dart & Flutter packages that are categorized based on functionality.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12), textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: list.length,
                            (context, index) =>  Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Theme.of(context).colorScheme.primary,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category Title
                                Text(
                                  "${index+1}: ${list[index].title}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // GridView for packages with 2 columns
                                MasonryGridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  itemCount: list[index].packages.length,
                                  itemBuilder: (context, packageIndex) {
                                    return GestureDetector(
                                      onTap: () {

                                        Navigator.of(context).push(RouteManager().createRoute(DetailsPage(
                                          endPoint: list[index].packages[packageIndex].href,)
                                        ));

                                      },
                                      child: Material(
                                        elevation: 8,
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color: Theme.of(context).colorScheme.secondary,
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
                                                      style: const TextStyle(fontSize: 12),
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
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                    )
                )
              ],
            );

          }
          catch(e){
            return const Card(color: Colors.white, elevation: 8, child: Center(child: Text("No Data Found!"),),);
          }
        } else {
          return  Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.blueAccent,
              size: MediaQuery.of(context).size.width/6,
            ),
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    final ThemeData currentTheme = Theme.of(context);
    isModeChanged.value = currentTheme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SliderDrawer(
          splashColor: Theme.of(context).colorScheme.primary,
          key: _key,
          appBar: Container(),
          slider: Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80,),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset("assets/flutter.png", height: 80, width: 80,),
                  ),
                ),
                const SizedBox(height: 16,),
                const Text("Flutter Gems", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                const SizedBox(height: 16,),
                ValueListenableBuilder<bool>(
                    valueListenable: isModeChanged,
                    builder: (context, value, child) {
                      return CustomSwitch(
                        value: value,
                        onChanged: (value) {
                          isModeChanged.value = !isModeChanged.value;
                          if(value) {
                            widget.onThemeChanged(ThemeMode.dark);
                          }
                          else {
                            widget.onThemeChanged(ThemeMode.light);
                          }
                        },
                      );
                    }
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: MenuManager.drawerMenu.length,
                    itemBuilder: (context, position) {
                    var item = MenuManager.drawerMenu[position];

                    return GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            const SizedBox(width: 8,),
                            Image.asset(item.icon, height: 28, width: 28, color: Theme.of(context).colorScheme.tertiary,),
                            const SizedBox(width: 16,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                Text(item.subtitle, style: const TextStyle(fontSize: 12),),
                              ],
                            )

                          ],
                        ),
                      ),
                    );

                    }
                )
              ],
            ),
          ),
          child: _buildGemsList(context)
      ),
    );
  }
}
