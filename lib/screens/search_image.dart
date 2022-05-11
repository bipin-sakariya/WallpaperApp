import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/internet_bloc/internet_checker_bloc.dart';
import '../utils/api_services/common_strings.dart';
import '../utils/enums/enums.dart';
import '../widgets/common_use_widget.dart';

class SearchWallpaperScreen extends StatefulWidget {
  const SearchWallpaperScreen({Key? key}) : super(key: key);

  @override
  _SearchWallpaperScreenState createState() => _SearchWallpaperScreenState();
}

class _SearchWallpaperScreenState extends State<SearchWallpaperScreen> {
  List images = [];
  int page = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      fetchWallpaper(
          wallpaper: FetchWallpaperCategoryFrom.category,
          api:
              'https://api.pexels.com/v1/search?query=${_searchController.text}');
      print(_searchController.text);
    });

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
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

      images = result['photos'];

      setState(() {});
    });
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/search?query=${_searchController.text}&per_page=80&page=' +
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
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Search",
        ),
      ),
      body: BlocBuilder<InternetCheckerBloc, InternetCheckerState>(
        builder: (context, state) {
          if (state is InternetConnectedState) {
            return Column(
              children: [
                Container(
                    color: Colors.black,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _searchController,
                      decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search_sharp,
                            color: Colors.white,
                          ),
                          // suffixIcon: suffixIcon,
                          hintText: 'Search by Tag',
                          hintStyle: TextStyle(color: Colors.white)),
                    )),
                Expanded(
                  child: showWallpaperWidget(
                      controller: _scrollController, images: images),
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
