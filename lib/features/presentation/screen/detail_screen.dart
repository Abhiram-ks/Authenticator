import 'dart:convert';

import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/credential_remote_datasource.dart';
import 'package:authenticator/features/data/repo/credential_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/fetch_singel_usecase.dart';
import 'package:authenticator/features/presentation/bloc/single_credential_bloc/single_credential_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatelessWidget {
  final String docId;
  final String label;

  const DetailScreen({
    super.key,
    required this.docId,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SingleCredentialBloc(
        useCase: FetchSingleCredentialUseCase(
          CredentialRemoteDataSourceImpl(remote: CredentialRemoteDataSource()),
        ),
      ), 
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.blueColor,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(isTitle: true, title: label),
                body: DetailBody(width: width,docId: docId,lable: label,),
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
    required this.lable
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
      child: BlocBuilder<SingleCredentialBloc, SingleCredentialState>(
        builder: (context, state) {
          if (state is SingleCredentialLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                  Text(
                    credential.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ConstantWidgets.hight10(context),
                  if (credential.username != null)
                    Text("Username: ${credential.username}"),
                  if (credential.password != null)
                    Text("Password: ${credential.password}"),
                  if (credential.url != null)
                    Text("URL: ${credential.url}"),
                  if (credential.notes.isNotEmpty)
                    Text("Notes: ${credential.notes}"),
                  const Divider(),
                  Text(
                    "Created: ${credential.createdAt?.toLocal().toString() ?? "N/A"}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "Updated: ${credential.updatedAt?.toLocal().toString() ?? "N/A"}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
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
    );
  }
}