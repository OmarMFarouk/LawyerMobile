import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawyermobile/bloc/main_bloc/main_cubit.dart';
import 'package:lawyermobile/bloc/main_bloc/main_states.dart';
import 'package:lawyermobile/src/app_colors.dart';
import 'package:lawyermobile/src/app_shared.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../components/case/details_tile.dart';
import '../components/case/file_grid.dart';

class CaseScreen extends StatelessWidget {
  const CaseScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MainCubit.get(context);
          return Scaffold(
            backgroundColor: AppColors.primary,
            appBar: AppBar(
              backgroundColor: AppColors.litePrimary,
              foregroundColor: AppColors.secondary,
              title: Text(
                'Case no.${cubit.caseModel!.caseDetails!.caseNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                Stack(
                  children: [
                    AppShared.localStorage!.getInt('notes')! > 0
                        ? Positioned(
                            left: 3,
                            child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 9,
                                child: Text(
                                  AppShared.localStorage!
                                      .getInt('notes')
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )))
                        : const SizedBox(),
                    IconButton(
                        onPressed: () {
                          AppShared.localStorage!.setInt('notes', 0);
                          cubit.refreshState();
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            backgroundColor: AppColors.litePrimary,
                            builder: (context) => ListView.separated(
                              itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cubit.caseModel!.caseNotes![index]!
                                          .dateCreated!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      cubit.caseModel!.caseNotes![index]!
                                          .commentBody!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      maxLines: 8,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 10),
                              itemCount: cubit.caseModel!.caseNotes!.length,
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat)),
                  ],
                ),
                Switch(
                  value: AppShared.localStorage!
                      .getBool(cubit.caseModel!.caseDetails!.caseUnique!)!,
                  activeColor: AppColors.secondary,
                  onChanged: (s) {
                    if (AppShared.localStorage!.getBool(
                            cubit.caseModel!.caseDetails!.caseUnique!) ==
                        true) {
                      FirebaseMessaging.instance.unsubscribeFromTopic(
                          cubit.caseModel!.caseDetails!.caseUnique!);
                    } else {
                      FirebaseMessaging.instance.subscribeToTopic(
                          cubit.caseModel!.caseDetails!.caseUnique!);
                    }
                    AppShared.localStorage!
                        .setBool(cubit.caseModel!.caseDetails!.caseUnique!, s);
                    cubit.refreshState();
                  },
                  thumbIcon: WidgetStatePropertyAll(
                    Icon(
                      AppShared.localStorage!.getBool(
                              cubit.caseModel!.caseDetails!.caseUnique!)!
                          ? Icons.notifications_on
                          : Icons.notifications_off,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
            body: LayoutBuilder(builder: (context, consta) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: LiquidPullToRefresh(
                  onRefresh: () async => await cubit.fetchCase(),
                  showChildOpacityTransition: false,
                  backgroundColor: AppColors.secondary,
                  color: Colors.transparent,
                  springAnimationDurationInMilliseconds: 100,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.litePrimary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Case Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: consta.maxHeight * 0.01),
                              Row(
                                children: [
                                  DetailsTile(
                                    text: cubit
                                        .caseModel!.caseDetails!.caseSubject!,
                                    title: 'Case Subject',
                                    icon: Icons.subject,
                                  ),
                                  const SizedBox(width: 10),
                                  DetailsTile(
                                    text: cubit.caseModel!.caseDetails!
                                        .caseCourtChamber!,
                                    title: 'Court Chamber',
                                    icon: Icons.confirmation_number,
                                  ),
                                ],
                              ),
                              SizedBox(height: consta.maxHeight * 0.01),
                              Row(
                                children: [
                                  DetailsTile(
                                    text: cubit
                                        .caseModel!.caseDetails!.dateModified!
                                        .split(' ')
                                        .first,
                                    title: 'Updated At',
                                    icon: Icons.date_range,
                                  ),
                                  const SizedBox(width: 10),
                                  DetailsTile(
                                    text:
                                        cubit.caseModel!.caseDetails!.caseType!,
                                    title: 'Case Type',
                                    icon: Icons.category,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: consta.maxHeight * 0.02),

                        // Case Files Section
                        Container(
                          height: consta.maxHeight * 0.67,
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.litePrimary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Case Files',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GridView.builder(
                                itemCount: cubit.caseModel!.caseFiles!.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      consta.maxHeight * 0.0022 / 1,
                                ),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => FileGrid(
                                  fileDetails:
                                      cubit.caseModel!.caseFiles![index]!,
                                  index: index,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
