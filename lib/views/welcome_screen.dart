import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawyermobile/bloc/main_bloc/main_cubit.dart';
import 'package:lawyermobile/bloc/main_bloc/main_states.dart';
import 'package:lawyermobile/components/welcome/warning_dialog.dart';
import 'package:lawyermobile/src/app_colors.dart';
import 'package:lawyermobile/src/app_shared.dart';

import '../components/welcome/my_field.dart';
import '../src/app_navigator.dart';
import 'case_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(listener: (context, state) {
      if (state is MainFailure) {
        WarningDialog.show(msg: state.msg, context: context);
      }
      if (state is MainSuccess) {
        AppNavigator.push(
            context, const CaseScreen(), NavigatorAnimation.slideAnimation);
      }
    }, builder: (context, state) {
      var cubit = MainCubit.get(context);
      return Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Form(
              key: cubit.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset('assets/images/illustration.png'),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Easily track your case details through our customer app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        letterSpacing: 3,
                        fontSize: 22),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyField(
                    controller: cubit.uniqueCont,
                    hint: 'Enter Case Unique Key',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Material(
                    color: Colors.transparent,
                    elevation: 10,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.fetchCase();
                        }
                      },
                      splashColor: const Color(0xFFF0CCEF),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Text(
                          'View Case',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppShared.localStorage!.getString('caseUnique') == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  endIndent: 5,
                                )),
                                Text(
                                  'OR',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF0CCEF),
                                      fontSize: 22),
                                ),
                                Expanded(
                                    child: Divider(
                                  indent: 5,
                                ))
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  cubit.uniqueCont.text = AppShared
                                      .localStorage!
                                      .getString('caseUnique')!;
                                  cubit.fetchCase();
                                },
                                child: const Text(
                                  'Access Recent Case',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 17),
                                )),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
