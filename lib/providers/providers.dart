import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quicktodo/db/db.dart';
import 'package:quicktodo/screens/authentication/login_state.dart';
import 'package:quicktodo/screens/authentication/login_state_notifier.dart';
import 'package:quicktodo/screens/home/home_state.dart';
import 'package:quicktodo/screens/home/home_state_notifier.dart';
import 'package:quicktodo/styles/color/colors_state_notifier.dart';
import 'package:quicktodo/styles/color/colors_state.dart';
import 'package:quicktodo/styles/textstyles/text_styles.dart';

final dbProvider = Provider((ref) => DB());

final colorsProvider = StateNotifierProvider<ColorStateNotifier, ColorsState>(
    (ref) => ColorStateNotifier());

final textStyleProvider = StateProvider((ref) {
  final colorThemeState = ref.watch(colorsProvider);
  return TextStyles(colors: colorThemeState);
});
final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, LoginState>(
        (ref) => LoginStateNotifier(ref));
        
final homeStateProvider = StateNotifierProvider<HomeStateNotifier, HomeState>(
    (ref) => HomeStateNotifier(ref));
