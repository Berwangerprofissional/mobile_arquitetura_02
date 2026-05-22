import '../../data/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final UserModel? user;

  AuthState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  // Auxiliar para clonar o estado alterando apenas o que mudou
  AuthState copyWith({
    bool? isLoading,
    String? error,
    UserModel? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Se não for passado, reseta para null
      user: user ?? this.user,
    );
  }
}
