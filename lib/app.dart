import 'package:clima_tempo/pages/home/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clima Tempo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}
