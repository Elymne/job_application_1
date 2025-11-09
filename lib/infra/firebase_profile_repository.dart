import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/core/constants.dart';
import 'package:naxan_test/domain/models/profile_model.dart';
import 'package:naxan_test/domain/repositories/profile_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

final profileRepoProvider = Provider<ProfileRepository>((ref) {
  return FirebaseProfileRepository();
});

class FirebaseProfileRepository implements ProfileRepository {
  late final CollectionReference _profileCollection = FirebaseFirestore.instance.collection('profiles');

  @override
  Future<bool> isConnected() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Future<ProfileModel?> getCurrent() async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      return null;
    }

    final profileData = (await _profileCollection.doc(authUser.uid).get()).data();
    if (profileData == null) {
      return null;
    }

    return ProfileModel.fromJson((profileData as Map<String, dynamic>));
  }

  @override
  Future<void> addNewAccount(String email, String pwd) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pwd);
  }

  @override
  Future<void> login(String email, String pwd) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pwd);
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> createProfile(String surname, String firstname, File imageData) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    // * store image to my server.
    final typeFile = imageData.path.split(".").last;
    final fileId = "${const Uuid().v4()}.$typeFile";
    final formData = FormData.fromMap({"image": await MultipartFile.fromFile(imageData.path, filename: fileId)});
    final uploadRes = await Dio().post(serverImageScriptUrl, data: formData);
    if (jsonDecode(uploadRes.data)["success"] == false) {
      throw DioException(requestOptions: RequestOptions());
    }

    // * Store info to firestore.
    final newProfile = ProfileModel(
      id: authUser.uid,
      email: authUser.email!,
      firstname: firstname,
      surname: surname,
      imageId: fileId,
    );
    await _profileCollection.doc(authUser.uid).set(newProfile.toJson());
  }

  @override
  Future<ProfileModel?> findProfile(String id) async {
    final profileData = (await _profileCollection.doc(id).get()).data();
    if (profileData == null) {
      return null;
    }

    return ProfileModel.fromJson((profileData as Map<String, dynamic>));
  }

  @override
  Future<void> updateProfile(ProfileModel profileModel, File imageData) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    // TODO: le reste et surement un changement de signature de fonction.
  }
}
