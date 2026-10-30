# Workload Logger

A personal Android app for logging academic work as it happens, built for the
DEIE Workload Model (University of Ruhuna). It credits **counted outputs ×
fixed rates** from the workbook's Admin_Config sheet, never time spent, and
exports your own Data_Entry rows in the workbook's exact layout, so nothing
is retyped.

- Works offline; all data stays on the phone.
- Specification: [`docs/SPEC.md`](docs/SPEC.md) · build plan:
  [`docs/PLAN.md`](docs/PLAN.md) · guidance for Claude Code:
  [`CLAUDE.md`](CLAUDE.md).

## Build and run

```
flutter pub get
dart run build_runner build      # after changing drift tables
flutter analyze
flutter test
flutter run                      # on the connected Android phone
```

## Release build

```
flutter build apk --release --split-per-abi
```

`--split-per-abi` makes one smaller APK per processor type; most phones need
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`. Without it you get
one larger APK that runs everywhere.

Install it on the connected phone with `flutter install --release`, or copy
the APK to the phone and open it.

### Release key

Release builds are signed with a dedicated key kept **outside** this repo, so
updates install over the existing app (keeping your data) from any computer
that has the key.

1. Create the key once, in your own terminal (you choose the passwords; they
   are never written into the repo):

   ```
   "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkeypair -v ^
     -keystore C:\Users\staff\keys\workload_logger.jks ^
     -keyalg RSA -keysize 2048 -validity 10000 -alias workload_logger
   ```

2. Copy `android/key.properties.example` to `android/key.properties` (it is
   git-ignored) and fill in the passwords.
3. **Back up** `workload_logger.jks` and the passwords (e.g. a password
   manager). If they are lost, a new install needs uninstalling the app,
   which deletes its data.

Without `android/key.properties`, release builds fall back to the debug key.

Changing from the debug key to the release key requires uninstalling the app
once. **Export your Data_Entry rows and evidence log first** (Summary →
Export), and reload the workbook after reinstalling.

## Regenerating the launcher icon

The adaptive icon is a vector (`android/app/src/main/res/drawable/`). The PNGs
for Android 7.x are drawn by a small tool:

```
flutter test tool/generate_icons_test.dart
```
