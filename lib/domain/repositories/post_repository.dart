import 'package:naxan_test/domain/models/post_model.dart';
import 'dart:io';

abstract class PostRepository {
  /// Récupération par date des derniers posts créé.
  Future<List<PostModel>> findNewest();

  /// Récupération par ID.
  Future<PostModel?> findUnique(String id);

  /// Ajoute un nouveau post de l'utilisateur connecté uniquement.
  Future<void> create(String description, File imageData);

  /// Signale un contenu.
  /// Incrément du niveay de report d'une publie.
  Future<void> report(String id);

  /// Suppression d'un post.
  /// Cela ne marche que si le post provient de l'utilisateur connecté.
  Future<void> delete(String id);
}
