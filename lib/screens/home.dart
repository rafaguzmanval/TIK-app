import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  const Home({super.key, required this.title});
  static const String route = '/home';

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Container(
        margin: EdgeInsets.all(70),
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
                        child: Icon(Icons.create),
                      ),
                      //SizedBox(width: 15,),
                      new Expanded(
                          flex: 7,
                          child: Text("Nuevo proyecto")
                      )
                    ],
                  )
              ),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        flex: 3,
                        child: Icon(Icons.folder),
                      ),
                      //SizedBox(width: 15,),
                      new Expanded(
                          flex: 7,
                          child: Text("Abrir proyecto")
                      )
                    ],
                  )
              ),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        flex: 3,
                        child: Icon(Icons.share),
                      ),
                      //SizedBox(width: 15,),
                      new Expanded(
                          flex: 7,
                          child: Text("Compartir proyecto")
                      )
                    ],
                  )
              ),
              SizedBox(height: 40),
              ElevatedButton(
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        flex: 3,
                        child: Icon(Icons.book),
                      ),
                      //SizedBox(width: 15,),
                      new Expanded(
                          flex: 7,
                          child: Text("Abrir manual")
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

