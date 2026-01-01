import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maymysound/dashboard/sample/view/sampleApiViewObject.dart';
import 'package:maymysound/utils/appStrings.dart';
import 'package:maymysound/utils/appTestStyle.dart';
import 'package:provider/provider.dart';

import '../../../utils/appColors.dart';
import '../../../utils/constant.dart';
import '../model/sampleApiModel.dart';
import '../viewModel/sampleApiViewModel.dart';

class SampleApiView extends StatelessWidget {
  const SampleApiView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        final vm = SampleApiViewModel();
        //vm.getSampleApiData();
        return vm;
      },
      child: Consumer<SampleApiViewModel>(
        builder: (context, viewmodel, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                AppString.sampleMVVMApi,
                style: AppTextStyles.semibold18,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    viewmodel.uploadImage();
                  },
                  child: Text("Multi"),
                ),
              ],
            ),
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child:buildBody(viewmodel),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget buildBody(SampleApiViewModel vm) {
    if (!vm.hasInternet) {
      return const Center(child: Text("No Internet Connection"));
    }

    if (vm.loader) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.list.isEmpty) {
      return Text(
        "No Data Available",
        style: AppTextStyles.light14,
      );
    }

    return contentView(vm.list, vm);
  }

  Widget contentView(List<ModelSampleApi> data, SampleApiViewModel vm) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Padding(padding: EdgeInsets.symmetric(vertical: 10));
      },
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        var itemData = data[index];
        print("LENGHT :${data.length}");
        return ListTile(
          tileColor: Colors.red.withOpacity(0.2),
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SampleApiViewObject(name: itemData.name.toString()),
                ),
              );
            },

            child: Text(
              "Name ${itemData.name.toString()}",
              style: AppTextStyles.light14,
            ),
          ),
          subtitle: Text(itemData.ceoName.toString()),
          leading: InkWell(
            onTap: () {
              vm.startRecording();
            },

            child: SvgPicture.asset("assets/images/dummy.svg"),
          ),
          trailing: Text(itemData.employeeCount.toString()),
        );
      },
    );
  }
}
