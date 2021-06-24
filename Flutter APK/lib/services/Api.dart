import 'dart:convert';

import 'package:http/http.dart';

class ApiProvider {
  Future getImage(imageHash) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'Keep-Alive',
    };
    var url = Uri.parse('http://192.168.1.126:5000/predict');
    var body = json.encode(imageHash);
    Response response = await post(url, body: body, headers: headers).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        return json.decode(
            '{"success":false,"message":"We have Some Internal Issuse!"}');
      },
    );
    print(response.body);

    return json.decode(response.body);
  }
}
