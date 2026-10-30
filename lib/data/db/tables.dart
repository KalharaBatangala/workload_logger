// Drift table definitions (SPEC §6).
//
// Conventions: enums are stored as their Dart `name`; calendar dates as TEXT
// `yyyy-MM-dd`; clock times as TEXT `HH:mm`; timestamps as DateTime.
// `isDemo` marks demo data so it can be removed from Setup.

import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../../domain/rates.dart';

/// The single owner profile (id is always 1).
@DataClassName('ProfileRow')
class Profile extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get staffName => text()();
  TextColumn get displayName => text()();
  TextColumn get academicYearLabel => text()();
  TextColumn get workbookFileName => text().nullable()();
  DateTimeColumn get importedAt => dateTime().nullable()();
  TextColumn get submissionDate => text().nullable()();
  BoolColumn get onboardingDone =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Rates from Admin_Config (SPEC §3.1).
@DataClassName('RateRow')
class Rates extends Table {
  TextColumn get key => textEnum<RateKey>()();
  TextColumn get label => text()();
  RealColumn get hours => real()();
  TextColumn get sourceCell => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {key};
}

/// The owner's Data_Entry rows (SPEC §3.3).
@DataClassName('RoleRow')
class RoleRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get moduleCode => text()();
  TextColumn get batch => text()();
  TextColumn get moduleName => text()();
  TextColumn get moduleType => textEnum<ModuleType>()();
  RealColumn get credits => real().withDefault(const Constant(0))();
  IntColumn get students => integer().withDefault(const Constant(0))();
  TextColumn get role => textEnum<Role>()();

  /// Row in the source workbook; also the export order.
  IntColumn get sheetRow => integer().nullable()();

  /// False once a re-import no longer contains this row (SPEC §7.2).
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {moduleCode, batch, role},
  ];
}

/// Logged work (SPEC §6). Stores counts only, never credited hours.
@DataClassName('EntryRow')
@TableIndex(name: 'entries_date', columns: {#date})
@TableIndex(name: 'entries_role_row', columns: {#roleRowId})
@TableIndex(name: 'entries_status', columns: {#status})
class Entries extends Table {
  TextColumn get id => text()();

  /// Null only for drafts that have no module yet.
  IntColumn get roleRowId => integer().nullable().references(RoleRows, #id)();
  TextColumn get date => text()();
  TextColumn get activity => textEnum<Activity>()();
  TextColumn get subtype => textEnum<Subtype>().nullable()();
  RealColumn get count => real().nullable()();

  /// REAL so fractional opening balances (weighted Qs/paper) survive import.
  RealColumn get questionsPerPaper => real().nullable()();

  /// Private; never feeds any credited total.
  IntColumn get spentMinutes => integer().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get status => textEnum<EntryStatus>()();
  TextColumn get source => textEnum<EntrySource>()();
  TextColumn get rawText => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EntryPhoto')
class EntryPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entryId =>
      text().references(Entries, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Work outside the workload model (never credited).
@DataClassName('OtherWorkRow')
class OtherWork extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  IntColumn get categoryId => integer().references(OtherCategories, #id)();
  IntColumn get spentMinutes => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OtherCategory')
class OtherCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer()();
}

@DataClassName('TimetableSlot')
class TimetableSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get roleRowId =>
      integer().references(RoleRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => textEnum<SlotKind>()();

  /// 1 = Monday … 7 = Sunday (Dart's DateTime.weekday).
  IntColumn get weekday => integer()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();
}

@DataClassName('ReminderSetting')
class ReminderSettings extends Table {
  TextColumn get key => textEnum<ReminderKind>()();
  BoolColumn get enabled => boolean()();
  TextColumn get time => text()();

  /// Weekly reminder only; 1 = Monday … 7 = Sunday.
  IntColumn get weekday => integer().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('DayReview')
class DayReviews extends Table {
  TextColumn get date => text()();
  TextColumn get status => textEnum<DayReviewStatus>()();

  @override
  Set<Column> get primaryKey => {date};
}

@DataClassName('PgSupervisionRow')
class PgSupervision extends Table {
  TextColumn get academicYearLabel => text()();
  IntColumn get students => integer()();

  @override
  Set<Column> get primaryKey => {academicYearLabel};
}

/// Reporting periods. Closing one (lockedAt) makes its entries read-only.
@DataClassName('Period')
class Periods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text()();
  DateTimeColumn get lockedAt => dateTime().nullable()();
}
