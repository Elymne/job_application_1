abstract class PostRepository {
  /// Pas besoin de params pour l'exemple, on va juste renvoyer une liste brute issu de la DB tout de même.
  Future<List<Object>> findNewest();
}
