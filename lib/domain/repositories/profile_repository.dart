import 'package:naxan_test/domain/models/profile_model.dart';

abstract class ProfileRepository {
  /// Récupère les info courrente de l'utilisateur connecté.
  /// Peut retourner null si l'utilisateur n'est pas connecté.
  Future<ProfileModel?> getCurrent();

  /// Tente de se log sur l'app.
  Future<bool> login(String email, String pwd);

  /// Reset le MDP.
  Future<void> resetPassword(String email);

  /// Permet de créer un compte.
  Future<void> createAccount(String email, String pwd);

  /// permet d'enrichir le compte (nom, prénom et image de profil)
  Future<void> developProfile(String firstname, String surname, String imageBlob);
}
