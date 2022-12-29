import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

class AuthService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('user');

  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
    // 현재 유저(로그인 되지 않은 경우 null 반환)
  }

  void signUp({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 회원가입

    // 이메일 및 비밀번호 입력 여부 확인
    if (email.isEmpty) {
      onError("이메일을 입력해 주세요.");
      return;
    } else if (password.isEmpty) {
      onError("비밀번호를 입력해 주세요.");
      return;
    }

    // firebase auth 회원 가입
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 성공 함수 호출
      onSuccess();
    } on FirebaseAuthException catch (e) {
      // Firebase auth 에러 발생
      onError(e.message!);
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }

    notifyListeners();
  }

  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    if (email.isEmpty) {
      onError('이메일을 입력해주세요.');
      return;
    } else if (password.isEmpty) {
      onError('비밀번호를 입력해주세요.');
      return;
    }

    // 로그인 시도
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      onSuccess(); // 성공 함수 호출
      notifyListeners(); // 로그인 상태 변경 알림
    } on FirebaseAuthException catch (e) {
      // firebase auth 에러 발생
      onError(e.message!);
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }
    // 로그인
  }

  void createUserData(
      {required String uid,
      required String email,
      required String name,
      required String sex,
      required int birth,
      required String mbti,
      required String mbtiMean,
      required DateTime signupDate,
      required DateTime? deleteDate}) async {
    await bucketCollection.add({
      'uid': uid,
      'email': email,
      'name': name,
      'sex': sex,
      'birth': birth,
      'mbti': mbti,
      'mbtiMean': mbtiMean,
      'signupDate': signupDate,
      'deleteDate': deleteDate
    });

    notifyListeners();
  }

  void deleteUser({
    required String uid, // 이메일
  }) async {
    await currentUser()!.delete();
  }

  Future<bool> doubleCheck(String email) async {
    bool data = false;
    await bucketCollection.where('email', isEqualTo: email).get().then((value){
      if (value.docs.isEmpty){
        data = false;
      } else {
        data = true;
      }
    });
    return data;
  }

  Future<QuerySnapshot> getUserDate(String uid) async {
    return bucketCollection.where('uid', isEqualTo: uid).get();
  }


  void signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
    // 로그아웃
  }
}

 class MbtiService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('etcDB');

  Future<QuerySnapshot> read() async {
    return bucketCollection.get();
  }
 }

class UserData extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('user');

  var userUid;
  var email;
  var name;
  var sex;
  var birth;
  var mbti;
  var mbtiMean;
  var signupDate;
  var deleteDate;

  Future<void> getUserData(String uid) async {
    var data = await bucketCollection.where('uid', isEqualTo: uid).get();

    userUid = uid;
    email = await data.docs[0].data()['email'];
    name = await data.docs[0].data()['name'];
    sex = await data.docs[0].data()['sex'];
    birth = await data.docs[0].data()['birth'];
    mbti = await data.docs[0].data()['mbti'];
    mbtiMean = await data.docs[0].data()['mbtiMean'];
    signupDate = await data.docs[0].data()['signupDate'];
    deleteDate = await data.docs[0].data()['deleteDate'];

  }
}

String? meanMBTI(String mbti) {

  final Map<String, String> listMean = {
    'INTJ' : '용의주도한 전략가',
    'INTP' : '논리적인 사색가',
    'ENTJ' : '대담한 통솔자',
    'ENTP' : '뜨거운 논쟁을 즐기는 변론가',
    'INFJ' : '선의의 옹호자',
    'INFP' : '열정적인 중재자',
    'ENFJ' : '정의로운 사회운동가',
    'ENFP' : '재기발랄한 활동가',
    'ISTJ' : '청렴결백한 논리주의자',
    'ISFJ' : '용감한 수호자',
    'ESTJ' : '엄격한 관리자',
    'ESFJ' : '사교적인 외교관',
    'ISTP' : '만능 재주꾼',
    'ISFP' : '호기심 많은 예술가',
    'ESTP' : '모험을 즐기는 사업가',
    'ESFP' : '자유로운 영혼의 연예인'
  };

  return listMean[mbti];
}