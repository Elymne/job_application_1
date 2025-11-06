import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/domain/models/profile_model.dart';
import 'package:naxan_test/domain/repositories/profile_repository.dart';
import 'dart:async';

final profileRepoProvider = Provider<ProfileRepository>((ref) {
  return FirebaseProfileRepository();
});

class FirebaseProfileRepository implements ProfileRepository {
  late final CollectionReference _profileCollection = FirebaseFirestore.instance
      .collection('profiles');

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
    final profileDoc = await _profileCollection.doc(authUser.uid).get();
    return ProfileModel.fromJson((profileDoc.data() as Map<String, dynamic>));
  }

  /// Exception [FirebaseAuthException] code:
  /// - weak-password
  /// - email-already-in-use
  @override
  Future<void> addNewAccount(String email, String pwd) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pwd,
    );
  }

  /// Exceptions [FirebaseAuthException] code:
  /// - user-not-found
  /// - wrong-password
  @override
  Future<void> login(String email, String pwd) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pwd,
    );
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Exceptions [FirebaseAuthException] code:
  /// - user-not-found
  @override
  Future<void> putProfile(ProfileModel profileModel) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    await _profileCollection.doc(profileModel.id).set(profileModel.toJson());
  }

  /// Exceptions [FirebaseAuthException] code:
  /// - user-not-found
  @override
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
