import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/account_remote_datasource.dart';
import 'package:authenticator/features/presentation/bloc/totp_cubit/totp_cubit.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_auth_account_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CloudScreen extends StatelessWidget {
  const CloudScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final AccountRemoteDataSource _ds = AccountRemoteDataSource();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your 2FA Accounts'),
      ),
      body: StreamBuilder<List<AuthAccount>>(
        stream: _ds.streamAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final accounts = snapshot.data ?? const <AuthAccount>[];
          if (accounts.isEmpty) {
            return const Center(child: Text('No accounts stored yet'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: accounts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final a = accounts[index];
              return BlocProvider(
                create: (_) => TotpCubit(account: a),
                child: Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text('${a.issuer.isNotEmpty ? a.issuer : 'Account'} — ${a.label}'),
                    subtitle: Row(
                      children: [
                        BlocSelector<TotpCubit, TotpState, int>(
                          selector: (state) => state.remainingSeconds,
                          builder: (context, remaining) {
                            return Text('Expires in $remaining s');
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BlocSelector<TotpCubit, TotpState, ({int remaining, int period})>(
                            selector: (state) => (remaining: state.remainingSeconds, period: state.period),
                            builder: (context, data) {
                              final value = (data.remaining / (data.period > 0 ? data.period : 30)).clamp(0.0, 1.0);
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: AppPalette.hintColor,
                                color: AppPalette.blueColor,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    trailing: BlocSelector<TotpCubit, TotpState, String>(
                      selector: (state) => state.code,
                      builder: (context, code) {
                        return Text(
                          code,
                          style: const TextStyle(
                            fontFeatures: [FontFeature.tabularFigures()],
                            fontSize: 20,
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
    );
  }
}