import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'colors_state.dart';

class ColorStateNotifier extends StateNotifier<ColorsState> {
  ColorStateNotifier() : super(ColorsState());
}
