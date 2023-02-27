import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoardService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('board');

  Future<QuerySnapshot> read(boardName) async {
    // 내 bucketList 가져오기
    return bucketCollection
        .orderBy('createDate', descending: true)
        .where('boardType', isEqualTo: boardName)
        .limit(6)
        .get();
  }

  Future<QuerySnapshot> readOne(boardKey) async {
    // 내 bucketList 가져오기
    return bucketCollection
        .where('key', isEqualTo: boardKey)
        .get(); // return 값 미구현 에러
  }

  Future<String> readBoardType(boardKey) async {
    // contentKey를 보고 게시판 이름 맞추기
    var data = await bucketCollection.where('key', isEqualTo: boardKey).get();
    var board = data.docs[0].get('boardType');
    return board;
  }

  Future<QuerySnapshot> readGood(String data) async {
    // HOT , BEST 게시판 로직 만들어야 함
    String date = DateFormat('yyyyMM').format(DateTime.now());
    return bucketCollection
        .where("createDateMonth", isEqualTo: date)
        .orderBy(data, descending: true)
        .get();
  }

  Future<QuerySnapshot> readLimit(String data, int unit) async {
    //메인 게시판에서 BEST , HOT 하나씩 읽어오는거!
    return bucketCollection.orderBy(data, descending: true).limit(unit).get();
    // where("createDate", isGreaterThan: date).
  }

  Future<QuerySnapshot> readAll(uid) async {
    //유저 기준으로 이 사람이 작성한 모든 글을 보여줌
    return bucketCollection
        .where('userUid', isEqualTo: uid)
        .orderBy('createDate', descending: true)
        .get();
  }

  void create(
      {required String key,
      required String userUid,
      required String name,
      required String sex,
      required String? firstPicUrl,
      required double ageNum,
      required List<dynamic> ageRange,
      required List<dynamic> mbti,
      required String userMbti,
      required String userMbtiMean,
      required String? boardType,
      required String createDateMonth,
      required DateTime createDate,
      required String title,
      required String content,
      required int commentNum,
      required int likeNum}) async {
    await bucketCollection.add({
      'key': key,
      'userUid': userUid,
      'name': name,
      'sex': sex,
      'firstPicUrl': firstPicUrl,
      'ageNum': ageNum,
      'ageRange': ageRange,
      'mbti': mbti,
      'userMbti': userMbti,
      'userMbtiMean': userMbtiMean,
      'boardType': boardType,
      'createDateMonth': createDateMonth,
      'createDate': createDate,
      'title': title,
      'content': content,
      'commentNum': commentNum,
      'likeNum': likeNum
    });

    // bucket 만들기
  }

  void update(String docId, String data, int value) async {
    await bucketCollection.doc(docId).update({data: value});
    notifyListeners();
  }

  void delete(String docId) async {
    // bucket 삭제
  }
}
