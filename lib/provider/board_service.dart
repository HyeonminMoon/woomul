import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('board');

  Future<QuerySnapshot> read(boardName) async {
    // 내 bucketList 가져오기
    return bucketCollection
        .orderBy('createDate', descending: true)
        .where('boardType', isEqualTo: boardName)
        .get();
  }

  Future<QuerySnapshot> readOne(boardKey) async {
    // 내 bucketList 가져오기
    return bucketCollection
        .where('key', isEqualTo: boardKey)
        .get(); // return 값 미구현 에러
  }

  Future<String> readBoardType(boardKey) async {
    // 내 bucketList 가져오기
    var data = await bucketCollection.where('key', isEqualTo: boardKey).get();
    var board = data.docs[0].get('boardType');
    return board;
  }

  Future<QuerySnapshot> readGood(String data, int days) async {
    DateTime date = DateTime.now().subtract(Duration(days: days));
    print(DateTime.now());
    return bucketCollection.where("createDate", isGreaterThan: date).orderBy(data, descending: true).get();
  }

  Future<QuerySnapshot> readLimit(String data, int unit) async {
    return bucketCollection.orderBy(data, descending: true).limit(unit).get();
    // where("createDate", isGreaterThan: date).
  }

  Future<QuerySnapshot> readAll(uid) async {
    return bucketCollection
        .where('userUid', isEqualTo: uid)
        .orderBy('createDate', descending: true)
        .get();
  }

  void create(
      {required String key,
      required String userUid,
      required String name,
      required String? firstPicUrl,
      required double ageNum,
      required String ageRange,
      required List<dynamic> mbti,
      required String? boardType,
      required DateTime createDate,
      required String title,
      required String content,
      required int commentNum,
      required int likeNum}) async {
    await bucketCollection.add({
      'key': key,
      'userUid': userUid,
      'name': name,
      'firstPicUrl': firstPicUrl,
      'ageNum': ageNum,
      'ageRange': ageRange,
      'mbti': mbti,
      'boardType': boardType,
      'createDate': createDate,
      'title': title,
      'content': content,
      'commentNum': commentNum,
      'likeNum': likeNum
    });

    // bucket 만들기
  }

  void update(String docId, bool isDone) async {
    // bucket isDone 업데이트
  }

  void delete(String docId) async {
    // bucket 삭제
  }
}
