import 'dart:io';

import 'package:naxan_test/domain/models/profile_model.dart';

abstract class ProfileRepository {
  /// Permet simplement de savoir si un utilisateur est actuellement connecté depuis l'app.
  Future<bool> isConnected();

  /// Récupère les infos du profil connecté.
  /// return [ProfileModel] ou [Null]
  Future<ProfileModel?> getCurrent();

  /// Tente de se log sur l'app.
  Future<void> login(String email, String pwd);

  /// Se déconnecte, renvoie une exception si pas connecté ?
  Future<void> logout();

  /// Reset le MDP.
  Future<void> resetPassword(String email);

  /// Permet de créer un compte d'authentification.
  Future<void> addNewAccount(String email, String pwd);

  /// Ajout d'un nouveau profil associé à l'utilisateur connecté.
  /// L'utilisateur doit donc-être connecté pour utiliser lors de l'utilisation de cette fonction.
  Future<void> createProfile(String surname, String firstname, File imageData);

  /// Modification d'un profil associé à l'utilisateur connecté.
  /// L'utilisateur doit donc-être connecté pour utiliser lors de l'utilisation de cette fonction.
  Future<void> updateProfile(ProfileModel profileModel, File imageData);

  /// Récupération d'un profil via l'id.
  Future<ProfileModel?> findProfile(String id);
}
