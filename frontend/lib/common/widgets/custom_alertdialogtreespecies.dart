import 'package:flutter/material.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_arrow_downward_list_scroll.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_arrow_upward_list_scroll.dart';
import 'package:tree_inspection_kit_app/constants/utils.dart';
import 'package:tree_inspection_kit_app/features/tree_specie_service.dart';
import 'package:tree_inspection_kit_app/models/tree_specie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAlertDialogTreeSpecies extends StatefulWidget {
  late String title;
  

  CustomAlertDialogTreeSpecies({super.key});
  
  @override
  State<CustomAlertDialogTreeSpecies> createState() => _CustomAlertDialogTreeSpecies();


}

class _CustomAlertDialogTreeSpecies extends State<CustomAlertDialogTreeSpecies>
{
  TreeSpecieService treeSpecieService = new TreeSpecieService();
  TextEditingController searchController = new TextEditingController();
  List<dynamic> filteredSpecies = new List.empty();
  List<dynamic> origSpeciesList = new List.empty();
  final ScrollController scrollController = ScrollController();
  bool arrowDownWard = true;
  final arrowDownWardNotifier = ValueNotifier<bool>(true);

  // Add list height variable
  double listHeight = 400;

  @override
  void initState(){
    // Add scroll listener
    scrollController.addListener(() {
      ScrollControllerUtils.scrollListener(scrollController, arrowDownWardNotifier);
    });
  }

  // Init the app name in screens title
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    widget.title = AppLocalizations.of(context)!.treeSpecies;
  }

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text(widget.title),
      content: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0, 
          ),
          borderRadius: BorderRadius.circular(5.0), 
        ),
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                future: treeSpecieService.getSpecies(),
                builder: (context, snapshot) {
                  // If we have data from tree species
                  if(snapshot.hasData)
                  {
                    origSpeciesList = snapshot.data;
                    if(filteredSpecies.isEmpty == true)
                    {
                      filteredSpecies = snapshot.data;
                    }
                    return Column(
                      children: [
                        TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.search,
                          ),
                          // When user tap, adjust size of species list
                          onTap: (){
                            setState(() {
                              listHeight = 150;
                            });
                          },
                          // Filter tree species while introducing letters
                          onChanged: (value) {
                            // Using lowercase to find if contained word exists regardless if its cap o lower
                            filteredSpecies = origSpeciesList.where((element) => element["spanishName"].toString().toLowerCase().contains(value.toLowerCase())).toList();
                            // Refresh list with setState()
                            this.setState(() {});
                          },
                        ),
                        Container(
                          // We must to set height and width in order to prevent errors
                          // with listView dimensions
                          width: 400,
                          height: listHeight,
                          // height: MediaQuery.of(context).viewInsets.top,
                          child: RefreshIndicator(
                            onRefresh: ()async{},
                            child: ListView.builder(
                              padding: MediaQuery.of(context).viewInsets,
                              itemCount: filteredSpecies.length,
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.book, color: Colors.green,),
                                  title: Text(filteredSpecies[index]["spanishName"]),
                                  //subtitle: Text("${AppLocalizations.of(context)!.propagationVelocity}: " + filteredSpecies[index]["description"]),
                                  onTap: (){
                                    TreeSpecie treeSpecie = TreeSpecie(
                                      name: filteredSpecies[index]["spanishName"],
                                      id: filteredSpecies[index]["id"].toString(),
                                      description: filteredSpecies[index]["scientificName"] ?? ''
                                    );
                                    
                                    Navigator.pop(context, treeSpecie);
                                  }
                                );
                              },
                            ),
                          ),
                        ),
                        // Show scroll arrow if number of elements > 8
                        snapshot.data.length > 8
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
                    showFlutterToast(msg: snapshot.error.toString(), isSuccess: false);
                  }
                  return CircularProgressIndicator();
                }
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.exit)
        )
      ],
    );
  }
}

