import 'package:flutter/material.dart';
import '../pages/filtro_page.dart';
import '../pages/lista_turismo_pages.dart';

void main() {
  runApp(const AppGerenciadorTurismo());
}

class AppGerenciadorTurismo extends StatelessWidget {
  const AppGerenciadorTurismo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App - Gerenciador de turismo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ListaTurismoPage(),
      routes: {
        FiltroPage.routeName: (BuildContext context) => FiltroPage(),
      },
    );
  }
}