import 'dart:developer';

import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_textfiled.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/debouncer/debouncer.dart';
import 'package:authenticator/core/routes/app_routes.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/presentation/bloc/create_cubit/create_cubit.dart';
import 'package:authenticator/features/presentation/bloc/fetch_credential_bloc/fetch_credentail_bloc.dart';
import 'package:authenticator/features/presentation/screen/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

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
              body: SearchBody(width: width),

              floatingActionButton: FloatingActionButton(
                onPressed: () => showAddBottomSheet(context, true),
                backgroundColor: AppPalette.whiteColor,
                elevation: 3,
                child: const Icon(
                  CupertinoIcons.add,
                  color: AppPalette.blueColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
class SearchBody extends StatefulWidget {
  final double width;
  const SearchBody({super.key, required this.width});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  late final Debouncer _debouncer;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 500);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormFieldWidget(
            controller: TextEditingController(),
            borderRadius: 30,
            hintText: 'Search',
            prefixIcon: CupertinoIcons.search,
            onChanged: (val){
              _debouncer.run(() {
                context.read<FetchCredentailBloc>().add(FetchCredentialsSearch(query: val));
              });
            },
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
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => showAddBottomSheet(context, false),
                ),
                const Divider(height: 1, color: AppPalette.hintColor),
                ListTile(
                  leading: const Icon(
                    Icons.favorite,
                    color: AppPalette.redColor,
                  ),
                  title: const Text("Favorite"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),

          ConstantWidgets.hight20(context),
          const Text(
            "Safely protect your valuable assets",
            style: TextStyle(fontSize: 12),
          ),

          ConstantWidgets.hight10(context),
          SearchBuilderWidget(),
        ],
      ),
    );
  }
}

class SearchBuilderWidget extends StatefulWidget {
  const SearchBuilderWidget({super.key});

  @override
  State<SearchBuilderWidget> createState() => _SearchBuilderWidgetState();
}

class _SearchBuilderWidgetState extends State<SearchBuilderWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchCredentailBloc>().add(FetchCredentialsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<FetchCredentailBloc, FetchCredentailState>(
        builder: (context, state) {
          if (state is FetchCredentailLoading) {
               return  Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: AppPalette.greyColor,
                    color: AppPalette.blueColor,
                  ),
                ),
                ConstantWidgets.width20(context),
                Text(
                  "Loading",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppPalette.greyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
          }else if (state is FetchCredentailEmpty) {
           return Center(child: Text("Request processing failed due to empty data.", style: TextStyle(fontSize: 10),textAlign: TextAlign.center,));
          }
          else if (state is FetchCredentailLoad) {
            final credentials = state.credentials;

            return ListView.builder(
              itemCount: credentials.length,
              itemBuilder: (context, index) {
                final item = credentials[index];
              
                return ListTile(
                  leading: Icon(item.itemType.icon, color: item.itemType.color, size: 30,),
                  title: Text(item.itemType.label, style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                  subtitle: Text(item.name, overflow: TextOverflow.ellipsis,),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(docId: item.docId ?? '', label: item.itemType.label,)));
                  },
                );
              },
            );
          }
           return Center(child: Text("Request processing failed. Try again later.", style: TextStyle(fontSize: 10),textAlign: TextAlign.center,));
        },
      ),
    );
  }
}

extension CredentialEntityExtension on CredentialEntity {
  ItemType get itemType {
    if (isLogin) return ItemType.login;
    if (isCreditCard) return ItemType.creditCard;
    if (isNotes) return ItemType.notes;
    if (isIdentity) return ItemType.identity;
    if (isAddress) return ItemType.address;
    return ItemType.notes;
  }
}

enum ItemType { login, creditCard, notes, identity, address }

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
        return AppPalette.orengeColor;
      case ItemType.identity:
        return AppPalette.greenColor;
      case ItemType.address:
        return AppPalette.redColor;
    }
  }
    String get dbKey {
    switch (this) {
      case ItemType.login:
        return "isLogin";
      case ItemType.creditCard:
        return "isCreditCard";
      case ItemType.notes:
        return "isNotes";
      case ItemType.identity:
        return "isIdentity";
      case ItemType.address:
        return "isAddress";
    }
  }
  List<String> get requiredFields {
    switch (this) {
      case ItemType.login:
        return ["Name", "Username", "Password", "URL", "Notes"];
      case ItemType.creditCard:
        return [
          "Name",
          "Card Holder Name",
          "Card Number",
          "Card Type",
          "Expiry Date",
          "Pin",
          "Postal Code or Zip Code",
          "Notes",
        ];
      case ItemType.notes:
        return ["Name", "Notes"];
      case ItemType.identity:
        return [
          "Name",
          "First Name",
          "Last Name",
          "Sex",
          "Birthday",
          "Occupation",
          "Company",
          "Department",
          "Job Titile",
          "Address",
          "Email",
          "Home Phone",
          "Cell Phone",
          "Notes",
        ];
      case ItemType.address:
        return [
          "Name",
          "Address Line 1",
          "Address Line 2",
          "City",
          "Country",
          "State",
          "Postal Code or Zip Code",
        ];
    }
  }
}

void showAddBottomSheet(BuildContext context, bool val) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) {
      return CupertinoActionSheet(
        actions:
            ItemType.values.map((item) {
              return CupertinoActionSheetAction(
                onPressed: () {
                  context.read<CreateCubit>().setItem(item);
                  if (val) {
                    Navigator.pushNamed(context, AppRoutes.creteScreen);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.category);
                  }
                },
                child: Row(
                  children: [
                    Icon(item.icon, color: item.color),
                    ConstantWidgets.width40(context),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppPalette.blackColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text(
            "Cancel",
            style: TextStyle(fontSize: 14, color: AppPalette.blackColor),
          ),
        ),
      );
    },
  );
}
