import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:lawyermobile/src/app_shared.dart';

class CaseApi {
  String baseUrl = 'https://visaino.com/lawyers/backend/public';
  Future fetchCase({required caseUnique}) async {
    try {
      var request =
          await http.post(Uri.parse('$baseUrl/cases/show_case.php'), body: {
        'case_unique': caseUnique,
        'fcm_token': AppShared.localStorage!.getString('token')
      });
      if (request.statusCode == 200) {
        var response = jsonDecode(request.body);
        return response;
      } else {
        return 'error';
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
