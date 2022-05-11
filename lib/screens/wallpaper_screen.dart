import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wallpaper_app/screens/search_image.dart';

import '../blocs/internet_bloc/internet_checker_bloc.dart';
import '../utils/api_services/common_strings.dart';
import '../utils/enums/enums.dart';
import '../widgets/common_use_widget.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({Key? key}) : super(key: key);

  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List images = [];
  List categoryImage = [];
  List randomImage = [];
  List weeklyImage = [];
  List monthlyImage = [];
  List mostPopularImage = [];
  int page = 1;
  int selectedIndex = 1;
  final ScrollController _scrollControllerRecent = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this, initialIndex: selectedIndex);
    fetchWallpaper(
        wallpaper: FetchWallpaperCategoryFrom.category,
        api: 'https://api.pexels.com/v1/search?query=category');
    fetchWallpaper(
        wallpaper: FetchWallpaperCategoryFrom.mostPopular,
        api: 'https://api.pexels.com/v1/search?query=most popular');
    fetchWallpaper(
        wallpaper: FetchWallpaperCategoryFrom.monthlyPopular,
        api: 'https://api.pexels.com/v1/search?query=monthly');
    fetchWallpaper(
        wallpaper: FetchWallpaperCategoryFrom.random,
        api: 'https://api.pexels.com/v1/search?query=random');
    fetchWallpaper(
        wallpaper: FetchWallpaperCategoryFrom.recent,
        api: 'https://api.pexels.com/v1/search?query=recent');
    fetchWallpaper(
        wallpaper: FetchWallpaperCategoryFrom.weeklyPopular,
        api: 'https://api.pexels.com/v1/search?query=weekly');
    _scrollControllerRecent.addListener(() {
      double maxScroll = _scrollControllerRecent.position.maxScrollExtent;
      double currentScroll = _scrollControllerRecent.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        loadMore();
      }
    });
  }

  fetchWallpaper(
      {required FetchWallpaperCategoryFrom wallpaper,
      required String api}) async {
    await Dio()
        // .get('https://api.pexels.com/v1/curated?per_page=80',
        .get('$api&per_page=80',
            options: Options(headers: {'Authorization': AppString.apiKey}))
        .then((Response response) {
      Map result = response.data;

      if (wallpaper == FetchWallpaperCategoryFrom.category) {
        categoryImage = result['photos'];
      } else if (wallpaper == FetchWallpaperCategoryFrom.random) {
        randomImage = result['photos'];
      } else if (wallpaper == FetchWallpaperCategoryFrom.monthlyPopular) {
        monthlyImage = result['photos'];
      } else if (wallpaper == FetchWallpaperCategoryFrom.mostPopular) {
        mostPopularImage = result['photos'];
      } else if (wallpaper == FetchWallpaperCategoryFrom.weeklyPopular) {
        weeklyImage = result['photos'];
      } else {
        images = result['photos'];
      }
      setState(() {});
    });
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/search?query=monthly popular&per_page=80&page=' +
            page.toString();
    await Dio()
        .get(url,
            options: Options(
                headers: {'Authorization': AppString.apiKey},
                receiveTimeout: 60000))
        .then((value) {
      Map result = value.data;
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                      child: const SearchWallpaperScreen(),
                      type: PageTransitionType.rightToLeft,
                    ));
              },
              child: const Icon(
                Icons.search_sharp,
                size: 30,
              ),
            ),
          )
        ],
        leading: const Icon(Icons.menu),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Wallpapers",
        ),
      ),
      body: BlocBuilder<InternetCheckerBloc, InternetCheckerState>(
        builder: (context, state) {
          if (state is InternetConnectedState) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  color: Colors.black,
                  child: TabBar(
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    isScrollable: true,
                    controller: _tabController,
                    tabs: [
                      textView(text: 'CATEGORIES'),
                      textView(text: 'RECENT'),
                      textView(text: 'RANDOM'),
                      textView(text: 'WEEKLY POPULAR'),
                      textView(text: 'MONTHLY POPULAR'),
                      textView(text: 'MOST POPULAR'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      showWallpaperWidget(
                          controller: _scrollControllerRecent,
                          images: categoryImage,
                          key: 'Category'),
                      showWallpaperWidget(
                          key: 'Recent',
                          controller: _scrollControllerRecent,
                          images: images),
                      showWallpaperWidget(
                          key: 'Random',
                          controller: _scrollControllerRecent,
                          images: randomImage),
                      showWallpaperWidget(
                          key: 'Weekly',
                          controller: _scrollControllerRecent,
                          images: weeklyImage),
                      showWallpaperWidget(
                          key: 'Monthly',
                          controller: _scrollControllerRecent,
                          images: monthlyImage),
                      showWallpaperWidget(
                          key: 'Popular',
                          controller: _scrollControllerRecent,
                          images: mostPopularImage),
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is InternetNotConnectedState) {
            return const Align(
              alignment: Alignment.center,
              child: Text(
                "Internet Not Connected",
                style: TextStyle(fontSize: 30),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
