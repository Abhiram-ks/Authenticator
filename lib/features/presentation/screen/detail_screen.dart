import 'dart:developer';

import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/credential_remote_datasource.dart';
import 'package:authenticator/features/data/datasource/favlike_remote_datasource.dart';
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/data/repo/credential_repo_impl.dart';
import 'package:authenticator/features/data/repo/likefev_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/fetch_singel_usecase.dart';
import 'package:authenticator/features/domain/usecase/delete_credential_usecase.dart';
import 'package:authenticator/features/domain/usecase/likefev_usecase.dart';
import 'package:authenticator/features/presentation/bloc/fav_like_cubit/like_cubit.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/presentation/bloc/single_credential_bloc/single_credential_bloc.dart';
import 'package:authenticator/features/presentation/bloc/delete_credential_bloc/delete_credential_bloc.dart';
import 'package:authenticator/features/presentation/bloc/delete_credential_bloc/delete_credential_state.dart';
import 'package:authenticator/features/presentation/bloc/delete_credential_bloc/delete_credential_event.dart';
import 'package:authenticator/features/presentation/screen/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatelessWidget {
  final String docId;
  final String userId;
  final String label;

  const DetailScreen({
    super.key,
    required this.docId,
    required this.label,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => SingleCredentialBloc(
                useCase: FetchSingleCredentialUseCase(
                  CredentialRemoteDataSourceImpl(
                    remote: CredentialRemoteDataSource(),
                  ),
                ),
              ),
        ),
        BlocProvider(create: (_) => ProgresserCubit()),
        BlocProvider(
          create:
              (_) => DeleteCredentialBloc(
                useCase: DeleteCredentialUseCase(
                  repo: CredentialRemoteDataSourceImpl(
                    remote: CredentialRemoteDataSource(),
                  ),
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => LikeCubit(
                likeUseCase: LikeUseCase(
                  FavoriteRepositoryImpl(remote: FavlikeRemoteDatasource()),
                ),
                unlikeUseCase: UnlikeUseCase(
                  FavoriteRepositoryImpl(remote: FavlikeRemoteDatasource()),
                ),
                getFavoritesUseCase: GetFavoritesUseCase(
                  FavoriteRepositoryImpl(remote: FavlikeRemoteDatasource()),
                ),
                userId: userId,
              )..watchFavorites(docId),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.blueColor,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(isTitle: true, title: label),
                body: DetailBody(width: width, docId: docId, lable: label),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailBody extends StatefulWidget {
  const DetailBody({
    super.key,
    required this.width,
    required this.docId,
    required this.lable,
  });

  final double width;
  final String docId;
  final String lable;

  @override
  State<DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SingleCredentialBloc>().add(
        SingleCredentialRequest(docId: widget.docId),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.width * .06),
      child: BlocListener<DeleteCredentialBloc, DeleteCredentialState>(
        listener: (context, deleteState) {
          if (deleteState is DeleteCredentialSuccess) {
            CustomSnackBar.show(
              context,
              message: deleteState.message,
              textAlign: TextAlign.center,
              backgroundColor: AppPalette.greenColor,
            );
            Navigator.of(context).pop(true);
          } else if (deleteState is DeleteCredentialError) {
            CustomSnackBar.show(
              context,
              message: deleteState.message,
              textAlign: TextAlign.center,
              backgroundColor: AppPalette.redColor,
            );
          }
        },
        child: BlocBuilder<SingleCredentialBloc, SingleCredentialState>(
          builder: (context, state) {
            if (state is SingleCredentialLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SingleCredentialLoaded) {
              final credential = state.model;
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.lable} Detail',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'To keep our community safe, your information is used for identity verification and is protected with end-to-end encryption.',
                    ),
                    ConstantWidgets.hight30(context),
                    Align(
                      alignment: Alignment.topRight,
                      child: BlocBuilder<LikeCubit, LikeState>(
                        builder: (context, likeState) {
                          bool isLiked = false;
                          if (likeState is LikeLoaded) {
                            isLiked = likeState.isLiked;
                          }

                          return IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_outline_sharp,
                              color: isLiked    ? AppPalette.redColor  : AppPalette.greyColor,
                            ),
                            onPressed: () {
                              context.read<LikeCubit>().toggleLike(
                                widget.docId,
                                isLiked,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Text(
                      credential.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ConstantWidgets.hight10(context),
                    if (credential.username != null)
                      textDetailsFiled(
                        labelText: 'User Name',
                        subLabelText: credential.username ?? 'Fetching Failed',
                        enableClipboard: true,
                      ),

                    if (credential.cardHolderName != null)
                      textDetailsFiled(
                        labelText: 'Card Holder Name',
                        subLabelText:
                            credential.cardHolderName ?? 'Fetching Failed',
                        enableClipboard: true,
                      ),
                    if (credential.cardHolderName != null)
                      textDetailsFiled(
                        labelText: 'Card Holder Name',
                        subLabelText:
                            credential.cardHolderName ?? 'Fetching Failed',
                        enableClipboard: true,
                      ),
                    if (credential.cardType != null)
                      textDetailsFiled(
                        labelText: 'Card Type',
                        subLabelText: credential.cardType ?? 'Fetching Failed',
                      ),

                    if (credential.firstName != null)
                      textDetailsFiled(
                        labelText: 'First Name',
                        subLabelText: credential.firstName ?? 'Fetching Failed',
                      ),
                    if (credential.lastName != null)
                      textDetailsFiled(
                        labelText: 'Last Name',
                        subLabelText: credential.lastName ?? 'Fetching Failed',
                      ),
                    if (credential.sex != null)
                      textDetailsFiled(
                        labelText: 'Sex',
                        subLabelText: credential.sex ?? 'Fetching Failed',
                      ),
                    if (credential.birthday != null)
                      textDetailsFiled(
                        labelText: 'Birthday',
                        subLabelText: credential.birthday ?? 'Fetching Failed',
                      ),
                    if (credential.occupation != null)
                      textDetailsFiled(
                        labelText: 'Occupation',
                        subLabelText:
                            credential.occupation ?? 'Fetching Failed',
                      ),
                    if (credential.company != null)
                      textDetailsFiled(
                        labelText: 'Company',
                        subLabelText: credential.company ?? 'Fetching Failed',
                      ),
                    if (credential.department != null)
                      textDetailsFiled(
                        labelText: 'Department',
                        subLabelText:
                            credential.department ?? 'Fetching Failed',
                      ),
                    if (credential.jobTitle != null)
                      textDetailsFiled(
                        labelText: 'Job Titile',
                        subLabelText: credential.jobTitle ?? 'Fetching Failed',
                      ),
                    if (credential.identityAddress != null)
                      textDetailsFiled(
                        labelText: 'Address',
                        subLabelText:
                            credential.identityAddress ?? 'Fetching Failed',
                      ),
                    if (credential.email != null)
                      textDetailsFiled(
                        labelText: 'Email',
                        subLabelText: credential.email ?? 'Fetching Failed',
                        enableClipboard: true,
                      ),
                    if (credential.homePhone != null)
                      textDetailsFiled(
                        labelText: 'Home Phone',
                        subLabelText: credential.homePhone ?? 'Fetching Failed',
                        enableClipboard: true,
                      ),
                    if (credential.cellPhone != null)
                      textDetailsFiled(
                        labelText: 'Cell Phone',
                        subLabelText: credential.cellPhone ?? 'Fetching Failed',
                        enableClipboard: true,
                      ),
                    if (credential.addressLine1 != null)
                      textDetailsFiled(
                        labelText: 'Address Line 1',
                        subLabelText:
                            credential.addressLine1 ?? 'Fetching Failed',
                      ),
                    if (credential.addressLine2 != null)
                      textDetailsFiled(
                        labelText: 'Address Line 2',
                        subLabelText:
                            credential.addressLine2 ?? 'Fetching Failed',
                      ),
                    if (credential.city != null)
                      textDetailsFiled(
                        labelText: 'City',
                        subLabelText: credential.city ?? 'Fetching Failed',
                      ),
                    if (credential.country != null)
                      textDetailsFiled(
                        labelText: 'Country',
                        subLabelText: credential.country ?? 'Fetching Failed',
                      ),
                    if (credential.state != null)
                      textDetailsFiled(
                        labelText: 'State',
                        subLabelText: credential.state ?? 'Fetching Failed',
                      ),
                    if (credential.postalCode != null)
                      textDetailsFiled(
                        labelText: 'Postal Code or Zip Code',
                        subLabelText:
                            credential.postalCode ?? 'Fetching Failed',
                        enableClipboard: true,
                      ),
                    const Divider(color: AppPalette.hintColor),

                    textDetailsFiled(
                      labelText: 'Notes',
                      subLabelText: credential.notes,
                    ),
                    const Divider(color: AppPalette.hintColor),
                    Text(
                      "Updated: ${credential.updatedAt?.toLocal().toString() ?? "N/A"}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    ConstantWidgets.hight30(context),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Edit',
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditScreen(
                                        credential: credential,
                                        label: widget.lable,
                                      ),
                                ),
                              );
                              if (result == true) {
                                if (!context.mounted) return;
                                context.read<SingleCredentialBloc>().add(
                                  SingleCredentialRequest(docId: widget.docId),
                                );
                              }
                            },
                            bgColor: AppPalette.blueColor,
                          ),
                        ),
                        ConstantWidgets.width20(context),
                        Expanded(
                          child: CustomButton(
                            text: 'Delete',
                            onPressed: () {},
                            bgColor: AppPalette.redColor,
                          ),
                        ),
                      ],
                    ),
                    ConstantWidgets.hight20(context),
                  ],
                ),
              );
            } else if (state is SingleCredentialError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("No data found"));
            }
          },
        ),
      ),
    );
  }
}

Widget textDetailsFiled({
  required String labelText,
  required String subLabelText,
  bool enableClipboard = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // ✅ ensures text can wrap
            child: Text(
              labelText,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // just in case
            ),
          ),
          if (enableClipboard)
            IconButton(
              icon: const Icon(
                Icons.copy,
                size: 16,
                color: AppPalette.greyColor,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: subLabelText));
              },
            ),
        ],
      ),
      Text(
        subLabelText,
        style: const TextStyle(color: AppPalette.greyColor),
        textAlign: TextAlign.start,
        softWrap: true, // ✅ allows multi-line wrapping
      ),
    ],
  );
}
