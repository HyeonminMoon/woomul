import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikeService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('board_like');

  Future<QuerySnapshot> read(contentKey) async {
    // 내 bucketList 가져오기
    return bucketCollection.where('contentKey', isEqualTo: contentKey).get();// return 값 미구현 에러
  }

  Future<QuerySnapshot> readOne(String userUid, contentKey) async {
    // 내 bucketList 가져오기
    return bucketCollection.where('userUid', isEqualTo: userUid).where('contentKey', isEqualTo: contentKey).get();// return 값 미구현 에러
  }

  Future<int> readNum(String contentKey) async {
    // 내 bucketList 가져오기
    var data = bucketCollection
        .where('contentKey', isEqualTo: contentKey);

    var querySnapshot = await data.get();
    var totalNum = await querySnapshot.docs.length;

    return totalNum;
  }

  void create({
    required String name,
    required String userUid,
    required String contentKey,
    required DateTime createDate
  }) async {
    await bucketCollection.add({
      'name': name,
      'userUid': userUid,
      'contentKey': contentKey,
      'createDate': createDate
    });

    notifyListeners();

  }

  void update(String docId, bool isDone) async {
    // bucket isDone 업데이트
  }

  void delete(String docID) async {
    // bucket 삭제
    await bucketCollection.doc(docID).delete();
    notifyListeners();
  }
}