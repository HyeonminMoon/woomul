import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FcmService extends ChangeNotifier {
  final String _fcmKey =
      'AAAAwSXxpWc:APA91bGCRLRO9T6a-vLDdfNqybjLZo3bGBhmYeawBNngPnKwZfCUHaedpiEiB3O81bp-gnw_5UoyEzl7uLyHJSe0poCTB-Lu9PbnUOZWnBa6TXeDDh4I2bO0b3T2w4O0_QynVisr5aBZ';

  sendMessageNotification({
    required String name,
    required String message,
    required String boardWriterUid,
  }) async {
    // 게시글 작성자가 포함되어있는 user doc의 id값을 구함
    final boardWriterUserSnap = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: boardWriterUid)
        .get();

    final boardWriterUserDocId = boardWriterUserSnap.docs[0].id;

    // 게시글 작성자의 document
    final userSnap =
        await FirebaseFirestore.instance.collection('user').doc(boardWriterUserDocId).get();

    // 게시글 작성자의 pushToken
    final String pushToken = userSnap.get('pushToken');
    final bool isPushAlarmTurnOn = userSnap.get('isPushAlarmTurnOn');

    if (isPushAlarmTurnOn) {
      try {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$_fcmKey'
          },
          body: jsonEncode(
            {
              'notification': {
                'title': '$name',
                'body': '$message',
                'sound': 'false',
              },
              'to': '${pushToken}'
            },
          ),
        );
      } catch (e) {
        print('error $e');
      }
    }
  }
}
