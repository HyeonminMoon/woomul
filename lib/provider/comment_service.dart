import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('board_comment');

  Future<QuerySnapshot> read(String contentKey) async {
    // 내 bucketList 가져오기
    return bucketCollection.where('contentKey', isEqualTo: contentKey).get(); // return 값 미구현 에러
  }

  void create({
    required String uid,
    required String name,
    required String mbti,
    required String comment,
    required String contentKey,
    required String commentKey,
    required DateTime createDate,
    required int likeNum
    }) async {
    // bucket 만들기

    await bucketCollection.add({
      'uid': uid,
      'name': name,
      'mbti': mbti,
      'comment': comment,
      'contentKey': contentKey,
      'commentKey': commentKey,
      'createDate': createDate,
      'likeNum': likeNum,
    });
  }

  void update(String docId, bool isDone) async {
    // bucket isDone 업데이트
  }

  void delete(String docId) async {
    // bucket 삭제
  }
}