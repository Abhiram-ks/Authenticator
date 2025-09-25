import 'dart:async';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_auth_account_data.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_totp_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotpState {
  final String code;
  final int remainingSeconds;
  final int period;

  const TotpState({
    required this.code,
    required this.remainingSeconds,
    required this.period,
  });

  TotpState copyWith({
    String? code,
    int? remainingSeconds,
    int? period,
  }) {
    return TotpState(
      code: code ?? this.code,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      period: period ?? this.period,
    );
  }

}

class TotpCubit extends Cubit<TotpState> {
  final AuthAccount account;
  late final Timer _timer;

  TotpCubit({required this.account})
      : super(
          TotpState(
            code: '------',
            remainingSeconds: account.period > 0 ? account.period : 30,
            period: account.period > 0 ? account.period : 30,
          ),
        ) {
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final period = account.period > 0 ? account.period : 30;
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final elapsed = now % period;
    final remaining = period - elapsed;

    final code = TotpUtils.generateTOTPCode(
      secret: account.secret,
      digits: account.digits,
      period: period,
      forTimeSeconds: now,
    );

    final nextState = state.copyWith(
      code: code,
      remainingSeconds: remaining,
      period: period,
    );
    emit(nextState);
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}


