import 'package:drift/drift.dart';

import '../../domain/rates.dart';
import '../db/app_database.dart';

/// Rates imported from Admin_Config. With nothing stored yet, every rate is
/// its SPEC §3.1 default.
class RatesRepository {
  RatesRepository(this._db);

  final AppDatabase _db;

  Stream<RateSet> watchRateSet() =>
      _db.select(_db.rates).watch().map(_toRateSet);

  Future<RateSet> getRateSet() => _db.select(_db.rates).get().then(_toRateSet);

  /// Rows stored as defaults are left out so [RateSet.isDefault] reports them.
  static RateSet _toRateSet(List<RateRow> rows) => RateSet.from({
    for (final row in rows)
      if (!row.isDefault) row.key: row.hours,
  });

  /// Replaces all stored rates with [rates].
  Future<void> replaceAll(RateSet rates) => _db.transaction(() async {
    await _db.delete(_db.rates).go();
    await _db.batch((b) {
      b.insertAll(_db.rates, [
        for (final key in RateKey.values)
          RatesCompanion.insert(
            key: key,
            label: key.label,
            hours: rates.hours(key),
            sourceCell: Value(key.sourceCell),
            isDefault: Value(rates.isDefault(key)),
          ),
      ]);
    });
  });
}
