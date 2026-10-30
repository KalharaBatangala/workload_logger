import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // The bundled font's licence (SIL OFL) appears under Setup → About.
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Plus Jakarta Sans'], text);
  });
  // Reminders (notifications, timezone) start inside App once the first
  // frame is shown (SPEC §9).
  runApp(const ProviderScope(child: App()));
}
