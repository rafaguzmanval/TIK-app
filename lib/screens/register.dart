import 'package:flutter/material.dart';

class Register extends StatefulWidget{
  const Register({super.key, required this.title});

  final String title;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
{
  TextEditingController email = new TextEditingController();
  TextEditingController confirmEmail = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();

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
                controller: confirmEmail,
                decoration: InputDecoration(
                  hintText: "Confirmar email"
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Contraseña"
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: confirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Confirmar contraseña"
                ),
              ),
              SizedBox(height: 35),
              Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    child: const Text("Crear cuenta", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    onPressed: (){},
                  )
              ),
            ],
          )
        )
      ),
    );
  }

}