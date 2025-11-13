import 'dart:io';

import 'package:naxan_test/domain/models/profile_model.dart';

abstract class ProfileRepository {
  /// Permet simplement de savoir si un utilisateur est actuellement connecté depuis l'app.
  Future<bool> isConnected();

  /// Récupère les infos du profil connecté.
  /// return [ProfileModel] ou [Null]
  Future<ProfileModel?> getCurrent();

  /// Supprime le profil + l'utilisateur courrant.
  /// Nécessite d'être connecté à l'app.
  Future<void> deleteCurrent();

  /// Tente de se log sur l'app.
  Future<void> login(String email, String pwd);

  /// Se déconnecte, renvoie une exception si pas connecté ?
  Future<void> logout();

  /// Vérifie que le mot de passe rentré est le correct.
  /// Nécessite que l'utilisateur soit déjà connecté.
  Future<bool> checkPassword(String password);

  /// Modifie le mot de passe
  /// Nécessite que l'utilisateur soit déjà connecté.
  Future<void> resetPassword(String email);

  /// Modifie le mot de passe
  /// Nécessite que l'utilisateur soit déjà connecté.
  Future<void> updatePassword(String password);

  /// Permet de créer un compte d'authentification.
  Future<void> addNewAccount(String email, String pwd);

  /// Ajout d'un nouveau profil associé à l'utilisateur connecté.
  /// L'utilisateur doit donc-être connecté pour utiliser lors de l'utilisation de cette fonction.
  Future<void> createProfile(String surname, String firstname, File imageData);

  /// Modification d'un profil associé à l'utilisateur connecté.
  /// L'utilisateur doit donc-être connecté pour utiliser lors de l'utilisation de cette fonction.
  Future<void> updateProfile({ProfileModel? profileModel, File? imageData});

  /// Récupération d'un profil via l'id.
  Future<ProfileModel?> findProfile(String id);
}
