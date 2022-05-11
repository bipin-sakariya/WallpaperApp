import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';

import '../widgets/cacheNetworkImageView.dart';

class FullScreen extends StatefulWidget {
  final String imageUrl;

  const FullScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: CacheNetworkImageView(
  //         imageUrl: widget.imageUrl,
  //       ),
  //     ),
  //   );
  // }
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  Stream<String>? progressString;
  String? res;
  bool downloading = false;

  var result = "Waiting to set wallpaper";
  bool _isDisable = true;

  int nextImageID = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                downloading
                    ? imageDownloadDialog()
                    : CacheNetworkImageView(
                        imageUrl: widget.imageUrl,
                      ),
                /*    Row(
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.save_alt_rounded),
                      onTap: () async {
                        return await downloadImage(context);
                      },
                    ),
                  ],
                ),*/
                ElevatedButton(
                  onPressed: () async {
                    return await downloadImage(context);
                  },
                  child: Text("please download the image"),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          var width = MediaQuery.of(context).size.width;
                          var height = MediaQuery.of(context).size.height;
                          home = await Wallpaper.homeScreen(
                              location: DownloadLocation.EXTERNAL_DIRECTORY,
                              options: RequestSizeOptions.RESIZE_FIT,
                              width: width,
                              height: height);
                          setState(() {
                            downloading = false;
                            home = home;
                          });
                          print("Task Done");
                        },
                  child: Text(home),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          lock = await Wallpaper.lockScreen();
                          setState(() {
                            downloading = false;
                            lock = lock;
                          });
                          print("Task Done");
                        },
                  child: Text(lock),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          both = await Wallpaper.bothScreen();
                          setState(() {
                            downloading = false;
                            both = both;
                          });
                          print("Task Done");
                        },
                  child: Text(both),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          system = await Wallpaper.systemScreen();
                          setState(() {
                            downloading = false;
                            system = system;
                          });
                          print("Task Done");
                        },
                  child: Text(system),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> downloadImage(BuildContext context) async {
    progressString = Wallpaper.imageDownloadProgress(widget.imageUrl,
        location: DownloadLocation.EXTERNAL_DIRECTORY);
    progressString!.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      setState(() {
        downloading = false;

        _isDisable = false;
      });
      print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
        _isDisable = true;
      });
      print("Some Error");
    });
  }

  Widget imageDownloadDialog() {
    return Container(
      height: 120.0,
      width: 200.0,
      child: Card(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20.0),
            Text(
              "Downloading File : $res",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
  /*var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CacheNetworkImageView(
            imageUrl: widget.imageUrl,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _save();
                },
                child: Stack(children: <Widget>[
                  Container(
                    //height: 50,
                      width: MediaQuery.of(context).size.width - 20,
                      //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      //width : 300
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.white60, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      )),
                  Container(
                    //height: 50,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 20,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    //width : 300
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white60.withOpacity(0.4), width: 1),
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black26,
                            Colors.black38,
                            Colors.black26,
                          ],
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Set Wallpaper",
                        ),
                        Text(
                          "Image will be saved in Gallery",
                        )
                      ],
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      child: Text(
                        "Cancel",
                      ))),
              SizedBox(
                height: 30,
              )
            ],
          )
        ],
      ),
    );
  }

  _save() async {
    await _askPermission();
    var response = await Dio().get(widget.imageUrl,
        options: Options(responseType: ResponseType.bytes));

    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print("Path :$result");
    if (result == "") {
      Fluttertoast.showToast(msg: "Give Storage persmissions from Settings");
    }
    if (result != null) {
      // final imagePath = result['filePath'].toString().replaceAll(RegExp('file://'), '');
      print('reult ! null');
      print(result['filePath']);
      await Wallpaper.homeScreen(
          location: DownloadLocation.APPLICATION_DIRECTORY,
          options: RequestSizeOptions.RESIZE_FIT,
          width: double.infinity,
          height: double.infinity);
      Fluttertoast.showToast(msg: "Image Saved in Gallery");
    } else {
      Fluttertoast.showToast(msg: "Give Storage persmissions from Settings");
    }

    // Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    } else if (Platform.isIOS) {
      await Permission.photos.request();
    } else {
      await Permission.storage.request();
    }
  }*/
}
