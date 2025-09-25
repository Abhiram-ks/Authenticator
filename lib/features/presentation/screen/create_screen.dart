import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/common/custom_textfiled.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/create_cubit/create_cubit.dart';
import 'package:authenticator/features/presentation/bloc/cubit/form_cubit.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/presentation/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
 
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
                        padding:  EdgeInsets.symmetric(horizontal:screenWidth * .05),
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
                                  hintText: 'Type Your $field',
                                  isPasswordField: field == "Password" || field == "Card Number" || field == "Expiry Date" || field == "Pin" || field == "Email" ,
                                  maxLines: field == "Notes" ? 4 : 1,
                                  minLines: field == "Notes" ? 4 : 1,
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
                    bottomNavigationBar:
                        BlocBuilder<FormCubit, CustomFormState>(
                          builder: (context, formState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: CustomButton(
                                  text:
                                      formState.canSave
                                          ? 'Save'
                                          : 'Complete All Fields',
                                  onPressed: formState.canSave ? () {} : null,
                                  bgColor:
                                      formState.canSave
                                          ? AppPalette.blueColor
                                          : AppPalette.greyColor,
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
