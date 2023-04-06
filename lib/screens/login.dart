import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tree_timer_app/common/widgets/custom_button.dart';
import 'package:tree_timer_app/common/widgets/custom_textformfield.dart';
import 'package:tree_timer_app/common/widgets/login_form.dart';
import 'package:tree_timer_app/common/widgets/register_form.dart';
import 'package:tree_timer_app/features/auth_service.dart';
import 'package:tree_timer_app/providers/user_provider.dart';
import 'package:tree_timer_app/common/widgets/custom_passwordformfield.dart';
import 'package:rive/rive.dart';


class Login extends StatefulWidget {
  const Login({super.key});
  static const String route = '/';
  static const String title = "Login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService authService = AuthService();
  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late RiveAnimationController _controller;
  SMIInput<bool>? _hidePassword;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'StateMachine');
    artboard.addController(controller!);
    _hidePassword = controller.findInput<bool>('pressed') as SMIBool ;
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

  void loginUser(){
    authService.loginUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text
    );
  }


  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Login.title),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: RiveAnimation.asset("assets/rive/tree_v3.riv", fit: BoxFit.cover, controllers: [_controller], onInit: _onRiveInit))
                ],
              ),
              LoginForm(onVisibilityPressed: (value) => {
                _hitHidePassword(value)
              }, ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿Nuevo usuario?"),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        Future.delayed(Duration(milliseconds: 100), (){
                          // Navigator.pushNamed(context, '/register');
                          showGeneralDialog(context: context,
                            barrierDismissible: true,
                            barrierLabel: "",
                            pageBuilder: (context, _, __) => Center(
                              child: RegisterForm(authService: authService,),
                            )
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.lightGreen
                      ),
                      child: const Text("Cree una cuenta"),
                    )
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}