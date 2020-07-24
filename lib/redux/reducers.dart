import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/redux/actions.dart';

Settings reducer(Settings prevState, dynamic action) {
  Settings newState = Settings.fromSettings(prevState);

  if (action is Sound) {
    newState.sound = action.payload;
  }

  if (action is NightTheme) {
    newState.nightTheme = action.payload;
  }

  return newState;
}