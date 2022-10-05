import 'dart:developer';

import 'package:get/get.dart';
import 'package:jornadagetx_connect/models/user_model.dart';

class UserRepository {
  final getconnect = GetConnect();
  // final getconnect = GetConnect(timeout: const Duration(microseconds: 600));
  UserRepository() {
    getconnect.httpClient.baseUrl = 'http://192.168.10.106:8080';
    getconnect.httpClient.maxAuthRetries = 3;
    var total = 0;
    getconnect.httpClient.addAuthenticator<Object?>((request) async {
      log('addAuthenticator...');
      total++;
      print('$total');
      const email = 'a@email';
      const password = 'aaa';
      final result = await getconnect.post('/auth', {
        'email': email,
        'password': password,
      });
      if (!result.hasError) {
        final accessToken = result.body['access_token'];
        final type = result.body['type'];
        if (accessToken != null) {
          request.headers['authorization'] = '$type $accessToken';
        }
      } else {
        log('Erro ao fazer authorization ${result.statusText}');
      }
      return request;
    });
    getconnect.httpClient.addRequestModifier<Object?>((request) {
      log('addRequestModifier...');
      log(request.url.toString());
      request.headers['start-time'] = DateTime.now().toIso8601String();
      return request;
    });
    getconnect.httpClient.addResponseModifier((request, response) {
      log('addResponseModifier...');
      response.headers?['end-time'] = DateTime.now().toIso8601String();
      return response;
    });
  }
  Future<List<UserModel>> findAll() async {
    final result = await getconnect.get('/users');
    if (result.hasError) {
      throw Exception('Erro ao buscar dados (${result.statusText})');
    }
    log(result.request?.headers['start-time'] ?? '...');
    log(result.headers?['end-time'] ?? '...');
    return result.body
        .map<UserModel>((user) => UserModel.fromMap(user))
        .toList();
  }

  Future<void> save(UserModel user) async {
    final result = await getconnect.post('/users', user.toMap());
    if (result.hasError) {
      throw Exception('Erro ao salvar dados (${result.statusText})');
    }
  }

  Future<void> delete(int userId) async {
    final result = await getconnect.delete('/users/$userId');
    if (result.hasError) {
      throw Exception('Erro ao delete dados (${result.statusText})');
    }
  }

  Future<void> update(UserModel user) async {
    final result = await getconnect.put('/users/${user.id}', user.toMap());
    if (result.hasError) {
      throw Exception('Erro ao update dados (${result.statusText})');
    }
  }
}
