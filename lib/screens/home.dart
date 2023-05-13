import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_timer_app/common/widgets/custom_alertdialogtreespecies.dart';
import 'package:tree_timer_app/common/widgets/register_form.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:tree_timer_app/models/user.dart';
import 'package:tree_timer_app/screens/project.dart';
import 'package:tree_timer_app/screens/tree_species.dart';
import '../common/widgets/custom_newprojectalertdialog.dart';

import '../common/widgets/custom_openprojectalertdialog.dart';
import '../features/auth_service.dart';
import '../features/tree_specie_service.dart';
import '../providers/user_provider.dart';


class Home extends StatefulWidget{
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home>{

  //Logged user variable
  late User loggedUser;

  // Create key to interact with drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthService authService = AuthService();
  final TreeSpecieService treeSpecieService = TreeSpecieService();

  void setLoggedUser(){
    loggedUser = Provider.of<UserProvider>(context, listen: false).user;
  }

  void openProjectDialog(bool isExport) async
  {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return OpenProjectCustomAlertDialog(title: isExport ? "Seleccione el proyecto a exportar" : "Seleccione el proyecto", isExport: isExport,);
      },
    );
  }

  @override
  void initState () {
    super.initState();
    // Get user data to show name and get his user_id to create projects and datasheets in future
    authService.getUserData(context);
    // Set logged user variable
    setLoggedUser();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key:_scaffoldKey,
      resizeToAvoidBottomInset: false,
      // Create a drawer to show user log out and other options
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
                child: Row(
                  children: [
                    Text('¡Bienvenid@ ${loggedUser.name}!'),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 100), (){
                          showGeneralDialog(context: context,
                            barrierDismissible: true,
                            barrierLabel: "",
                            pageBuilder: (context, _, __) => Center(
                              child: RegisterForm(
                                editingProfile: true,
                                userLogged: loggedUser,
                                onDispose: (validResponse){
                                  // If edit profile is successful, then update users info
                                  if(validResponse.isSuccess)
                                  {
                                    setState(() {
                                      setLoggedUser();
                                    });
                                  }
                                },
                              ),
                            )
                          );
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.person, color: Color.fromARGB(255, 61, 57, 57),),
                          SizedBox(width: 5),
                          Text("Editar perfil"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlertDialogTreeSpecies();
                    }
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                      flex: 3,
                      child: Icon(Icons.book),
                    ),
                    Expanded(
                        flex: 7,
                        child: Text("Especies de arboles disponibles")
                    )
                  ],
                )
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => authService.logoutUser(context),
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
      // App bar to show drawer icon and screen title
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Text(widget.title),
      ),
      
      body: Container(
        margin: const EdgeInsets.fromLTRB(70, 10, 70, 70),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/app_logo.svg',
                semanticsLabel: 'Tree Inspection Kit logo'
              ),
              ElevatedButton(
                  onPressed: () async {
                    // Show dialog to create new Project
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewProjectCustomAlertDialog(title: 'Crear nuevo proyecto');
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        flex: 3,
                        child: Icon(Icons.add),
                      ),
                      Expanded(
                          flex: 7,
                          child: Text("Nuevo proyecto")
                      )
                    ],
                  )
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    openProjectDialog(false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        flex: 3,
                        child: Icon(Icons.folder),
                      ),
                      Expanded(
                          flex: 7,
                          child: Text("Abrir proyecto")
                      )
                    ],
                  )
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                   onPressed: () async {
                    openProjectDialog(true);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        flex: 3,
                        child: Icon(Icons.share),
                      ),
                      Expanded(
                          flex: 7,
                          child: Text("Compartir proyecto")
                      )
                    ],
                  )
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        flex: 3,
                        child: Icon(Icons.book),
                      ),
                      Expanded(
                          flex: 7,
                          child: Text("Abrir manual")
                      )
                    ],
                  )
              ),
              const SizedBox(height: 40),
              
            ],
          ),
        ),
      ),
    );
  }

}

