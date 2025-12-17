# rfid_test

A small Flutter app to test NFC/RFID tag reads on Android handhelds (for example, C7 devices).

The app demonstrates basic NFC scanning using the `nfc_manager` plugin. It shows whether NFC is available, allows starting/stopping a scan session, and displays the raw tag data as JSON.

**Prerequisites**
- Flutter SDK installed (tested with Flutter 3.x and Dart 3.x).
- An Android device with NFC support (C7) running Android 6.0. If your device is a UHF-only reader (vendor-specific), see the notes below.
- USB debugging enabled and the device connected to your development machine, or build an APK and install it on the device.

**Quick start**

1. Install dependencies:

```bash
flutter pub get
```

2. Run the app on a connected device:

```bash
flutter run
```

Or build an APK and install it manually:

```bash
flutter build apk --release
# then install the generated APK from build/app/outputs/flutter-apk/app-release.apk
```

**How to test NFC**
- Ensure NFC is enabled in Android Settings on the device.
- Open the app; it will show `NFC available: Yes` if the device supports NFC and it is enabled.
- Tap `Start Scan` and bring an NFC tag close to the device's reader area. The app will display the raw tag contents as JSON.
- Tap `Stop` to halt the current session.

**Notes on Android 6.0**
- The `NFC` permission is a normal permission; no runtime permission prompt is required. The app already declares the permission in `android/app/src/main/AndroidManifest.xml`.
- The `nfc_manager` plugin handles starting and stopping NFC sessions using Android foreground dispatch / NFC Reader API.

**UHF / Vendor SDKs**
If your C7 device is a UHF RFID reader that does not expose standard Android NFC APIs, this app will not be able to read UHF tags. In that case you will need a vendor SDK (usually provided as an Android `.aar` or `.jar`) and platform channel code that calls into the SDK from Flutter. If you have the vendor SDK and documentation, provide them and I can add a platform integration.

**Files changed**
- `pubspec.yaml` (added `nfc_manager` dependency and updated description)
- `android/app/src/main/AndroidManifest.xml` (added NFC permission and feature declaration)
- `lib/main.dart` (simple NFC scanning UI)

**Next steps I can do for you**
- Add NDEF decoding and a friendlier UI (show tag UID, NDEF records parsed into readable strings).
- Persist scanned tags to a local database (SQLite) or export CSV.
- If your device requires a vendor SDK (UHF), integrate the SDK and expose functions through a Flutter `MethodChannel`.

If you want any of those, tell me which and I will implement it next.
