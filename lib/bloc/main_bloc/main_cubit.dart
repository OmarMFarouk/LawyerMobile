import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lawyermobile/bloc/main_bloc/main_states.dart';
import 'package:lawyermobile/models/case_model.dart';
import 'package:lawyermobile/service/api/case_api.dart';

import '../../src/app_shared.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitial());
  static MainCubit get(context) => BlocProvider.of(context);
  TextEditingController uniqueCont = TextEditingController();
  final formKey = GlobalKey<FormState>();
  CaseModel? caseModel;
  fetchCase() async {
    EasyLoading.show(status: 'Loading..', dismissOnTap: false);
    await CaseApi()
        .fetchCase(
            caseUnique: uniqueCont.text.isEmpty
                ? caseModel!.caseDetails!.caseUnique!
                : uniqueCont.text.trim())
        .then((res) {
      if (res == null || res == 'error') {
        EasyLoading.dismiss();
        emit(MainFailure('Check Internet Connection'));
      } else if (res['success'] == true) {
        caseModel = CaseModel.fromJson(res);

        uniqueCont.text.isNotEmpty ? clearAndSave() : null;
        emit(uniqueCont.text.isEmpty
            ? MainInitial()
            : MainSuccess(res['message']));
        EasyLoading.dismiss();
      } else {
        emit(MainFailure(res['message']));
        EasyLoading.dismiss();
      }
    });
  }

  clearAndSave() async {
    if (AppShared.localStorage!.getBool(uniqueCont.text.trim()) != false) {
      await FirebaseMessaging.instance.subscribeToTopic(uniqueCont.text.trim());
      await AppShared.localStorage!.setBool(uniqueCont.text.trim(), true);
    }
    AppShared.localStorage!.setInt('notes', caseModel!.caseNotes!.length);
    await AppShared.localStorage!
        .setString('caseUnique', uniqueCont.text.trim());
    uniqueCont.clear();
  }

  refreshState() {
    emit(MainInitial());
  }
}
