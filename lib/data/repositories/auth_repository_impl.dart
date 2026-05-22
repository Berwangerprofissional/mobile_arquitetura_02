import '../../core/session/session_manager.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final SessionManager _sessionManager = SessionManager();

  AuthRepositoryImpl(this._datasource);

  @override
  Future<UserModel> login(String username, String password) async {
    // 1. Faz a chamada na API buscando o usuário e o Token
    final user = await _datasource.login(username, password);
    
    // 2. Salva o usuário retornado diretamente no gerenciador de sessão do app
    _sessionManager.saveSession(user);
    
    return user;
  }
}
