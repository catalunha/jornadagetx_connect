import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jornadagetx_connect/pages/home/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: controller.obx(
        (state) {
          if (state == null) {
            return const Center(child: Text('Nenhum usuario cadastrado'));
          }
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: ((context, index) {
              final user = state[index];
              return ListTile(
                title: Text(user.name),
                onTap: () {
                  controller.updateUser(user);
                },
                onLongPress: () {
                  controller.deleteUser(user);
                },
              );
            }),
          );
        },
        onEmpty: const Center(child: Text('Nenhum usuario cadastrado')),
        onError: (error) =>
            const Center(child: Text('Erro ao buscar usuarios')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.registerUser();
        },
        child: const Icon(Icons.add),
      ),
      // body: Center(
      //   child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: const [
      //         Text('...'),
      //       ]),
      // ),
    );
  }
}
