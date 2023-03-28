import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tree_timer_app/common/widgets/custom_button.dart';
import 'package:tree_timer_app/common/widgets/custom_passwordformfield.dart';
import 'package:tree_timer_app/common/widgets/custom_textformfield.dart';
import 'package:tree_timer_app/features/auth_service.dart';


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


  // void _hitHidePassword(bool hideText) {
  //   if(hideText == false)
  //   {
  //     onVisibilityPressed?(false);
  //   }
  //   else{
  //     onVisibilityPressed?.(true);
  //   }
  // } 

  void loginUser(){
    authService.loginUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                      onTap: (){
                        if(_loginFormKey.currentState!.validate()) {
                          loginUser();
                        }
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
            );
  }

}