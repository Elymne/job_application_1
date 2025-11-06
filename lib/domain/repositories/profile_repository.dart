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

  /// Permet de créer un compte.
  Future<void> addNewAccount(String email, String pwd);

  /// Ajoute ou modifie un profil.
  Future<void> putProfile(ProfileModel profileModel);
}
