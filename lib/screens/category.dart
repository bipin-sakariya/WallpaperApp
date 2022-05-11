import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/internet_bloc/internet_checker_bloc.dart';
import '../utils/api_services/common_strings.dart';
import '../utils/enums/enums.dart';
import '../widgets/common_use_widget.dart';

class Categories extends StatefulWidget {
  final String categoryName;
  Categories({required this.categoryName});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List images = [];
  int page = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWallpaper(
        wallpaper: FetchWallpaperCategoryFrom.category,
        api: 'https://api.pexels.com/v1/search?query=${widget.categoryName}');

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
        title: Text(
          widget.categoryName,
        ),
      ),
      body: BlocBuilder<InternetCheckerBloc, InternetCheckerState>(
        builder: (context, state) {
          if (state is InternetConnectedState) {
            return showWallpaperWidget(
                controller: _scrollController, images: images);
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
