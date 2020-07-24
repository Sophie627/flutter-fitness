class Settings {
  bool sound;
  bool voice;
  bool nightTheme;

  Settings({
    this.sound = false,
    this.voice = true,
    this.nightTheme = false,
  });

  Settings.fromSettings(Settings another) {
    sound = another.sound;
    voice = another.voice;
    nightTheme = another.nightTheme;
  }
}