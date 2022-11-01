import 'package:flutter/material.dart';
import 'package:tree_timer_app/screens/home.dart';
import 'package:tree_timer_app/screens/login.dart';
import 'package:tree_timer_app/screens/register.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Login(title: 'Login'));
      case '/home':
        return MaterialPageRoute(builder: (context) => Home(title: 'Tree Timer App'));
      case '/register':
        return MaterialPageRoute(builder: (context) => Register(title: 'Registro'));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (context)
        {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
              centerTitle: true,
            ),
            body: Center(
              child: Text("¡Página no encontrada!"),
            ),
          );
        }
    );
  }
}