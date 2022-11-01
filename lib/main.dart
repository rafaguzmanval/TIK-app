import 'package:flutter/material.dart';
import 'package:tree_timer_app/screens/login.dart';
import 'package:tree_timer_app/screens/register.dart';
import 'package:tree_timer_app/screens/home.dart';
import 'package:tree_timer_app/route_generator.dart';

void main() {
  runApp(const TreeTimerApp());
}

class TreeTimerApp extends StatelessWidget {
  const TreeTimerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree Timer App',
      initialRoute: "/",
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      /*routes: {
        "/": (context) => const Login(title: 'Login'),
        "/register": (context) => const Register(title: 'Registro'),
        "/home": (context) => const Home(title: 'Tree Timer App'),
      },*/
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Cuando usamos initialRoutes NO se define home: es incompatible
      //home: const Login(title: 'Tree Timer App - Login'),
    );
  }
}


