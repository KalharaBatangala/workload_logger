import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // Timezone and notification setup is added in M8 (SPEC §9).
  runApp(const ProviderScope(child: App()));
}
