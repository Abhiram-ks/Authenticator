import 'dart:developer';

import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_textfiled.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/routes/app_routes.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/core/validation/validation_helper.dart';
import 'package:authenticator/features/presentation/bloc/create_cubit/create_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return ColoredBox(
          color: AppPalette.blueColor,
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'Password',
                isTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.help_outline,
                      color: AppPalette.greyColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      controller: TextEditingController(),
                      borderRadius:30 ,
                      hintText: 'Search',
                      prefixIcon: CupertinoIcons.search,
                      validate: ValidatorHelper.textFieldValidation,
                    ),
                    ConstantWidgets.hight10(context),
                    Card(
                      color: AppPalette.whiteColor,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.grid_view,
                              color: AppPalette.orengeColor,
                            ),
                            title: const Text("Category"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: AppPalette.hintColor,),
                          ListTile(
                            leading: const Icon(
                              Icons.favorite,
                              color: AppPalette.redColor,
                            ),
                            title: const Text("Favorite"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    ConstantWidgets.hight20(context),
                    const Text("Safely protect your valuable assets"),
                  ],
                ),
              ),

              floatingActionButton: FloatingActionButton(
                onPressed: () => showAddBottomSheet(context),
                backgroundColor: AppPalette.whiteColor,
                elevation: 3,
                child: const Icon(CupertinoIcons.add, color: AppPalette.blueColor),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum ItemType {
  login,
  creditCard,
  notes,
  identity,
  address,
}


  void showAddBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
          actions: ItemType.values.map((item) {
            return CupertinoActionSheetAction(
              onPressed: () {
                context.read<CreateCubit>().setItem(item);
                Navigator.pushNamed(context, AppRoutes.creteScreen);
              },
              child: Row(
                children: [
                  Icon(item.icon, color: item.color),
                  ConstantWidgets.width40(context),
                  Text(item.label, style: const TextStyle(fontSize: 14, color: AppPalette.blackColor)),
                ],
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: const Text("Cancel",style:  TextStyle(fontSize: 14, color: AppPalette.blackColor)),
          ),
        );
      },
    );
  }

extension ItemTypeExtension on ItemType {
  String get label {
    switch (this) {
      case ItemType.login:
        return "Login";
      case ItemType.creditCard:
        return "Credit Card";
      case ItemType.notes:
        return "Notes";
      case ItemType.identity:
        return "Identities";
      case ItemType.address:
        return "Address";
    }
  }

  IconData get icon {
    switch (this) {
      case ItemType.login:
        return CupertinoIcons.person;
      case ItemType.creditCard:
        return CupertinoIcons.creditcard;
      case ItemType.notes:
        return CupertinoIcons.doc_text;
      case ItemType.identity:
        return CupertinoIcons.person_crop_rectangle;
      case ItemType.address:
        return CupertinoIcons.location;
    }
  }
  Color get color {
    switch (this) {
      case ItemType.login:
        return AppPalette.blackColor;
      case ItemType.creditCard:
        return AppPalette.blueColor;
      case ItemType.notes:
        return  AppPalette.orengeColor;
      case ItemType.identity:
        return AppPalette.redColor;
      case ItemType.address:
        return AppPalette.greyColor;
    }
  }

    List<String> get requiredFields {
    switch (this) {
      case ItemType.login:
        return ["Name", "Username", "Password", "URL", "Notes", ];
      case ItemType.creditCard:
        return ["Name","Card Holder Name", "Card Number","Card Type" , "Expiry Date","Pin","Postal Code or Zip Code", "Notes"];
      case ItemType.notes:
        return ["Name", "Notes"];
      case ItemType.identity:
        return ["Name", "First Name", "Last Name", "Sex", "Birthday", "Occupation", "Company", "Department", "Job Titile", "Address", "Email", "Home Phone", "Cell Phone", "Notes"];
      case ItemType.address:
        return ["Name", "Address Line 1", "Address Line 2", "City", "Country", "State", "Postal Code or Zip Code"];
    }
  }
}

