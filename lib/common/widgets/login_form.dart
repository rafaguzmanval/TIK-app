import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_timer_app/common/widgets/custom_button.dart';
import 'package:tree_timer_app/common/widgets/custom_passwordformfield.dart';
import 'package:tree_timer_app/common/widgets/custom_textformfield.dart';
import 'package:tree_timer_app/features/auth_service.dart';
import 'package:tree_timer_app/models/valid_response.dart';
import 'package:tree_timer_app/providers/user_provider.dart';
import 'package:tree_timer_app/screens/home.dart';


class LoginForm extends StatefulWidget{

  final ValueChanged<bool>? onVisibilityPressed;

  LoginForm({
    Key? key,
    required this.onVisibilityPressed,
  }) : super(key:key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm>{

  final _loginFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isShowLoading =  false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  StateMachineController getRiveController(Artboard artboard){
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void checkLoginUser() async{
    ValidResponse result = await authService.loginUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text
    );
    // If successful login then successful animation
    if(result.isSuccess == true){
      check.fire();
      Future.delayed(Duration(seconds: 2), () async {
        setState(() {
            isShowLoading = false;
          });
          // Call user provider
          Map<String, dynamic> infoRes = json.decode(result.body);
          String name = infoRes['name'];
          
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString('auth-token', infoRes["token"]);
          Provider.of<UserProvider>(context, listen: false).setUser(infoRes);
          // Navigate to home
          Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => Home(title: 'Tree Timer App')),
                (route) => false
          );
        }
      );
    }else{ // Error animation
      error.fire();
      Future.delayed(Duration(seconds: 2), () async {
          setState(() {
            isShowLoading = false;
          });
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(controller: _emailController, labelText: "Email"),
              SizedBox(height: 15),
              // CustomTextField(controller: _passwordController, hintText: "Contraseña", isPassword: true,),
              CustomPasswordFormField(
                controller: _passwordController,
                onVisibilityPressed: (isPasswordVisible) {
                  widget.onVisibilityPressed!(isPasswordVisible);
                },
              ),
              SizedBox(height: 35),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomButton(
                  text: "Login",
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  onTap: () async {
                    // Show loading animation
                    Future.delayed(Duration(seconds: 1), () async {

                      if(_loginFormKey.currentState!.validate()) {
                        // Check animation
                        setState(() {
                          isShowLoading = true;
                        });

                        checkLoginUser();
                     
                      }
                    });
                    
                  },
                ),
              ),
              SizedBox(height: 35),
              GestureDetector(
                onTap:(){
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text("¿Nuevo usuario? Cree una cuenta")
              ),
            ],
          ),
        ),
        // Check Check/Error animation
        // Hide if its loading
        isShowLoading ? Positioned.fill(
          child: Column(
            children: [
              SizedBox(
                height: 125,
                width: 125,
                child: RiveAnimation.asset(
                  "assets/rive/checkerror.riv",
                  onInit: (artboard){
                    StateMachineController controller = getRiveController(artboard);
                    check = controller.findSMI("Check") as SMITrigger;
                    error = controller.findSMI("Error") as SMITrigger;
                    reset = controller.findSMI("Reset") as SMITrigger;
                  }
                ),
              ),
            ],
          ),
        ) : SizedBox(),
      ],
    );
  }

}