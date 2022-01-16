import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'secret.dart';

class ApiService {
  var log = Logger();
  var secret = Secret();

  Future getImageBySearch(String search, int num) async {
    final baseHeader = {
      HttpHeaders.authorizationHeader: ('Accept-Version: v1'
          'Authorization: Client-ID ${secret.accessKey}')
    };
    String myUrl =
        'https://api.unsplash.com/search/photos?page=1&query=$search&per_page=$num';
    final response = await http.get(Uri.parse(myUrl), headers: baseHeader);
    List imageData = json.decode(response.body)['results'];
    return imageData;
  }
}
