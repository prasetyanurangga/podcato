import 'package:flutter/foundation.dart';

class PlayButtonNotifier extends ValueNotifier<ButtonState> {
  PlayButtonNotifier() : super(_initialValue);
  static const _initialValue = ButtonState.loading;
}

enum ButtonState {
  paused,
  playing,
  loading,
}
