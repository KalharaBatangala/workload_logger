import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/providers.dart';

/// Thursday 29 October 2026, 9:40 pm — the date shown in the designs.
final testNow = DateTime(2026, 10, 29, 21, 40);
const testToday = '2026-10-29';

AppDatabase openTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

/// A container whose providers use [db] and the fixed [testNow] clock.
ProviderContainer testContainer(AppDatabase db, {DateTime? now}) =>
    ProviderContainer.test(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now ?? testNow),
      ],
    );

/// Lets drift's query streams and dependent providers catch up after a write.
Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 50));

extension ReadNow on ProviderContainer {
  /// Reads an async provider's value. Riverpod 3 pauses providers that
  /// nobody listens to, so listen for the duration of the read (as a screen
  /// would with `ref.watch`).
  ///
  /// Caveat: a provider read earlier and then paused may return its old
  /// value. After writes, either keep a listener open (see `settle`) or read
  /// the repository directly.
  Future<T> readNow<T>(ProviderListenable<Future<T>> provider) async {
    final sub = listen(provider, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }
}
