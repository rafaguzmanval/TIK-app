import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: "Email"
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Contraseña"
                )
              ),
              SizedBox(height: 35),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  child: const Text("Login", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  onPressed: (){
                    Navigator.pushNamed(context, "/home");
                  },
                )
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
      ),
    );
  }
}