import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('board');

  Future<QuerySnapshot> read(boardName) async {
    // 내 bucketList 가져오기
    return bucketCollection
        .where('boardType', isEqualTo: boardName)
        .get();
  }

  Future<QuerySnapshot> readOne(boardKey) async {
    // 내 bucketList 가져오기
    return bucketCollection
        .where('key', isEqualTo: boardKey)
        .get(); // return 값 미구현 에러
  }

  Future<QuerySnapshot> readGood(data) async {
    return bucketCollection.orderBy('$data', descending: true).get();
  }

  Future<QuerySnapshot> readAll(uid) async {
    return bucketCollection.where('userUid', isEqualTo: uid).get();
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
