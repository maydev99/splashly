import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:layout/api_service.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  var log = Logger();
  var apiService = ApiService();
  TextEditingController searchController = TextEditingController();
  List data = [];
  List<String> imgUrl = [];
  bool isDoneLoading = false;



  Future getImages(String search) async {
    data = await apiService.getImageBySearch(search, 30);
    imgUrl.clear();

    for (var i = 0; i < data.length; i++) {
      var url = await data.elementAt(i)['urls']['regular'];
      imgUrl.add(url);
    }
    setState(() {
      imgUrl;
    });
  }

  _launchURL(String url) {
    launch(url, forceSafariVC: true, enableJavaScript: true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 58.0, bottom: 8, right: 8, left: 8),
          child: TextFormField(
            controller: searchController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Search',
                suffixIcon: GestureDetector(
                    onTap: () {
                      getImages(searchController.text);
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      //searchController.text = '';
                    },
                    child: const Icon(Icons.search))),
          ),
        ),
        Expanded(
          child: ListView(
              children: List.generate(imgUrl.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                elevation: 10,
                child: GestureDetector(
                  onTap: () {
                    _launchURL(imgUrl.elementAt(index));
                  },
                  child: CachedNetworkImage(
                    imageUrl: imgUrl.elementAt(index),
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          })),
        )
      ]),
    );
  }
}
