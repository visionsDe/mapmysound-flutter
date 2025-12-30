import 'package:flutter/material.dart';
import 'package:maymysound/utils/appColors.dart';
import 'package:provider/provider.dart';

import '../model/sampleStaticModel.dart';
import '../viewModel/sampleApiViewModel.dart';

class SampleStaticView extends StatefulWidget {
   SampleStaticView({super.key});


  @override
  State<SampleStaticView> createState() => _SampleStaticViewState();
}

class _SampleStaticViewState extends State<SampleStaticView> {
  var model = SampleApiViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
        Provider.of<SampleApiViewModel>(context , listen: false).addStaticItem().then((onValue){
          print("onValue :${onValue}");
          setState(() {
            model.staticList;
            print("KKKK :${model.staticList.length}");

          });
          print("viewMODEL :${model.staticList}");
        });
      },
      label: Text("ADD ITEM"),

      ),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
            child: ChangeNotifierProvider(
              create: (BuildContext context) {
                final vm = SampleApiViewModel();
                vm.setStaticData();
                return vm;
              },
              child: Consumer<SampleApiViewModel>(
                builder: (context , viewmodel , child){

                  if(viewmodel.loader){
                    return Center(child: CircularProgressIndicator());
                  }
                  List<SampleStaticModel> data = viewmodel.staticListCopy;
                  if (data.isNotEmpty) {

                    print("DATA HH :${viewmodel.staticListCopy.length}");
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SearchBar(
                            hintText: "Search Text",
                            onChanged: (value){
                              print("DATA VALUE :${value}");
                              viewmodel.filterList(value);
                            },
                          ),
                        ),
                        Expanded(child: contentView(data , viewmodel)),
                      ],
                    );
                  }else{
                    return Text("No Data Available", style: TextStyle(fontSize: 12,color: AppColors.primary),);
                  }
                },
              ),
            ),
          ),
      ),
    );
  }

  Widget contentView(List<SampleStaticModel> data, SampleApiViewModel viewmodel) {
    return ListView.separated(
      separatorBuilder: (BuildContext context , int index){
        return Padding(padding: EdgeInsets.symmetric(vertical: 10));
      },
      itemCount: data.length,
      itemBuilder: (BuildContext context , int index){
        var itemData = data[index];
        print("SSSSS FFF :${data.length}");

        return InkWell(
          onLongPress: (){
            viewmodel.removeItemFromList(index: index);
            },
          child: ListTile(
            tileColor: Colors.red.withOpacity(0.2),
            title: Text(itemData.name.toString()),
            subtitle: Text(itemData.surname.toString()),
            leading: Text(itemData.id.toString()),
            trailing: Text(itemData.phoneNo.toString()),
          ),
        );
      },
    );
  }
}
