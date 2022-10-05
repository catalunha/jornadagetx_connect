import 'dart:developer';

import 'package:get/get.dart';
import 'package:jornadagetx_connect/models/user_model.dart';
import 'package:jornadagetx_connect/repositories/user_repository.dart';

class HomeController extends GetxController with StateMixin<List<UserModel>> {
  final UserRepository _userRepository;
  HomeController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;
  @override
  void onReady() {
    _findAllUser();
    super.onReady();
  }

  void _findAllUser() async {
    try {
      change([], status: RxStatus.loading());
      final users = await _userRepository.findAll();
      var statusReturn = RxStatus.success();
      if (users.isEmpty) {
        statusReturn = RxStatus.empty();
      }
      change(users, status: statusReturn);
    } catch (e, s) {
      log('Erro ao buscar usuarios', error: e, stackTrace: s);
      change(state, status: RxStatus.error());
    }
  }

  Future<void> registerUser() async {
    try {
      final user = UserModel(name: 'a', email: 'email', password: 'password');
      await _userRepository.save(user);
      _findAllUser();
    } catch (e, s) {
      log('Erro ao salvar usuario.', error: e, stackTrace: s);
      Get.snackbar('Erro', 'Erro ao salvar usuario.');
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await _userRepository.delete(user.id!);
      _findAllUser();
    } catch (e, s) {
      log('Erro ao atualizar usuario.', error: e, stackTrace: s);
      Get.snackbar('Erro', 'Erro ao atualizar usuario.');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      user.name = 'b';
      await _userRepository.update(user);
      _findAllUser();
    } catch (e, s) {
      log('Erro ao atualizar usuario.', error: e, stackTrace: s);
      Get.snackbar('Erro', 'Erro ao atualizar usuario.');
    }
  }
}
