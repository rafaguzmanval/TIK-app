import 'package:flutter/material.dart';
import 'package:tree_inspection_kit_app/screens/home.dart';
import 'package:tree_inspection_kit_app/screens/login.dart';
import 'package:tree_inspection_kit_app/screens/register.dart';

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings){
//     final args = settings.arguments;

//     switch(settings.name) {
//       case Login.route:
//         return MaterialPageRoute(builder: (context) => Login());
//       case Home.route:
//         return MaterialPageRoute(builder: (context) => Home(title: 'Tree Timer App'));
//       case Register.route:
//         return MaterialPageRoute(builder: (context) => Register(title: 'Registro'));
//       default:
//         return _errorRoute();
//     }
//   }

//   static Route<dynamic> _errorRoute(){
//     return MaterialPageRoute(builder: (context)
//         {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Error'),
//               centerTitle: true,
//             ),
//             body: Center(
//               child: Text("¡Página no encontrada!"),
//             ),
//           );
//         }
//     );
//   }
// }