import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/widgets/bluetooth_simpledialog.dart';
import '../features/auth_service.dart';
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

  void userLogOut(){
    authService.logoutUser(context);
  }

  Future<void> _showBluetoothDialog(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return BluetoothSimpleDialog();
      },
    );
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
                onTap: () => _showBluetoothDialog(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(width: 5),
                    Text("Buscar dispositivos Bluetooth"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
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
                  onPressed: (){},
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
                  onPressed: (){},
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

            ],
          ),
        ),
      ),
    );
  }

}

