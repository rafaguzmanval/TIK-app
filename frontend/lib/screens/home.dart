import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_alertdialogtreespecies.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_elevated_button.dart';
import 'package:tree_inspection_kit_app/common/widgets/register_form.dart';
import 'package:tree_inspection_kit_app/constants/utils.dart';
import 'package:tree_inspection_kit_app/models/user.dart';
import 'package:tree_inspection_kit_app/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printing/printing.dart';

import '../common/widgets/custom_newprojectalertdialog.dart';

import '../common/widgets/custom_openprojectalertdialog.dart';
import '../common/widgets/bluetooth_simpledialog.dart';
import '../features/auth_service.dart';
import '../features/tree_specie_service.dart';
import '../providers/user_provider.dart';



class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home>{

  //Logged user variable
  late User loggedUser;
  late String title;

  // Create key to interact with drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthService authService = AuthService();
  final TreeSpecieService treeSpecieService = TreeSpecieService();

  void setLoggedUser(){
    loggedUser = User(id: "1",name: "pepe",email: "email",password: "pass",confirmpassword: "pass",token: "");//Provider.of<UserProvider>(context, listen: false).user;
  }

  void openProjectDialog(bool isExport) async
  {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return OpenProjectCustomAlertDialog(
          title: isExport ? AppLocalizations.of(context)!.selectProjectToExport : AppLocalizations.of(context)!.selectProject, isExport: isExport,
        );
      },
    );
  }

  @override
  void initState () {
    super.initState();
    // Get user data to show name and get his user_id to create projects and datasheets in future
    //authService.getUserData(context);
    // Set logged user variable
    setLoggedUser();
  }

  // Init the app name in screens title
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    title = AppLocalizations.of(context)!.appName;
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

    return Scaffold(
      key:_scaffoldKey,
      resizeToAvoidBottomInset: false,
      // App bar to show drawer icon and screen title
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Text(title),
      ),
      // Create a drawer to show user log out and other options
      drawer: HomeDrawer(),
      body: HomeBody()
    );
  }



  Widget HomeDrawer(){
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 125,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Row(
                children: [
                  Text('${AppLocalizations.of(context)!.welcome} ${loggedUser.name}!'),
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
                      children: [
                        Icon(Icons.person, color: Color.fromARGB(255, 61, 57, 57),),
                        SizedBox(width: 5),
                        Text(AppLocalizations.of(context)!.editProfile),
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
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Icon(Icons.book),
                    ),
                    Expanded(
                        flex: 7,
                        child: Text(AppLocalizations.of(context)!.availableTreeSpecies)
                    )
                  ],
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ElevatedButton(
                onPressed: (){
                  _showBluetoothDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Icon(Icons.bluetooth),
                    ),
                    Expanded(
                        flex: 7,
                        child: Text(AppLocalizations.of(context)!.findBluetoothDevices)
                    )
                  ],
                )
            ),
          ),
          const SizedBox(height: 60),
          Center(
            child: GestureDetector(
              onTap: () => authService.logoutUser(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  const Icon(Icons.logout_rounded, color: Colors.red,),
                  const SizedBox(width: 5),
                  Text(AppLocalizations.of(context)!.logout),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListTile(
                  leading: Localizations.localeOf(context).languageCode == 'es' ? Image.asset('assets/languages/spanish.png', width: 25, height: 25,) : Image.asset('assets/languages/english.png', width: 30, height: 30,),
                  title: DropdownButton<String>(
                    value: getLanguageStr(context, Localizations.localeOf(context).languageCode),
                    onChanged: (String? newValue) {
                      setState(() {
                        String _value = getLanguageCode(context, newValue!) as String;
                        Provider.of<LanguageProvider>(context, listen: false).changeLanguage(Locale(_value, ''));
                      });
                    },
                    items: <String>[AppLocalizations.of(context)!.spanish, AppLocalizations.of(context)!.english]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget HomeBody(){
    return Container(
      margin: const EdgeInsets.fromLTRB(70, 10, 70, 70),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                'assets/app_logo.svg',
                semanticsLabel: 'Tree Inspection Kit logo'
            ),

            ///NEW PROJECT
            SizedBox(
              width: 300,
              child: CustomElevatedButton(
                title:AppLocalizations.of(context)!.newProject,
                onPressed: () async {
                  // Show dialog to create new Project
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NewProjectCustomAlertDialog(title: AppLocalizations.of(context)!.createNewProject);
                    },
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
            const SizedBox(height: 15),

            ///OPEN PROJECT
            SizedBox(
              width: 300,
              child: CustomElevatedButton(
                title: AppLocalizations.of(context)!.openProject,
                onPressed: () async
                {
                  openProjectDialog(false);
                },
                icon: const Icon(Icons.folder),
              ),
            ),
            const SizedBox(height: 15),

            ///SHARE PROJECT
            SizedBox(
              width: 300,
              child: CustomElevatedButton(
                title: AppLocalizations.of(context)!.shareProject,
                onPressed: () async
                {
                  openProjectDialog(true);
                },
                icon: const Icon(Icons.share),
              ),
            ),
            const SizedBox(height: 40),

            ///OPEN MANUAL
            SizedBox(
              width: 300,
              child: CustomElevatedButton(
                title: AppLocalizations.of(context)!.openManual,
                onPressed: () async
                {
                  // Load pdf bytes from asset (version depends on user selected language)
                  final pdfData = await loadPdfFromAsset(languageCode: Localizations.localeOf(context).languageCode);
                  // Using printing library, open pdf and visualize
                  Printing.layoutPdf(
                    onLayout: (format) => pdfData,
                  );
                },
                icon: const Icon(Icons.book),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

}

