abstract class RemoteDatabaseGateway<T> {
  Future<void> start();
  Future<T> getConnect();
}
