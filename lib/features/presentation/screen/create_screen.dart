import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/common/custom_textfiled.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/core/validation/validation_helper.dart';
import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/datasource/credential_remote_datasource.dart';
import 'package:authenticator/features/data/repo/credential_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/credential_usecase.dart';
import 'package:authenticator/features/presentation/bloc/create_cubit/create_cubit.dart';
import 'package:authenticator/features/presentation/bloc/credential_bloc/credential_bloc.dart';
import 'package:authenticator/features/presentation/bloc/form_cubit/form_cubit.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/presentation/screen/search_screen.dart';
import 'package:authenticator/features/presentation/widget/create_widget/create_state_handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
                      title: 'No items selected',
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
                    body: const Center(child: Text("No item selected")),
                  ),
                ),
              );
            }

            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => FormCubit(selectedItem)),
                BlocProvider(create: (context) => ProgresserCubit()),
                BlocProvider(
                  create:
                      (context) => CredentialBloc(
                        local: AuthLocalDatasource(),
                        usecase: CredentialUsecase(
                          repo: CredentialRemoteDataSourceImpl(
                            remote: CredentialRemoteDataSource(),
                          ),
                        ),
                      ),
                ),
              ],
              child: ColoredBox(
                color: AppPalette.blueColor,
                child: SafeArea(
                  child: Scaffold(
                    appBar: CustomAppBar(
                      title: selectedItem.label,
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
                    body: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .05,
                        ),
                        child: Form(
                          key: _formkey,
                          child: BlocBuilder<FormCubit, CustomFormState>(
                            builder: (context, formState) {
                              final fields = selectedItem.requiredFields;

                              return ListView.separated(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                physics: const BouncingScrollPhysics(),
                                itemCount: fields.length,
                                separatorBuilder:
                                    (_, __) => ConstantWidgets.hight10(context),
                                itemBuilder: (context, index) {
                                  final field = fields[index];
                                  return TextFormFieldWidget(
                                    label: '$field *',
                                    hintText:field == 'Name'? 'What type of account?' : 'Type Your $field',
                                    isPasswordField:
                                        field.toLowerCase().contains(
                                          "password",
                                        ) ||
                                        field.toLowerCase().contains(
                                          "card number",
                                        ) ||
                                        field.toLowerCase().contains(
                                          "expiry date",
                                        ) ||
                                        field.toLowerCase().contains("pin"),
                                    maxLines: field == "Notes" ? 4 : 1,
                                    minLines: field == "Notes" ? 4 : 1,
                                    validate:
                                        (val) => ValidatorHelper.validateField(
                                          field,
                                          val,
                                        ),
                                    onChanged:
                                        (val) => context
                                            .read<FormCubit>()
                                            .updateField(field, val),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    bottomNavigationBar: BlocBuilder<
                      FormCubit,
                      CustomFormState
                    >(
                      builder: (context, formState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: BlocListener<CredentialBloc, CredentialState>(
                              listener: (context, credentialState) {
                                credentialStateHandle(context, credentialState);
                              },
                              child: CustomButton(
                                text:
                                    formState.canSave
                                        ? 'Save'
                                        : 'Complete All Fields',
                                onPressed:
                                    formState.canSave
                                        ? () {
                                          if (_formkey.currentState
                                                  ?.validate() ??
                                              false) {
                                            final values =
                                                context
                                                    .read<FormCubit>()
                                                    .state
                                                    .values;

                                            context.read<CredentialBloc>().add(
                                              SubmitCredential(
                                                type: selectedItem,
                                                val: values,
                                              ),
                                            );
                                          } else {
                                            CustomSnackBar.show(
                                              context,
                                              message:
                                                  "Type your answer before proced",
                                              textAlign: TextAlign.center,
                                              backgroundColor:
                                                  AppPalette.redColor,
                                            );
                                          }
                                        }
                                        : null,
                                bgColor:  formState.canSave
                                        ? AppPalette.blueColor
                                        : AppPalette.greyColor,
                              ),
                            ),
                          ),
                        );
                      },
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
