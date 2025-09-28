import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/datasource/category_remote_datasource.dart';
import 'package:authenticator/features/data/repo/category_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/fetch_category_usecase.dart';
import 'package:authenticator/features/presentation/bloc/fetch_category/fetch_category_bloc.dart';
import 'package:authenticator/features/presentation/screen/detail_screen.dart';
import 'package:authenticator/features/presentation/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/create_cubit/create_cubit.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        return BlocBuilder<CreateCubit, ItemType?>(
          builder: (context, selectedItem) {
            if (selectedItem == null) {
              return ColoredBox(
                color: AppPalette.blueColor,
                child: SafeArea(
                  child: Scaffold(
                    appBar: CustomAppBar(
                      title: 'No Category selected',
                      isTitle: true,
                    ),
                    body: const Center(child: Text("No Category selected")),
                  ),
                ),
              );
            }
            return BlocProvider(
              create: (context) => FetchCategoryBloc(local:AuthLocalDatasource(),usecase:FetchCategoryUsecase(CategoryRepositroyImple(remote: CategoryRemoteDatasource()))  ),
              child: ColoredBox(
                color: AppPalette.blueColor,
                child: SafeArea(
                  child: Scaffold(
                    appBar: CustomAppBar(
                      title: selectedItem.label,
                      isTitle: true,
                    ),
                    body: CategoryBody(
                      screenWidth: screenWidth,
                      category: selectedItem,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CategoryBody extends StatefulWidget {
  final ItemType category;
  final double screenWidth;

  const CategoryBody({
    super.key,
    required this.screenWidth,
    required this.category,
  });

  @override
  State<CategoryBody> createState() => _CategoryBodyState();
}

class _CategoryBodyState extends State<CategoryBody> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchCategoryBloc>().add(
        FetchCategoryFilter(category: widget.category.dbKey),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<FetchCategoryBloc, FetchCategoryState>(
        builder: (context, state) {
          if (state is FetchCategoryLoading) {
               return  Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: AppPalette.blueColor,
                    color: AppPalette.greyColor,
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
          }else if (state is FetchCategoryEmpty) {
           return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No categories found.', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                Text("Request processing failed due to empty data.", style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
              ],
            ));
          }
          else if (state is FetchCategorySuccess) {
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(docId: item.docId ?? '', label: item.itemType.label, userId: item.uid)));
                  },
                );
              },
            );
          }
           return Center(child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
             children: [
              Icon(Icons.cloud_off_outlined, size: 50,),
              Text('Request failed', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
               Text("Request processing failed. Try again later.", style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
             ],
           ));
        },
      );
  }
}
