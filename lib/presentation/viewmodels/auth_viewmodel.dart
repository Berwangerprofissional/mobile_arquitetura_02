import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthViewModel {
  final AuthRepository _repository;

  // Notificador de estado idêntico ao que você usa nos produtos
  final ValueNotifier<AuthState> state = ValueNotifier<AuthState>(AuthState());

  AuthViewModel(this._repository);

  Future<bool> login(String username, String password) async {
    // 1. Define o estado como carregando e limpa erros anteriores
    state.value = state.value.copyWith(isLoading: true);

    try {
      // 2. Tenta realizar o login através do repositório
      final user = await _repository.login(username, password);
      
      // 3. Sucesso: atualiza o estado com o usuário
      state.value = AuthState(user: user);
      return true;
    } catch (e) {
      // 4. Erro: captura a mensagem da exceção (ex: "Usuário ou senha inválidos")
      // Remove o texto "Exception: " caso ele venha junto na mensagem
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      state.value = AuthState(error: errorMessage);
      return false;
    }
  }
}
