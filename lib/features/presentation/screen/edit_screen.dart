import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/common/custom_textfiled.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/core/validation/validation_helper.dart';
import 'package:authenticator/features/data/datasource/credential_remote_datasource.dart';
import 'package:authenticator/features/data/repo/credential_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/update_credential_usecase.dart';
import 'package:authenticator/features/presentation/bloc/edit_credential_bloc/edit_credential_bloc.dart';
import 'package:authenticator/features/presentation/bloc/edit_credential_bloc/edit_credential_state.dart';
import 'package:authenticator/features/presentation/bloc/edit_credential_bloc/edit_credential_event.dart';
import 'package:authenticator/features/presentation/bloc/form_cubit/form_cubit.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/presentation/screen/search_screen.dart';
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditScreen extends StatefulWidget {
  final CredentialModel credential;
  final String label;

  const EditScreen({
    super.key,
    required this.credential,
    required this.label,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final GlobalKey<FormState> formKey;
  late final ItemType itemType;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    
    if (widget.credential.isLogin) {
      itemType = ItemType.login;
    } else if (widget.credential.isCreditCard) {
      itemType = ItemType.creditCard;
    } else if (widget.credential.isIdentity) {
      itemType = ItemType.identity;
    } else if (widget.credential.isAddress) {
      itemType = ItemType.address;
    } else if (widget.credential.isNotes) {
      itemType = ItemType.notes;
    } else {
      itemType = ItemType.login;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ProgresserCubit()),
            BlocProvider(
              create: (_) => FormCubit(itemType)..initializeWithCredential(widget.credential),
            ),
            BlocProvider(
              create: (context) => EditCredentialBloc(
                useCase: UpdateCredentialUseCase(
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
                  title: 'Edit ${widget.label}',
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
                      key: formKey,
                      child: BlocBuilder<FormCubit, CustomFormState>(
                        builder: (context, formState) {
                          final fields = itemType.requiredFields;

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
                                hintText: field == 'Name'
                                    ? 'What type of account?'
                                    : 'Type Your $field',
                                isPasswordField:
                                    field.toLowerCase().contains("password") ||
                                    field.toLowerCase().contains("card number") ||
                                    field.toLowerCase().contains("expiry date") ||
                                    field.toLowerCase().contains("pin"),
                                maxLines: field == "Notes" ? 4 : 1,
                                minLines: field == "Notes" ? 4 : 1,
                                validate: (val) => ValidatorHelper.validateField(
                                  field,
                                  val,
                                ),
                                onChanged: (val) => context
                                    .read<FormCubit>()
                                    .updateField(field, val),
                                initialValue: formState.values[field] ?? '',
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: BlocBuilder<FormCubit, CustomFormState>(
                  builder: (context, formState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: BlocListener<EditCredentialBloc, EditCredentialState>(
                          listener: (context, editState) {
                            if (editState is EditCredentialSuccess) {
                              CustomSnackBar.show(
                                context,
                                message: editState.message,
                                textAlign: TextAlign.center,
                                backgroundColor: AppPalette.greenColor,
                              );
                              Navigator.of(context).pop(true);
                            } else if (editState is EditCredentialError) {
                              CustomSnackBar.show(
                                context,
                                message: editState.message,
                                textAlign: TextAlign.center,
                                backgroundColor: AppPalette.redColor,
                              );
                            }
                          },
                          child: CustomButton(
                            text: formState.canSave ? 'Update' : 'Complete All Fields',
                            onPressed: formState.canSave
                                ? () {
                                    if (formKey.currentState?.validate() ?? false) {
                                      final values = context
                                          .read<FormCubit>()
                                          .state
                                          .values;

                                      final updatedCredential = widget.credential.copyWith(
                                        name: values['Name'] ?? widget.credential.name,
                                        username: values['Username'] ?? widget.credential.username,
                                        password: values['Password'] ?? widget.credential.password,
                                        url: values['URL'] ?? widget.credential.url,
                                        notes: values['Notes'] ?? widget.credential.notes,
                                        cardHolderName: values['Card Holder Name'] ?? widget.credential.cardHolderName,
                                        cardNumber: values['Card Number'] ?? widget.credential.cardNumber,
                                        cardType: values['Card Type'] ?? widget.credential.cardType,
                                        expiryDate: values['Expiry Date'] ?? widget.credential.expiryDate,
                                        pin: values['Pin'] ?? widget.credential.pin,
                                        postalCode: values['Postal Code or Zip Code'] ?? widget.credential.postalCode,
                                        firstName: values['First Name'] ?? widget.credential.firstName,
                                        lastName: values['Last Name'] ?? widget.credential.lastName,
                                        sex: values['Sex'] ?? widget.credential.sex,
                                        birthday: values['Birthday'] ?? widget.credential.birthday,
                                        occupation: values['Occupation'] ?? widget.credential.occupation,
                                        company: values['Company'] ?? widget.credential.company,
                                        department: values['Department'] ?? widget.credential.department,
                                        jobTitle: values['Job Titile'] ?? widget.credential.jobTitle,
                                        identityAddress: values['Address'] ?? widget.credential.identityAddress,
                                        email: values['Email'] ?? widget.credential.email,
                                        homePhone: values['Home Phone'] ?? widget.credential.homePhone,
                                        cellPhone: values['Cell Phone'] ?? widget.credential.cellPhone,
                                        addressLine1: values['Address Line 1'] ?? widget.credential.addressLine1,
                                        addressLine2: values['Address Line 2'] ?? widget.credential.addressLine2,
                                        city: values['City'] ?? widget.credential.city,
                                        country: values['Country'] ?? widget.credential.country,
                                        state: values['State'] ?? widget.credential.state,
                                      );

                                      context.read<EditCredentialBloc>().add(
                                        EditCredentialRequest(
                                          docId: widget.credential.docId!,
                                          credential: updatedCredential,
                                        ),
                                      );
                                    } else {
                                      CustomSnackBar.show(
                                        context,
                                        message: "Type your answer before proceed",
                                        textAlign: TextAlign.center,
                                        backgroundColor: AppPalette.redColor,
                                      );
                                    }
                                  }
                                : null,
                            bgColor: formState.canSave
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
  }
}
