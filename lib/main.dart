import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jornadagetx_connect/pages/home/home_controller.dart';
import 'package:jornadagetx_connect/pages/home/home_page.dart';
import 'package:jornadagetx_connect/repositories/user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
          name: '/',
          binding: BindingsBuilder(() {
            Get.lazyPut(() => UserRepository());
            Get.put(HomeController(userRepository: Get.find()));
          }),
          page: () => const HomePage(),
        ),
      ],
    );
  }
}
