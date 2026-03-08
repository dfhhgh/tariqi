abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> resetPassword({required String email});
}
