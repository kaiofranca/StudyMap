abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<String> save(T entity);
  Future<void> delete(String id);
}
