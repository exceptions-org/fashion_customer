import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void launchMap(String address) async {
  var url = '';
  url =
      'https://www.google.com/maps/dir/?api=1&destination=${address}&travelmode=driving&dir_action=navigate';

  await launch(url);
}

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class KConstants {
  static const kPrimary100 = Color(0xff604FCD);
  static const kPrimary75 = Color(0xff887BD9);
  static const kPrimary25 = Color(0xffD7D3F3);
  static const kTextfeildColor = Color(0xffAFA7E6);
  static const kBgColor = Color(0xffFAFAFF);
  static const txtColor100 = Color(0xff130B43);
  static const txtColor75 = Color(0xff4E4872);
  static const kBorderColor = Color(0xffC7D4EE);
  static const textColor50 = Color(0xff8985A1);
  static const textColor25 = Color(0xffD7D3F3);

  static const greenOrderState = Color(0xff058F13);

  static BoxDecoration defContainerDec = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: kBorderColor),
  );

  static Future<void> sendFCMMessage(
      String title, String body, String pushToken,
      {Map<String, dynamic>? data}) async {
    HttpClient client = HttpClient();
    HttpClientRequest request =
        await client.postUrl(Uri.parse("https://fcm.googleapis.com/fcm/send"));
    request.headers.add('Content-Type', "application/json; charset=utf-8");
    request.headers.add('Authorization',
        "key=	AAAAe9W6Ez0:APA91bFuikZhaWYXvfh9rG6dVuF0HZ-aLyK827Z-eb_knCAxl2DSgdiP7OhVRcO79UMEK4VHzmp5y6eHhG_Yd81MKMehMRJ9-8lJoKltyA8Uj5kVYQVdf70W6BAPQfmnTmkiAe-qb5EM");
    request.write(jsonEncode({
      'to': pushToken,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': data,
    }));
    var response = await request.close();
    print(response.statusCode);
  }
}
