import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/core/constants.dart';
import 'package:naxan_test/domain/models/post_model.dart';
import 'package:naxan_test/domain/repositories/post_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

final postRepoProvider = Provider<PostRepository>((ref) {
  return FirebasePostRepository();
});

class FirebasePostRepository implements PostRepository {
  final collectionName = "posts";

  @override
  Future<void> create(String description, File imageData) async {
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

    // * Store post data to firestore.
    final newPost = PostModel(
      id: const Uuid().v4(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      description: description,
      imageId: fileId,
      profileId: authUser.uid,
      reportCount: 0,
    );
    await FirebaseFirestore.instance.collection(collectionName).doc(authUser.uid).set(newPost.toJson());
  }

  @override
  Future<void> delete(String id) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    final snapshot = await FirebaseFirestore.instance.collection(collectionName).where("id", isEqualTo: id).get();
    final docs = snapshot.docs;
    if (docs.isEmpty) {
      throw FirebaseException(
        plugin: "firestore",
        message: "Le post en question n'existe pas ou n'est pas celui du l'utilisateur courrant",
      );
    }

    // * Sur que le post vient de l'utilisateur courrant.
    await FirebaseFirestore.instance.collection(collectionName).doc(id).delete();
  }

  @override
  Future<List<PostModel>> findNewest() async {
    final snapshot = await FirebaseFirestore.instance.collection(collectionName).limit(20).orderBy("createdAt").get();
    final docs = snapshot.docs;
    final posts = docs.map((elem) => PostModel.fromJson(elem.data()));

    return posts.toList();
  }

  @override
  Future<void> report(String id) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    final snapshot = await FirebaseFirestore.instance.collection(collectionName).where("id", isEqualTo: id).get();
    final docs = snapshot.docs;
    if (docs.isEmpty) {
      throw FirebaseException(plugin: "firestore", message: "Le post en question n'existe pas.");
    }

    final post = PostModel.fromJson(docs.first.data());
    final updatedPost = post.copyWith(reportCount: post.reportCount + 1);
    await FirebaseFirestore.instance.collection(collectionName).doc(id).set(updatedPost.toJson());
  }
}
