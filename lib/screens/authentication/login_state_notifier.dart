import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_state.dart';

class LoginStateNotifier extends StateNotifier<LoginState> {
  final Ref ref;
  LoginStateNotifier(this.ref) : super(const LoginState());
}
