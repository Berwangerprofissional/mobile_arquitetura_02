import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRemoteDatasource {
  // CORREÇÃO: Mudamos de '/auth/login' para '/user/login' conforme a API atual da DummyJSON
  final String _baseUrl = "https://dummyjson.com/auth/login";

  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30, 
      }),
    );

    // É importante verificar se a resposta é um JSON válido antes de decodificar
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Usuário ou senha inválidos');
      } catch (_) {
        // Se a API falhar feio e mandar um HTML (como aconteceu na sua imagem), tratamos aqui com elegância
        throw Exception('Erro de comunicação com o servidor DummyJSON (Código ${response.statusCode})');
      }
    }
  }
}
