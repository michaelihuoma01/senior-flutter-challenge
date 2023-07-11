import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:senior_flutter_challenge/screens/preferences.dart';

import '../model/activities.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Activity>? activities = [];
  int _selectedIndex = 0;
  List<IconData> icons = [
    Icons.bookmark_outline,
    Icons.favorite_outline,
    Icons.ios_share_outlined,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _initActivities();
  }

  void _initActivities() async {
    activities = await loadActivities();
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<Activity>> loadActivities() async {
    final jsonString = await rootBundle.loadString('assets/activity.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Activity.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: 'Discover'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Container(
                  decoration: const BoxDecoration(
                      color: Colors.deepPurple, shape: BoxShape.circle),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add, color: Colors.white),
                  )),
              label: ''),
          BottomNavigationBarItem(
              icon: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 16)),
              label: 'Plans'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: PageController(viewportFraction: 1.0),
        itemCount: activities!.length,
        itemBuilder: (BuildContext context, int index) {
          if (activities == null) {
            return const CircularProgressIndicator.adaptive();
          } else if (activities!.isEmpty) {
            return const Text('No data found');
          } else {
            final activity = activities![index];

            return Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _getColorForIndex(index).withOpacity(0.4),
              ),
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                    ),
                    items: activity.imageUrls.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.asset(image, fit: BoxFit.cover);
                        },
                      );
                    }).toList(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 10,
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PreferencesScreen()));
                          },
                          child: Icon(Icons.menu, color: Colors.white),
                        )),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Column(
                      children: icons.map((icon) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                color: Colors.white,
                              )),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children: activity.tags.map((tag) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.white)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 5.0),
                                child: Text(tag,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        Text(activity.activityTitle,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Colors.white)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.place, color: Colors.white, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              '${activity.location} - ${activity.distance} away',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Color _getColorForIndex(int index) {
    switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}
