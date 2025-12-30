import 'package:flutter/material.dart';
import 'package:maymysound/dashboard/sample/model/sampleApiModelObject.dart';
import 'package:maymysound/utils/constant.dart';
import 'package:provider/provider.dart';

import '../viewModel/sampleApiViewModel.dart';

class SampleApiViewObject extends StatelessWidget {
  final name;
  const SampleApiViewObject({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (BuildContext context) {
            final vm = SampleApiViewModel();
            vm.getSampleApiObject(id: "2");
            return vm;
          },
          child: Consumer<SampleApiViewModel>(
            builder: (context, viewmodel, child) {
              // Provider.of<SampleApiViewModel>(
              //   context,
              //   listen: false,
              // ).getSampleApiObject();

              if (viewmodel.loader) {
                return Center(child: CircularProgressIndicator());
              }

              SampleApiObject? data = viewmodel.info;
              if (data == null) {
                return Text("No Data Available");
              } else {
                return Column(
                  children: [
                    Constant.sampleApiListTile(name: data.name, country: data.country, id: data.id, employeeCount: data.employeeCount)
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
