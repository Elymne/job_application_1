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
  final collectionName = "profiles";

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

    final profileData = (await FirebaseFirestore.instance.collection(collectionName).doc(authUser.uid).get()).data();
    if (profileData == null) {
      return null;
    }

    return ProfileModel.fromJson((profileData));
  }

  @override
  Future<void> deleteCurrent() async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      throw Exception("User not connected while trying to delete profile");
    }

    // * delete rpofile first.
    final snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where("id", isEqualTo: authUser.uid)
        .get();
    final docs = snapshot.docs;
    if (docs.isEmpty) {
      throw FirebaseException(plugin: "firestore", message: "Le profil n'existe pas");
    }
    await FirebaseFirestore.instance.collection(collectionName).doc(authUser.uid).delete();

    // * Then account
    await authUser.delete();
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
    await FirebaseFirestore.instance.collection(collectionName).doc(authUser.uid).set(newProfile.toJson());
  }

  @override
  Future<ProfileModel?> findProfile(String id) async {
    final profileData = (await FirebaseFirestore.instance.collection(collectionName).doc(id).get()).data();
    if (profileData == null) {
      return null;
    }

    return ProfileModel.fromJson((profileData));
  }

  @override
  Future<void> updateProfile({ProfileModel? profileModel, File? imageData}) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    if (imageData != null) {
      final typeFile = imageData.path.split(".").last;
      final fileId = "${const Uuid().v4()}.$typeFile";
      final formData = FormData.fromMap({"image": await MultipartFile.fromFile(imageData.path, filename: fileId)});
      final uploadRes = await Dio().post(serverImageScriptUrl, data: formData);
      if (jsonDecode(uploadRes.data)["success"] == false) {
        throw DioException(requestOptions: RequestOptions());
      }
    }

    if (profileModel != null) {
      await FirebaseFirestore.instance.collection(collectionName).doc(authUser.uid).set(profileModel.toJson());
    }
  }

  @override
  Future<bool> checkPassword(String password) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      return false;
    }

    final status = await FirebaseAuth.instance.validatePassword(FirebaseAuth.instance, password);
    return status.isValid;
  }

  @override
  Future<void> resetPassword(String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updatePassword(String password) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      throw Exception("User not connected while trying to reset password");
    }

    await authUser.updatePassword(password);
  }
}
