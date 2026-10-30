import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// The single owner profile (row id 1). Null until onboarding creates it.
class ProfileRepository {
  ProfileRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$ProfileTable, ProfileRow> get _row =>
      _db.select(_db.profile)..where((p) => p.id.equals(1));

  Stream<ProfileRow?> watch() => _row.watchSingleOrNull();

  Future<ProfileRow?> get() => _row.getSingleOrNull();

  /// Creates or replaces the profile.
  Future<void> save(ProfileCompanion profile) => _db
      .into(_db.profile)
      .insertOnConflictUpdate(profile.copyWith(id: const Value(1)));

  Future<void> setOnboardingDone() =>
      (_db.update(_db.profile)..where((p) => p.id.equals(1))).write(
        const ProfileCompanion(onboardingDone: Value(true)),
      );

  Future<void> setAcademicYearLabel(String label) =>
      (_db.update(_db.profile)..where((p) => p.id.equals(1))).write(
        ProfileCompanion(academicYearLabel: Value(label)),
      );

  Future<void> setSubmissionDate(String? date) =>
      (_db.update(_db.profile)..where((p) => p.id.equals(1))).write(
        ProfileCompanion(submissionDate: Value(date)),
      );
}
