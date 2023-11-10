import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tree_inspection_kit_app/common/widgets/check_animation.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_button.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_passwordformfield.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_textformfield.dart';
import 'package:tree_inspection_kit_app/constants/utils.dart';
import 'package:tree_inspection_kit_app/features/auth_service.dart';
import 'package:tree_inspection_kit_app/models/user.dart';
import 'package:tree_inspection_kit_app/models/valid_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterForm extends StatefulWidget{

  final AuthService authService =  AuthService();
  final ValueChanged<ValidResponse>? onDispose;
  final bool editingProfile;
  final User? userLogged;
  
  RegisterForm({
    Key? key,
    this.onDispose, required this.editingProfile, this.userLogged,
  }) : super(key:key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>{
  
  // Use for fields validators
  final _registrationFormKey = GlobalKey<FormState>();

  // Check animation global key
  final _CheckAnimationKey = GlobalKey<CheckAnimationState>();

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  bool isShowLoading =  false;

  // If user is editing profile, we must to initialize username and user email
  @override
  void initState(){

    if(widget.userLogged != null)
    {

      if(widget.userLogged!.name != '')
      {
        _nameController.text = widget.userLogged!.name;
      }

      if(widget.userLogged!.email != '')
      {
        _emailController.text = widget.userLogged!.email;
      }
    }
  }

  void handleRequest(Response _res){
    // If resquest is not null then show animation
    if(_res != null){
      showAnimation(_res);
    }
  }


  void showAnimation(Response response){

    ValidResponse validResponse = ValidResponse(response);

    // Trigger animation
    if(validResponse.isSuccess)
    {
      _CheckAnimationKey.currentState?.triggerCheckFire();
    }
    else{
      _CheckAnimationKey.currentState?.triggerErrorFire();
    }
    Future.delayed(Duration(seconds: 2), () async {
      if(mounted)
      {
        setState(() {
          isShowLoading = false;
        });
        showFlutterToastFromResponse(res: response);
      }  
      setState(() {
        isShowLoading = false;
      });
      if(validResponse.isSuccess)
      {
        Navigator.pop(context);
      }
    });
  }  

  void RegisterUser() async{
    Response? res = await widget.authService.registerUser(context: context,name: _nameController.text,
    email: _emailController.text,password: _passwordController.text, confirmpassword: _confirmPasswordController.text);
    handleRequest(res!);
  }

  void EditUserProfile() async{
    User userEdited = User(id: widget.userLogged!.id, name: _nameController.text, email: _emailController.text, password: getPasswordHash(_passwordController.text), confirmpassword: getPasswordHash(_confirmPasswordController.text), token: '');
    Response? res = await widget.authService.editUserProfile(context: context, user: userEdited);
    handleRequest(res!);
    // Update user provider
    widget.onDispose!(ValidResponse(res));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(60))),
        child: Container(
          width: 310,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _registrationFormKey,
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      Center(child: Text(widget.editingProfile ? AppLocalizations.of(context)!.profile : AppLocalizations.of(context)!.register, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      SizedBox(height: 15),
                      CustomTextField(controller: _nameController, labelText: AppLocalizations.of(context)!.name),
                      SizedBox(height: 15),
                      CustomTextField(controller: _emailController, labelText: "Email"),
                      SizedBox(height: 15),
                      CustomPasswordFormField(controller: _passwordController, editing: widget.editingProfile),
                      SizedBox(height: 15),
                      CustomPasswordFormField(controller: _confirmPasswordController, editing:  widget.editingProfile, isConfirmPassword: true,),
                      SizedBox(height: 35),
                      Container(
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        // ignore: prefer_const_constructors
                        child: CustomButton(
                          text: widget.editingProfile ? AppLocalizations.of(context)!.updateProfile : AppLocalizations.of(context)!.createAccount,
                          textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          onTap: (){
                            if(_registrationFormKey.currentState!.validate()) {
                              if((_passwordController.text == '' && _confirmPasswordController.text != '') || (_passwordController.text != '' && _confirmPasswordController.text == ''))
                              {
                                showFlutterToast(msg:  AppLocalizations.of(context)!.passwordDoesNotMatch, isSuccess: false);
                              }
                              else{
                                setState(() {
                                  isShowLoading = true;
                                });
                                // If we are not editing, then register user
                                if(!widget.editingProfile)
                                {
                                  RegisterUser();
                                }
                                else{ // Update user profile
                                  EditUserProfile();
                                }
                              }
                            } 
                          }
                        ),
                      ),
                    ],
                  )
                ),
              ),
              SizedBox(height: 15,),
              isShowLoading ? SizedBox(height: 125, width: 125, child: CheckAnimation(keyChild: _CheckAnimationKey,))
               : const SizedBox(),
              Container(
                height: 100,
                width: 100,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Center(
                      child: CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade100, child: Icon(Icons.close),)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
