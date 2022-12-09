import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikeService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('board_like');

  Future<QuerySnapshot> read(String userUid, contentKey) async {
    // 내 bucketList 가져오기
    return bucketCollection.where('userUid', isEqualTo: userUid).where('contentKey', isEqualTo: contentKey).get();// return 값 미구현 에러
  }

  void create({
    required String name,
    required String userUid,
    required String contentKey,
    required bool like
  }) async {
    await bucketCollection.add({
      'name': name,
      'userUid': userUid,
      'contentKey': contentKey,
      'like': like
    });

  }

  void update(String docId, bool isDone) async {
    // bucket isDone 업데이트
  }

  void delete(String docId) async {
    // bucket 삭제
  }
}