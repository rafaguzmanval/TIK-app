import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_timer_app/common/widgets/custom_alertdialogtreespecies.dart';
import 'package:tree_timer_app/screens/tree_species.dart';
import '../common/widgets/custom_newprojectalertdialog.dart';

import '../common/widgets/custom_openprojectalertdialog.dart';
import '../features/auth_service.dart';
import '../features/tree_specie_service.dart';
import '../providers/user_provider.dart';


class Home extends StatefulWidget{
  const Home({super.key, required this.title});
  static const String route = '/home';

  final String title;

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home>{

  // Create key to interact with drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthService authService = AuthService();
  final TreeSpecieService treeSpecieService = TreeSpecieService();

  void userLogOut(){
    authService.logoutUser(context);
  }

  @override
  Widget build(BuildContext context) {

    String userName = Provider.of<UserProvider>(context, listen: false).user.name;

    return Scaffold(
      key:_scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 125,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                child: Text('¡Bienvenido $userName!'),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: GestureDetector(
                onTap: () => userLogOut(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.logout_rounded, color: Colors.red,),
                    SizedBox(width: 5),
                    Text("Cerrar sesión"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Text(widget.title),
      ),
      
      body: Container(
        margin: const EdgeInsets.all(70),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    String? name = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewProjectCustomAlertDialog(title: 'Crear nuevo proyecto');
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        flex: 3,
                        child: const Icon(Icons.create),
                      ),
                      //SizedBox(width: 15,),
                      new Expanded(
                          flex: 7,
                          child: const Text("Nuevo proyecto")
                      )
                    ],
                  )
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    String? name = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return OpenProjectCustomAlertDialog();
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        flex: 3,
                        child: const Icon(Icons.folder),
                      ),
                      //SizedBox(width: 15,),
                      new Expanded(
                          flex: 7,
                          child: const Text("Abrir proyecto")
                      )
                    ],
                  )
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        flex: 3,
                        child: const Icon(Icons.share),
                      ),
                      //SizedBox(width: 15,),
                      new Expanded(
                          flex: 7,
                          child: const Text("Compartir proyecto")
                      )
                    ],
                  )
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        flex: 3,
                        child: const Icon(Icons.book),
                      ),
                      //SizedBox(width: 15,),
                      new Expanded(
                          flex: 7,
                          child: const Text("Abrir manual")
                      )
                    ],
                  )
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlertDialogTreeSpecies();
                    }
                  );
                  // Navigator.push(
                  //   context, 
                  //   MaterialPageRoute(builder: (context) => TreeSpecies())
                  // );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Expanded(
                      flex: 3,
                      child: const Icon(Icons.book),
                    ),
                    //SizedBox(width: 15,),
                    new Expanded(
                        flex: 7,
                        child: const Text("Obtener especies de arboles")
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

}

