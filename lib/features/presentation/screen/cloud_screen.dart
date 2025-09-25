// For monospaced numeric glyphs in OTP text
import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/account_remote_datasource.dart';
import 'package:authenticator/features/presentation/bloc/totp_cubit/totp_cubit.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_auth_account_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays the user's stored 2FA accounts from Firestore.
/// - The screen itself is a StatelessWidget (no global rebuild timer).
/// - Each row uses its own TotpCubit that ticks once per second.
/// - BlocSelector is used so only the seconds/progress and code subtrees rebuild.

class CloudScreen extends StatelessWidget {
  const CloudScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final AccountRemoteDataSource ds = AccountRemoteDataSource();
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        return ColoredBox(
          color: AppPalette.blueColor,
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'Cloud Sync',
                isTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.help_outline, color: AppPalette.greyColor),
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .04),
                child: StreamBuilder<List<AuthAccount>>(
                  stream: ds.streamAccounts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
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
                    }
                    final accounts = snapshot.data ?? const <AuthAccount>[];
                    if (accounts.isEmpty) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud,
                              size: 50,
                              color: AppPalette.blueColor,
                            ),
                            ConstantWidgets.hight10(context),
                            Text(
                              'No accounts Synced yet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Scan a QR code to add and secure your account with 2FA",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: accounts.length,
                      separatorBuilder:
                          (_, __) => ConstantWidgets.hight10(context),
                      itemBuilder: (context, index) {
                        final a = accounts[index];
                        return BlocProvider(
                          create: (_) => TotpCubit(account: a),
                          child: Card(
                            color: AppPalette.whiteColor,
                            elevation: 1,
                            child: ListTile(
                              key: ValueKey(a.id),

                              title: Text(
                                '${a.issuer.isNotEmpty ? a.issuer : 'Account'}: ${a.label}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              subtitle: Row(
                                children: [
                                  BlocSelector<TotpCubit, TotpState, int>(
                                    selector: (state) => state.remainingSeconds,
                                    builder: (context, remaining) {
                                      return Text(
                                        'Expires in $remaining s',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    },
                                  ),
                                  ConstantWidgets.width20(context),

                                  SizedBox(
                                    width: width * .25, 
                                    child: BlocSelector<
                                      TotpCubit,
                                      TotpState,
                                      ({int remaining, int period})
                                    >(
                                      selector:
                                          (state) => (
                                            remaining: state.remainingSeconds,
                                            period: state.period,
                                          ),
                                      builder: (context, data) {
                                        final value = (data.remaining /
                                                (data.period > 0
                                                    ? data.period
                                                    : 30))
                                            .clamp(0.0, 1.0);
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ), 
                                          child: LinearProgressIndicator(
                                            value: value,
                                            minHeight: 4, 
                                            backgroundColor:
                                                AppPalette.hintColor,
                                            color: AppPalette.blueColor,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              trailing:
                                  BlocSelector<TotpCubit, TotpState, String>(
                                    selector: (state) => state.code,
                                    builder: (context, code) {
                                      return Text(
                                        code,
                                        style: const TextStyle(
                                          fontFeatures: [
                                            FontFeature.tabularFigures(),
                                          ],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ),
                        );
                      },
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
