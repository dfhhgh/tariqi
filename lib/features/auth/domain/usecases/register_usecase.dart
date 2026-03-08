import '../repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call(
    String email,
    String password,
    String name,
  ) {
    return repository.register(
      email: email,
      password: password,
      name: name,
    );
  }
}
