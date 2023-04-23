import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:tree_timer_app/providers/user_provider.dart';
import 'package:tree_timer_app/screens/login.dart';
import 'package:tree_timer_app/screens/home.dart';
import 'package:tree_timer_app/route_generator.dart';

// import 'features/auth_service.dart';

void main() {
  runApp(
    // Add user provider to App
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
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
  
  // _asyncMethod() async{
  //   SharedPreferences s = await SharedPreferences.getInstance();
  //   String? token = s.getString('auth-token');
  //   return token;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree Timer App',
      initialRoute: "/",
      // onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      home: (Provider.of<UserProvider>(context, listen: false).user.token.isNotEmpty)
          ? const Home(title: 'Bienvenido',)
          : const Login(),
         
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      
    );
  }
}
