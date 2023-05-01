import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_timer_app/common/widgets/custom_arrow_downward_list_scroll.dart';
import 'package:tree_timer_app/common/widgets/custom_arrow_upward_list_scroll.dart';
import 'package:tree_timer_app/features/project_service.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:tree_timer_app/providers/user_provider.dart';
  import 'package:tree_timer_app/screens/project.dart';
import '../../constants/utils.dart';

class OpenProjectCustomAlertDialog extends StatefulWidget
{
  final String title = "Seleccione el proyecto";

  OpenProjectCustomAlertDialog({
    Key? key,
  }) : super(key:key);

  @override
  State<OpenProjectCustomAlertDialog> createState() => _OpenProjectCustomAlertDialog();
}

class _OpenProjectCustomAlertDialog extends State<OpenProjectCustomAlertDialog> {
  
  final ProjectService projectService = ProjectService();
  final ScrollController scrollController = ScrollController();
  bool arrowDownWard = true;
  final arrowDownWardNotifier = ValueNotifier<bool>(true);

  @override
  void initState(){
    scrollController.addListener((){
      ScrollControllerUtils.scrollListener(scrollController, arrowDownWardNotifier);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.title),
      content:  Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0, // Ancho del borde personalizado
          ),
          borderRadius: BorderRadius.circular(5.0), // Borde redondeado personalizado
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: projectService.getProjects(Provider.of<UserProvider>(context, listen: false).user.id),
                    builder: (context, snapshot) {
                      if(snapshot.hasData)
                      {
                        return Column(
                          children: [
                            Container(
                              // We must to set height and width in order to prevent errors
                              // with listView dimensions
                              width: 400,
                              height: 450,
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.book, color: Colors.green,),
                                    title: Text(snapshot.data[index]["name"]),
                                    onTap: () async {
                                      Project project = Project(
                                          id: snapshot.data[index]["_id"],
                                          name: snapshot.data[index]["name"],
                                          description: snapshot.data[index]["description"] ?? '',
                                          user_id:  Provider.of<UserProvider>(context, listen: false).user.id,
                                      );
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(              
                                            builder: (context) => ProjectScreen(project: project),
                                          ),
                                      );
                                      // Rebuild widget
                                      setState(() {});
                                    },
                                  );
                                },
                              ), 
                            ),
                            // Show scroll arrow if number of elements > 8
                            snapshot.data.length > 5
                            ? ValueListenableBuilder<bool>(
                              valueListenable: arrowDownWardNotifier,
                              builder: (context, arrowDownWard, child) {
                                return arrowDownWard 
                                  ? ArrowDownWardListScroll(scrollController: scrollController) 
                                  : ArrowUpWardListScroll(scrollController: scrollController);
                              },
                            )
                            : SizedBox(),
                          ]
                        );
                      }
                      else if(snapshot.hasError){
                        showSnackBar(context, snapshot.error.toString());
                      }
                      return CircularProgressIndicator();
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("Salir")
        )
      ],
    );
  }
}

