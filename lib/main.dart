import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_inspection_kit_app/models/project.dart';
import 'package:tree_inspection_kit_app/providers/language_provider.dart';
import 'package:tree_inspection_kit_app/providers/user_provider.dart';
import 'package:tree_inspection_kit_app/screens/login.dart';
import 'package:tree_inspection_kit_app/screens/home.dart';
import 'package:tree_inspection_kit_app/route_generator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'features/auth_service.dart';

void main() {
  runApp(
    // Add user provider and language provider to App 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: TreeTimerApp(),
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
    // Establish language provider in order to allow change languages in the App
    return ChangeNotifierProvider<LanguageProvider>(
      create: (context) => LanguageProvider(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Tree Inspection Kit App',
            locale: Provider.of<LanguageProvider>(context, listen: true).currentLocale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('es'), // Spanish
              Locale('en'), // English
            ],
            initialRoute: "/",
            // onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
            home: (Provider.of<UserProvider>(context, listen: false).user.token.isNotEmpty)
                ? const Home()
                : const Login(),
               
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            
          );
        }
      ),
    );
  }
}
