import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_timer_app/providers/user_provider.dart';
import 'package:tree_timer_app/screens/login.dart';
import 'package:tree_timer_app/screens/register.dart';
import 'package:tree_timer_app/screens/home.dart';
import 'package:tree_timer_app/route_generator.dart';

import 'features/auth_service.dart';

void main() {
  runApp(

    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
        ],
      child: const TreeTimerApp(),
    ),


  );
}

class TreeTimerApp extends StatefulWidget {
  const TreeTimerApp({super.key});

  @override
  State<TreeTimerApp> createState() => _TreeTimerApp();
}

class _TreeTimerApp extends State<TreeTimerApp> {
  // This widget is the root of your application.
  final AuthService authService = AuthService();

  @override
  void initState () {
    super.initState();
    authService.getUserData(context);
  }

  _asyncMethod() async{
    SharedPreferences s = await SharedPreferences.getInstance();
    String? token = s.getString('auth-token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree Timer App',
      initialRoute: "/",
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      home: (Provider.of<UserProvider>(context, listen: false).user.token.isNotEmpty)
          ? const Home(title: 'Bienvenido',)
          : const Home(title: 'Bienvenido',),
          // : const Login(),
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
