import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// Evidence photos attached to entries (file paths only; the files live in
/// the app's documents folder).
class PhotosRepository {
  PhotosRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  Stream<List<EntryPhoto>> watchForEntry(String entryId) =>
      (_db.select(_db.entryPhotos)
            ..where((p) => p.entryId.equals(entryId))
            ..orderBy([(p) => OrderingTerm.asc(p.createdAt)]))
          .watch();

  Future<int> add(String entryId, String filePath) => _db
      .into(_db.entryPhotos)
      .insert(
        EntryPhotosCompanion.insert(
          entryId: entryId,
          filePath: filePath,
          createdAt: _now(),
        ),
      );

  /// Number of photos per entry, for the evidence log.
  Future<Map<String, int>> countsByEntry() async {
    final rows = await _db.select(_db.entryPhotos).get();
    final counts = <String, int>{};
    for (final row in rows) {
      counts.update(row.entryId, (n) => n + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  Future<void> remove(int id) =>
      (_db.delete(_db.entryPhotos)..where((p) => p.id.equals(id))).go();
}
