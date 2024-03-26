import 'package:flutter/material.dart';
import 'package:tree_inspection_kit_app/common/widgets/login_form.dart';
import 'package:tree_inspection_kit_app/common/widgets/register_form.dart';
import 'package:tree_inspection_kit_app/constants/utils.dart';
import 'package:tree_inspection_kit_app/features/auth_service.dart';
import 'package:rive/rive.dart';
import 'package:tree_inspection_kit_app/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String title = "Login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Create services variables
  final AuthService authService = AuthService();
  final _loginFormKey = GlobalKey<FormState>();

  // Create controllers variables
  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create animations variable
  late RiveAnimationController _controller;
  SMIInput<bool>? _hidePassword;


  void _onRiveInit(Artboard artboard) {
  // Create a StateMachineController from the provided artboard and state machine name
  final controller = StateMachineController.fromArtboard(artboard, 'StateMachine');

  // Add the controller to the artboard so it can start managing animations
  artboard.addController(controller!);

  // Find the SMIBool input with the name 'pressed' in the state machine and store it 
  _hidePassword = controller.findInput<bool>('pressed') as SMIBool;
}

  void _hitHidePassword(bool hideText) {
    if(hideText == false)
    {
      _hidePassword?.change(false);
    }
    else{
      _hidePassword?.change(true);
    }
  } 

  @override
  void initState() {
    super.initState();
    // Establish idle animation in init state
    _controller = SimpleAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(Login.title),
      ),
      body: SafeArea(child: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    // Create widget animation for user login
                    child: RiveAnimation.asset("assets/rive/tree_v3.riv", fit: BoxFit.cover, controllers: [_controller], onInit: _onRiveInit))
                ],
              ),
              // Login form with callback function in order to change boolean value
              LoginForm(authService: authService, onVisibilityPressed: (value) => {
                _hitHidePassword(value)
              }, ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Register form which returns response message
                children: [
                  Text(AppLocalizations.of(context)!.newUser),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        Future.delayed(Duration(milliseconds: 100), (){
                          showGeneralDialog(context: context,
                            barrierDismissible: true,
                            barrierLabel: "",
                            pageBuilder: (context, _, __) => Center(
                              child: RegisterForm(
                                onDispose: (result){
                                  result.responseMsg;
                                },
                                editingProfile: false,
                              ),
                            )
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.lightGreen
                      ),
                      child: Text(AppLocalizations.of(context)!.createAccount),
                    )
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
      )
    );
  }
}