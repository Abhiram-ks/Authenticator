
import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/datasource/favlike_credentials_remote_datasource.dart';
import 'package:authenticator/features/data/repo/fav_credential_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/fetch_fav_credential_usecase.dart';
import 'package:authenticator/features/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:authenticator/features/presentation/screen/detail_screen.dart';
import 'package:authenticator/features/presentation/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FavritesScreen extends StatelessWidget {
  const FavritesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteBloc(local: AuthLocalDatasource(), useCase: FetchFavoritesUseCase(FetchFavoriteRepositoryImpl(remote: FetchFavoriteRemoteDataSource()))),
      child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
    
              return ColoredBox(
                color: AppPalette.blueColor,
                child: SafeArea(
                  child: Scaffold(
                    appBar: CustomAppBar(isTitle: true, title: 'Favorite'),
                    body: FavoriteBody(width: width,),
                  ),
                ),
              );
            },
          ),
    );
  }
}

class FavoriteBody extends StatefulWidget {
  final double width;
  const FavoriteBody({super.key, required this.width});

  @override
  State<FavoriteBody> createState() => _FavoriteBodyState();
}

class _FavoriteBodyState extends State<FavoriteBody> {
    @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteBloc>().add(
        LoadFavorites(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
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
          }else if (state is FavoriteEmpty) {
           return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No favorites found.', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                Text("Request processing failed due to empty data.", style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
              ],
            ));
          }
          else if (state is FavoriteLoaded) {
            final credentials = state.favorites;

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



