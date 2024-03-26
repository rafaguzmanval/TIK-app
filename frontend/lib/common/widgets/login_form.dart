import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_inspection_kit_app/common/widgets/check_animation.dart';
import 'package:tree_inspection_kit_app/common/widgets/confetti_animation.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_button.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_passwordformfield.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_positioned_login_animations.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_textformfield.dart';
import 'package:tree_inspection_kit_app/features/auth_service.dart';
import 'package:tree_inspection_kit_app/models/user.dart';
import 'package:tree_inspection_kit_app/models/valid_response.dart';
import 'package:tree_inspection_kit_app/providers/user_provider.dart';
import 'package:tree_inspection_kit_app/screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginForm extends StatefulWidget{

  final AuthService authService;
  final ValueChanged<bool>? onVisibilityPressed;

  LoginForm({
    Key? key, this.onVisibilityPressed, required this.authService,
  }) : super(key:key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm>{

  // Global keys: form and animations
  final _loginFormKey = GlobalKey<FormState>();
  final _CheckAnimationKey = GlobalKey<CheckAnimationState>();
  final _ConfettiAnimationKey = GlobalKey<ConfettiAnimationState>();

  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isShowLoading =  false;
  bool isShowConfetti =  false;

  late SMITrigger confetti;

  _LoginFormState();

  void checkLoginUser() async{
    ValidResponse? result = await widget.authService.loginUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text
    );
    // If successful login then successful animation
    if(result?.isSuccess == true){
      // Trigger check animation
      _CheckAnimationKey.currentState?.triggerCheckFire();
      Future.delayed(Duration(seconds: 2), () async {
          
        setState(() {
          isShowLoading = false;
          isShowConfetti = true;
        });

        // Trigger confetti animation
        _ConfettiAnimationKey.currentState?.triggerConfettiFire();
        Future.delayed(Duration(seconds: 1), () async {

          // Call user provider
          Map<String, dynamic> infoRes = json.decode(result!.response.body);
          print(result!.response.body);
          //String name = infoRes['name'];
          //print(infoRes);
          
          //SharedPreferences preferences = await SharedPreferences.getInstance();
          //await preferences.setString('auth-token', infoRes["token"]);
          //Provider.of<UserProvider>(context, listen: false).setUser(infoRes);

          // Navigate to home

          User user = User(id: "1", name: "p", email: "email", password: "p", confirmpassword: "p", token: "token");

          await Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => Home())
          );

        });
      });
    }else{ // Error animation
      _CheckAnimationKey.currentState?.triggerErrorFire();
      Future.delayed(Duration(seconds: 2), () async {
          setState(() {
            isShowLoading = false;
            isShowConfetti = false;
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
              CustomPasswordFormField(
                controller: _passwordController,
                onVisibilityPressed: (isPasswordVisible) {
                  widget.onVisibilityPressed!(isPasswordVisible);
                },
                editing: false,
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
                          isShowConfetti = true;
                        });

                        checkLoginUser();
                     
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        // Check/Error animation
        // Hide if its loading
        isShowLoading ? CustomPositionedLoginAnimation(
          child: CheckAnimation(keyChild: _CheckAnimationKey,)
        ) : const SizedBox(),
        // Confetti animation
        isShowConfetti ? CustomPositionedLoginAnimation(
          child: Transform.scale(scale: 3,child: ConfettiAnimation(keyChild: _ConfettiAnimationKey)),
        ) : const SizedBox(),
      ],
    );
  }

}