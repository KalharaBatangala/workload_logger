// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfileTable extends Profile with TableInfo<$ProfileTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _staffNameMeta = const VerificationMeta(
    'staffName',
  );
  @override
  late final GeneratedColumn<String> staffName = GeneratedColumn<String>(
    'staff_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _academicYearLabelMeta = const VerificationMeta(
    'academicYearLabel',
  );
  @override
  late final GeneratedColumn<String> academicYearLabel =
      GeneratedColumn<String>(
        'academic_year_label',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _workbookFileNameMeta = const VerificationMeta(
    'workbookFileName',
  );
  @override
  late final GeneratedColumn<String> workbookFileName = GeneratedColumn<String>(
    'workbook_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _submissionDateMeta = const VerificationMeta(
    'submissionDate',
  );
  @override
  late final GeneratedColumn<String> submissionDate = GeneratedColumn<String>(
    'submission_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingDoneMeta = const VerificationMeta(
    'onboardingDone',
  );
  @override
  late final GeneratedColumn<bool> onboardingDone = GeneratedColumn<bool>(
    'onboarding_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    staffName,
    displayName,
    academicYearLabel,
    workbookFileName,
    importedAt,
    submissionDate,
    onboardingDone,
    isDemo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_name')) {
      context.handle(
        _staffNameMeta,
        staffName.isAcceptableOrUnknown(data['staff_name']!, _staffNameMeta),
      );
    } else if (isInserting) {
      context.missing(_staffNameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('academic_year_label')) {
      context.handle(
        _academicYearLabelMeta,
        academicYearLabel.isAcceptableOrUnknown(
          data['academic_year_label']!,
          _academicYearLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_academicYearLabelMeta);
    }
    if (data.containsKey('workbook_file_name')) {
      context.handle(
        _workbookFileNameMeta,
        workbookFileName.isAcceptableOrUnknown(
          data['workbook_file_name']!,
          _workbookFileNameMeta,
        ),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    }
    if (data.containsKey('submission_date')) {
      context.handle(
        _submissionDateMeta,
        submissionDate.isAcceptableOrUnknown(
          data['submission_date']!,
          _submissionDateMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_done')) {
      context.handle(
        _onboardingDoneMeta,
        onboardingDone.isAcceptableOrUnknown(
          data['onboarding_done']!,
          _onboardingDoneMeta,
        ),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      staffName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_name'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      academicYearLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_year_label'],
      )!,
      workbookFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workbook_file_name'],
      ),
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      ),
      submissionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}submission_date'],
      ),
      onboardingDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_done'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
    );
  }

  @override
  $ProfileTable createAlias(String alias) {
    return $ProfileTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final String staffName;
  final String displayName;
  final String academicYearLabel;
  final String? workbookFileName;
  final DateTime? importedAt;
  final String? submissionDate;
  final bool onboardingDone;
  final bool isDemo;
  const ProfileRow({
    required this.id,
    required this.staffName,
    required this.displayName,
    required this.academicYearLabel,
    this.workbookFileName,
    this.importedAt,
    this.submissionDate,
    required this.onboardingDone,
    required this.isDemo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['staff_name'] = Variable<String>(staffName);
    map['display_name'] = Variable<String>(displayName);
    map['academic_year_label'] = Variable<String>(academicYearLabel);
    if (!nullToAbsent || workbookFileName != null) {
      map['workbook_file_name'] = Variable<String>(workbookFileName);
    }
    if (!nullToAbsent || importedAt != null) {
      map['imported_at'] = Variable<DateTime>(importedAt);
    }
    if (!nullToAbsent || submissionDate != null) {
      map['submission_date'] = Variable<String>(submissionDate);
    }
    map['onboarding_done'] = Variable<bool>(onboardingDone);
    map['is_demo'] = Variable<bool>(isDemo);
    return map;
  }

  ProfileCompanion toCompanion(bool nullToAbsent) {
    return ProfileCompanion(
      id: Value(id),
      staffName: Value(staffName),
      displayName: Value(displayName),
      academicYearLabel: Value(academicYearLabel),
      workbookFileName: workbookFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(workbookFileName),
      importedAt: importedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(importedAt),
      submissionDate: submissionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(submissionDate),
      onboardingDone: Value(onboardingDone),
      isDemo: Value(isDemo),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      staffName: serializer.fromJson<String>(json['staffName']),
      displayName: serializer.fromJson<String>(json['displayName']),
      academicYearLabel: serializer.fromJson<String>(json['academicYearLabel']),
      workbookFileName: serializer.fromJson<String?>(json['workbookFileName']),
      importedAt: serializer.fromJson<DateTime?>(json['importedAt']),
      submissionDate: serializer.fromJson<String?>(json['submissionDate']),
      onboardingDone: serializer.fromJson<bool>(json['onboardingDone']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffName': serializer.toJson<String>(staffName),
      'displayName': serializer.toJson<String>(displayName),
      'academicYearLabel': serializer.toJson<String>(academicYearLabel),
      'workbookFileName': serializer.toJson<String?>(workbookFileName),
      'importedAt': serializer.toJson<DateTime?>(importedAt),
      'submissionDate': serializer.toJson<String?>(submissionDate),
      'onboardingDone': serializer.toJson<bool>(onboardingDone),
      'isDemo': serializer.toJson<bool>(isDemo),
    };
  }

  ProfileRow copyWith({
    int? id,
    String? staffName,
    String? displayName,
    String? academicYearLabel,
    Value<String?> workbookFileName = const Value.absent(),
    Value<DateTime?> importedAt = const Value.absent(),
    Value<String?> submissionDate = const Value.absent(),
    bool? onboardingDone,
    bool? isDemo,
  }) => ProfileRow(
    id: id ?? this.id,
    staffName: staffName ?? this.staffName,
    displayName: displayName ?? this.displayName,
    academicYearLabel: academicYearLabel ?? this.academicYearLabel,
    workbookFileName: workbookFileName.present
        ? workbookFileName.value
        : this.workbookFileName,
    importedAt: importedAt.present ? importedAt.value : this.importedAt,
    submissionDate: submissionDate.present
        ? submissionDate.value
        : this.submissionDate,
    onboardingDone: onboardingDone ?? this.onboardingDone,
    isDemo: isDemo ?? this.isDemo,
  );
  ProfileRow copyWithCompanion(ProfileCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      staffName: data.staffName.present ? data.staffName.value : this.staffName,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      academicYearLabel: data.academicYearLabel.present
          ? data.academicYearLabel.value
          : this.academicYearLabel,
      workbookFileName: data.workbookFileName.present
          ? data.workbookFileName.value
          : this.workbookFileName,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      submissionDate: data.submissionDate.present
          ? data.submissionDate.value
          : this.submissionDate,
      onboardingDone: data.onboardingDone.present
          ? data.onboardingDone.value
          : this.onboardingDone,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('staffName: $staffName, ')
          ..write('displayName: $displayName, ')
          ..write('academicYearLabel: $academicYearLabel, ')
          ..write('workbookFileName: $workbookFileName, ')
          ..write('importedAt: $importedAt, ')
          ..write('submissionDate: $submissionDate, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    staffName,
    displayName,
    academicYearLabel,
    workbookFileName,
    importedAt,
    submissionDate,
    onboardingDone,
    isDemo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.staffName == this.staffName &&
          other.displayName == this.displayName &&
          other.academicYearLabel == this.academicYearLabel &&
          other.workbookFileName == this.workbookFileName &&
          other.importedAt == this.importedAt &&
          other.submissionDate == this.submissionDate &&
          other.onboardingDone == this.onboardingDone &&
          other.isDemo == this.isDemo);
}

class ProfileCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<String> staffName;
  final Value<String> displayName;
  final Value<String> academicYearLabel;
  final Value<String?> workbookFileName;
  final Value<DateTime?> importedAt;
  final Value<String?> submissionDate;
  final Value<bool> onboardingDone;
  final Value<bool> isDemo;
  const ProfileCompanion({
    this.id = const Value.absent(),
    this.staffName = const Value.absent(),
    this.displayName = const Value.absent(),
    this.academicYearLabel = const Value.absent(),
    this.workbookFileName = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.submissionDate = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    this.isDemo = const Value.absent(),
  });
  ProfileCompanion.insert({
    this.id = const Value.absent(),
    required String staffName,
    required String displayName,
    required String academicYearLabel,
    this.workbookFileName = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.submissionDate = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    this.isDemo = const Value.absent(),
  }) : staffName = Value(staffName),
       displayName = Value(displayName),
       academicYearLabel = Value(academicYearLabel);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<String>? staffName,
    Expression<String>? displayName,
    Expression<String>? academicYearLabel,
    Expression<String>? workbookFileName,
    Expression<DateTime>? importedAt,
    Expression<String>? submissionDate,
    Expression<bool>? onboardingDone,
    Expression<bool>? isDemo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffName != null) 'staff_name': staffName,
      if (displayName != null) 'display_name': displayName,
      if (academicYearLabel != null) 'academic_year_label': academicYearLabel,
      if (workbookFileName != null) 'workbook_file_name': workbookFileName,
      if (importedAt != null) 'imported_at': importedAt,
      if (submissionDate != null) 'submission_date': submissionDate,
      if (onboardingDone != null) 'onboarding_done': onboardingDone,
      if (isDemo != null) 'is_demo': isDemo,
    });
  }

  ProfileCompanion copyWith({
    Value<int>? id,
    Value<String>? staffName,
    Value<String>? displayName,
    Value<String>? academicYearLabel,
    Value<String?>? workbookFileName,
    Value<DateTime?>? importedAt,
    Value<String?>? submissionDate,
    Value<bool>? onboardingDone,
    Value<bool>? isDemo,
  }) {
    return ProfileCompanion(
      id: id ?? this.id,
      staffName: staffName ?? this.staffName,
      displayName: displayName ?? this.displayName,
      academicYearLabel: academicYearLabel ?? this.academicYearLabel,
      workbookFileName: workbookFileName ?? this.workbookFileName,
      importedAt: importedAt ?? this.importedAt,
      submissionDate: submissionDate ?? this.submissionDate,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      isDemo: isDemo ?? this.isDemo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffName.present) {
      map['staff_name'] = Variable<String>(staffName.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (academicYearLabel.present) {
      map['academic_year_label'] = Variable<String>(academicYearLabel.value);
    }
    if (workbookFileName.present) {
      map['workbook_file_name'] = Variable<String>(workbookFileName.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (submissionDate.present) {
      map['submission_date'] = Variable<String>(submissionDate.value);
    }
    if (onboardingDone.present) {
      map['onboarding_done'] = Variable<bool>(onboardingDone.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileCompanion(')
          ..write('id: $id, ')
          ..write('staffName: $staffName, ')
          ..write('displayName: $displayName, ')
          ..write('academicYearLabel: $academicYearLabel, ')
          ..write('workbookFileName: $workbookFileName, ')
          ..write('importedAt: $importedAt, ')
          ..write('submissionDate: $submissionDate, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }
}

class $RatesTable extends Rates with TableInfo<$RatesTable, RateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RatesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<RateKey, String> key =
      GeneratedColumn<String>(
        'key',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RateKey>($RatesTable.$converterkey);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<double> hours = GeneratedColumn<double>(
    'hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceCellMeta = const VerificationMeta(
    'sourceCell',
  );
  @override
  late final GeneratedColumn<String> sourceCell = GeneratedColumn<String>(
    'source_cell',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    label,
    hours,
    sourceCell,
    isDefault,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<RateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(
        _hoursMeta,
        hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta),
      );
    } else if (isInserting) {
      context.missing(_hoursMeta);
    }
    if (data.containsKey('source_cell')) {
      context.handle(
        _sourceCellMeta,
        sourceCell.isAcceptableOrUnknown(data['source_cell']!, _sourceCellMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  RateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RateRow(
      key: $RatesTable.$converterkey.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}key'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      hours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hours'],
      )!,
      sourceCell: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_cell'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
    );
  }

  @override
  $RatesTable createAlias(String alias) {
    return $RatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RateKey, String, String> $converterkey =
      const EnumNameConverter<RateKey>(RateKey.values);
}

class RateRow extends DataClass implements Insertable<RateRow> {
  final RateKey key;
  final String label;
  final double hours;
  final String? sourceCell;
  final bool isDefault;
  const RateRow({
    required this.key,
    required this.label,
    required this.hours,
    this.sourceCell,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['key'] = Variable<String>($RatesTable.$converterkey.toSql(key));
    }
    map['label'] = Variable<String>(label);
    map['hours'] = Variable<double>(hours);
    if (!nullToAbsent || sourceCell != null) {
      map['source_cell'] = Variable<String>(sourceCell);
    }
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  RatesCompanion toCompanion(bool nullToAbsent) {
    return RatesCompanion(
      key: Value(key),
      label: Value(label),
      hours: Value(hours),
      sourceCell: sourceCell == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceCell),
      isDefault: Value(isDefault),
    );
  }

  factory RateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RateRow(
      key: $RatesTable.$converterkey.fromJson(
        serializer.fromJson<String>(json['key']),
      ),
      label: serializer.fromJson<String>(json['label']),
      hours: serializer.fromJson<double>(json['hours']),
      sourceCell: serializer.fromJson<String?>(json['sourceCell']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>($RatesTable.$converterkey.toJson(key)),
      'label': serializer.toJson<String>(label),
      'hours': serializer.toJson<double>(hours),
      'sourceCell': serializer.toJson<String?>(sourceCell),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  RateRow copyWith({
    RateKey? key,
    String? label,
    double? hours,
    Value<String?> sourceCell = const Value.absent(),
    bool? isDefault,
  }) => RateRow(
    key: key ?? this.key,
    label: label ?? this.label,
    hours: hours ?? this.hours,
    sourceCell: sourceCell.present ? sourceCell.value : this.sourceCell,
    isDefault: isDefault ?? this.isDefault,
  );
  RateRow copyWithCompanion(RatesCompanion data) {
    return RateRow(
      key: data.key.present ? data.key.value : this.key,
      label: data.label.present ? data.label.value : this.label,
      hours: data.hours.present ? data.hours.value : this.hours,
      sourceCell: data.sourceCell.present
          ? data.sourceCell.value
          : this.sourceCell,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RateRow(')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('hours: $hours, ')
          ..write('sourceCell: $sourceCell, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, label, hours, sourceCell, isDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RateRow &&
          other.key == this.key &&
          other.label == this.label &&
          other.hours == this.hours &&
          other.sourceCell == this.sourceCell &&
          other.isDefault == this.isDefault);
}

class RatesCompanion extends UpdateCompanion<RateRow> {
  final Value<RateKey> key;
  final Value<String> label;
  final Value<double> hours;
  final Value<String?> sourceCell;
  final Value<bool> isDefault;
  final Value<int> rowid;
  const RatesCompanion({
    this.key = const Value.absent(),
    this.label = const Value.absent(),
    this.hours = const Value.absent(),
    this.sourceCell = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RatesCompanion.insert({
    required RateKey key,
    required String label,
    required double hours,
    this.sourceCell = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       label = Value(label),
       hours = Value(hours);
  static Insertable<RateRow> custom({
    Expression<String>? key,
    Expression<String>? label,
    Expression<double>? hours,
    Expression<String>? sourceCell,
    Expression<bool>? isDefault,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (label != null) 'label': label,
      if (hours != null) 'hours': hours,
      if (sourceCell != null) 'source_cell': sourceCell,
      if (isDefault != null) 'is_default': isDefault,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RatesCompanion copyWith({
    Value<RateKey>? key,
    Value<String>? label,
    Value<double>? hours,
    Value<String?>? sourceCell,
    Value<bool>? isDefault,
    Value<int>? rowid,
  }) {
    return RatesCompanion(
      key: key ?? this.key,
      label: label ?? this.label,
      hours: hours ?? this.hours,
      sourceCell: sourceCell ?? this.sourceCell,
      isDefault: isDefault ?? this.isDefault,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>($RatesTable.$converterkey.toSql(key.value));
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (hours.present) {
      map['hours'] = Variable<double>(hours.value);
    }
    if (sourceCell.present) {
      map['source_cell'] = Variable<String>(sourceCell.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RatesCompanion(')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('hours: $hours, ')
          ..write('sourceCell: $sourceCell, ')
          ..write('isDefault: $isDefault, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoleRowsTable extends RoleRows with TableInfo<$RoleRowsTable, RoleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoleRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moduleCodeMeta = const VerificationMeta(
    'moduleCode',
  );
  @override
  late final GeneratedColumn<String> moduleCode = GeneratedColumn<String>(
    'module_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchMeta = const VerificationMeta('batch');
  @override
  late final GeneratedColumn<String> batch = GeneratedColumn<String>(
    'batch',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleNameMeta = const VerificationMeta(
    'moduleName',
  );
  @override
  late final GeneratedColumn<String> moduleName = GeneratedColumn<String>(
    'module_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ModuleType, String> moduleType =
      GeneratedColumn<String>(
        'module_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ModuleType>($RoleRowsTable.$convertermoduleType);
  static const VerificationMeta _creditsMeta = const VerificationMeta(
    'credits',
  );
  @override
  late final GeneratedColumn<double> credits = GeneratedColumn<double>(
    'credits',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _studentsMeta = const VerificationMeta(
    'students',
  );
  @override
  late final GeneratedColumn<int> students = GeneratedColumn<int>(
    'students',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Role, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Role>($RoleRowsTable.$converterrole);
  static const VerificationMeta _sheetRowMeta = const VerificationMeta(
    'sheetRow',
  );
  @override
  late final GeneratedColumn<int> sheetRow = GeneratedColumn<int>(
    'sheet_row',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    moduleCode,
    batch,
    moduleName,
    moduleType,
    credits,
    students,
    role,
    sheetRow,
    isActive,
    isDemo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'role_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('module_code')) {
      context.handle(
        _moduleCodeMeta,
        moduleCode.isAcceptableOrUnknown(data['module_code']!, _moduleCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleCodeMeta);
    }
    if (data.containsKey('batch')) {
      context.handle(
        _batchMeta,
        batch.isAcceptableOrUnknown(data['batch']!, _batchMeta),
      );
    } else if (isInserting) {
      context.missing(_batchMeta);
    }
    if (data.containsKey('module_name')) {
      context.handle(
        _moduleNameMeta,
        moduleName.isAcceptableOrUnknown(data['module_name']!, _moduleNameMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleNameMeta);
    }
    if (data.containsKey('credits')) {
      context.handle(
        _creditsMeta,
        credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta),
      );
    }
    if (data.containsKey('students')) {
      context.handle(
        _studentsMeta,
        students.isAcceptableOrUnknown(data['students']!, _studentsMeta),
      );
    }
    if (data.containsKey('sheet_row')) {
      context.handle(
        _sheetRowMeta,
        sheetRow.isAcceptableOrUnknown(data['sheet_row']!, _sheetRowMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {moduleCode, batch, role},
  ];
  @override
  RoleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      moduleCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_code'],
      )!,
      batch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch'],
      )!,
      moduleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_name'],
      )!,
      moduleType: $RoleRowsTable.$convertermoduleType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}module_type'],
        )!,
      ),
      credits: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credits'],
      )!,
      students: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}students'],
      )!,
      role: $RoleRowsTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      sheetRow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sheet_row'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
    );
  }

  @override
  $RoleRowsTable createAlias(String alias) {
    return $RoleRowsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ModuleType, String, String> $convertermoduleType =
      const EnumNameConverter<ModuleType>(ModuleType.values);
  static JsonTypeConverter2<Role, String, String> $converterrole =
      const EnumNameConverter<Role>(Role.values);
}

class RoleRow extends DataClass implements Insertable<RoleRow> {
  final int id;
  final String moduleCode;
  final String batch;
  final String moduleName;
  final ModuleType moduleType;
  final double credits;
  final int students;
  final Role role;

  /// Row in the source workbook; also the export order.
  final int? sheetRow;

  /// False once a re-import no longer contains this row (SPEC §7.2).
  final bool isActive;
  final bool isDemo;
  const RoleRow({
    required this.id,
    required this.moduleCode,
    required this.batch,
    required this.moduleName,
    required this.moduleType,
    required this.credits,
    required this.students,
    required this.role,
    this.sheetRow,
    required this.isActive,
    required this.isDemo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['module_code'] = Variable<String>(moduleCode);
    map['batch'] = Variable<String>(batch);
    map['module_name'] = Variable<String>(moduleName);
    {
      map['module_type'] = Variable<String>(
        $RoleRowsTable.$convertermoduleType.toSql(moduleType),
      );
    }
    map['credits'] = Variable<double>(credits);
    map['students'] = Variable<int>(students);
    {
      map['role'] = Variable<String>($RoleRowsTable.$converterrole.toSql(role));
    }
    if (!nullToAbsent || sheetRow != null) {
      map['sheet_row'] = Variable<int>(sheetRow);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_demo'] = Variable<bool>(isDemo);
    return map;
  }

  RoleRowsCompanion toCompanion(bool nullToAbsent) {
    return RoleRowsCompanion(
      id: Value(id),
      moduleCode: Value(moduleCode),
      batch: Value(batch),
      moduleName: Value(moduleName),
      moduleType: Value(moduleType),
      credits: Value(credits),
      students: Value(students),
      role: Value(role),
      sheetRow: sheetRow == null && nullToAbsent
          ? const Value.absent()
          : Value(sheetRow),
      isActive: Value(isActive),
      isDemo: Value(isDemo),
    );
  }

  factory RoleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoleRow(
      id: serializer.fromJson<int>(json['id']),
      moduleCode: serializer.fromJson<String>(json['moduleCode']),
      batch: serializer.fromJson<String>(json['batch']),
      moduleName: serializer.fromJson<String>(json['moduleName']),
      moduleType: $RoleRowsTable.$convertermoduleType.fromJson(
        serializer.fromJson<String>(json['moduleType']),
      ),
      credits: serializer.fromJson<double>(json['credits']),
      students: serializer.fromJson<int>(json['students']),
      role: $RoleRowsTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      sheetRow: serializer.fromJson<int?>(json['sheetRow']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'moduleCode': serializer.toJson<String>(moduleCode),
      'batch': serializer.toJson<String>(batch),
      'moduleName': serializer.toJson<String>(moduleName),
      'moduleType': serializer.toJson<String>(
        $RoleRowsTable.$convertermoduleType.toJson(moduleType),
      ),
      'credits': serializer.toJson<double>(credits),
      'students': serializer.toJson<int>(students),
      'role': serializer.toJson<String>(
        $RoleRowsTable.$converterrole.toJson(role),
      ),
      'sheetRow': serializer.toJson<int?>(sheetRow),
      'isActive': serializer.toJson<bool>(isActive),
      'isDemo': serializer.toJson<bool>(isDemo),
    };
  }

  RoleRow copyWith({
    int? id,
    String? moduleCode,
    String? batch,
    String? moduleName,
    ModuleType? moduleType,
    double? credits,
    int? students,
    Role? role,
    Value<int?> sheetRow = const Value.absent(),
    bool? isActive,
    bool? isDemo,
  }) => RoleRow(
    id: id ?? this.id,
    moduleCode: moduleCode ?? this.moduleCode,
    batch: batch ?? this.batch,
    moduleName: moduleName ?? this.moduleName,
    moduleType: moduleType ?? this.moduleType,
    credits: credits ?? this.credits,
    students: students ?? this.students,
    role: role ?? this.role,
    sheetRow: sheetRow.present ? sheetRow.value : this.sheetRow,
    isActive: isActive ?? this.isActive,
    isDemo: isDemo ?? this.isDemo,
  );
  RoleRow copyWithCompanion(RoleRowsCompanion data) {
    return RoleRow(
      id: data.id.present ? data.id.value : this.id,
      moduleCode: data.moduleCode.present
          ? data.moduleCode.value
          : this.moduleCode,
      batch: data.batch.present ? data.batch.value : this.batch,
      moduleName: data.moduleName.present
          ? data.moduleName.value
          : this.moduleName,
      moduleType: data.moduleType.present
          ? data.moduleType.value
          : this.moduleType,
      credits: data.credits.present ? data.credits.value : this.credits,
      students: data.students.present ? data.students.value : this.students,
      role: data.role.present ? data.role.value : this.role,
      sheetRow: data.sheetRow.present ? data.sheetRow.value : this.sheetRow,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoleRow(')
          ..write('id: $id, ')
          ..write('moduleCode: $moduleCode, ')
          ..write('batch: $batch, ')
          ..write('moduleName: $moduleName, ')
          ..write('moduleType: $moduleType, ')
          ..write('credits: $credits, ')
          ..write('students: $students, ')
          ..write('role: $role, ')
          ..write('sheetRow: $sheetRow, ')
          ..write('isActive: $isActive, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    moduleCode,
    batch,
    moduleName,
    moduleType,
    credits,
    students,
    role,
    sheetRow,
    isActive,
    isDemo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoleRow &&
          other.id == this.id &&
          other.moduleCode == this.moduleCode &&
          other.batch == this.batch &&
          other.moduleName == this.moduleName &&
          other.moduleType == this.moduleType &&
          other.credits == this.credits &&
          other.students == this.students &&
          other.role == this.role &&
          other.sheetRow == this.sheetRow &&
          other.isActive == this.isActive &&
          other.isDemo == this.isDemo);
}

class RoleRowsCompanion extends UpdateCompanion<RoleRow> {
  final Value<int> id;
  final Value<String> moduleCode;
  final Value<String> batch;
  final Value<String> moduleName;
  final Value<ModuleType> moduleType;
  final Value<double> credits;
  final Value<int> students;
  final Value<Role> role;
  final Value<int?> sheetRow;
  final Value<bool> isActive;
  final Value<bool> isDemo;
  const RoleRowsCompanion({
    this.id = const Value.absent(),
    this.moduleCode = const Value.absent(),
    this.batch = const Value.absent(),
    this.moduleName = const Value.absent(),
    this.moduleType = const Value.absent(),
    this.credits = const Value.absent(),
    this.students = const Value.absent(),
    this.role = const Value.absent(),
    this.sheetRow = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDemo = const Value.absent(),
  });
  RoleRowsCompanion.insert({
    this.id = const Value.absent(),
    required String moduleCode,
    required String batch,
    required String moduleName,
    required ModuleType moduleType,
    this.credits = const Value.absent(),
    this.students = const Value.absent(),
    required Role role,
    this.sheetRow = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDemo = const Value.absent(),
  }) : moduleCode = Value(moduleCode),
       batch = Value(batch),
       moduleName = Value(moduleName),
       moduleType = Value(moduleType),
       role = Value(role);
  static Insertable<RoleRow> custom({
    Expression<int>? id,
    Expression<String>? moduleCode,
    Expression<String>? batch,
    Expression<String>? moduleName,
    Expression<String>? moduleType,
    Expression<double>? credits,
    Expression<int>? students,
    Expression<String>? role,
    Expression<int>? sheetRow,
    Expression<bool>? isActive,
    Expression<bool>? isDemo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moduleCode != null) 'module_code': moduleCode,
      if (batch != null) 'batch': batch,
      if (moduleName != null) 'module_name': moduleName,
      if (moduleType != null) 'module_type': moduleType,
      if (credits != null) 'credits': credits,
      if (students != null) 'students': students,
      if (role != null) 'role': role,
      if (sheetRow != null) 'sheet_row': sheetRow,
      if (isActive != null) 'is_active': isActive,
      if (isDemo != null) 'is_demo': isDemo,
    });
  }

  RoleRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? moduleCode,
    Value<String>? batch,
    Value<String>? moduleName,
    Value<ModuleType>? moduleType,
    Value<double>? credits,
    Value<int>? students,
    Value<Role>? role,
    Value<int?>? sheetRow,
    Value<bool>? isActive,
    Value<bool>? isDemo,
  }) {
    return RoleRowsCompanion(
      id: id ?? this.id,
      moduleCode: moduleCode ?? this.moduleCode,
      batch: batch ?? this.batch,
      moduleName: moduleName ?? this.moduleName,
      moduleType: moduleType ?? this.moduleType,
      credits: credits ?? this.credits,
      students: students ?? this.students,
      role: role ?? this.role,
      sheetRow: sheetRow ?? this.sheetRow,
      isActive: isActive ?? this.isActive,
      isDemo: isDemo ?? this.isDemo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (moduleCode.present) {
      map['module_code'] = Variable<String>(moduleCode.value);
    }
    if (batch.present) {
      map['batch'] = Variable<String>(batch.value);
    }
    if (moduleName.present) {
      map['module_name'] = Variable<String>(moduleName.value);
    }
    if (moduleType.present) {
      map['module_type'] = Variable<String>(
        $RoleRowsTable.$convertermoduleType.toSql(moduleType.value),
      );
    }
    if (credits.present) {
      map['credits'] = Variable<double>(credits.value);
    }
    if (students.present) {
      map['students'] = Variable<int>(students.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $RoleRowsTable.$converterrole.toSql(role.value),
      );
    }
    if (sheetRow.present) {
      map['sheet_row'] = Variable<int>(sheetRow.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoleRowsCompanion(')
          ..write('id: $id, ')
          ..write('moduleCode: $moduleCode, ')
          ..write('batch: $batch, ')
          ..write('moduleName: $moduleName, ')
          ..write('moduleType: $moduleType, ')
          ..write('credits: $credits, ')
          ..write('students: $students, ')
          ..write('role: $role, ')
          ..write('sheetRow: $sheetRow, ')
          ..write('isActive: $isActive, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }
}

class $EntriesTable extends Entries with TableInfo<$EntriesTable, EntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleRowIdMeta = const VerificationMeta(
    'roleRowId',
  );
  @override
  late final GeneratedColumn<int> roleRowId = GeneratedColumn<int>(
    'role_row_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES role_rows (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Activity, String> activity =
      GeneratedColumn<String>(
        'activity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Activity>($EntriesTable.$converteractivity);
  @override
  late final GeneratedColumnWithTypeConverter<Subtype?, String> subtype =
      GeneratedColumn<String>(
        'subtype',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Subtype?>($EntriesTable.$convertersubtypen);
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<double> count = GeneratedColumn<double>(
    'count',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionsPerPaperMeta = const VerificationMeta(
    'questionsPerPaper',
  );
  @override
  late final GeneratedColumn<double> questionsPerPaper =
      GeneratedColumn<double>(
        'questions_per_paper',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _spentMinutesMeta = const VerificationMeta(
    'spentMinutes',
  );
  @override
  late final GeneratedColumn<int> spentMinutes = GeneratedColumn<int>(
    'spent_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EntryStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntryStatus>($EntriesTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<EntrySource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntrySource>($EntriesTable.$convertersource);
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roleRowId,
    date,
    activity,
    subtype,
    count,
    questionsPerPaper,
    spentMinutes,
    note,
    status,
    source,
    rawText,
    createdAt,
    updatedAt,
    deletedAt,
    isDemo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role_row_id')) {
      context.handle(
        _roleRowIdMeta,
        roleRowId.isAcceptableOrUnknown(data['role_row_id']!, _roleRowIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('questions_per_paper')) {
      context.handle(
        _questionsPerPaperMeta,
        questionsPerPaper.isAcceptableOrUnknown(
          data['questions_per_paper']!,
          _questionsPerPaperMeta,
        ),
      );
    }
    if (data.containsKey('spent_minutes')) {
      context.handle(
        _spentMinutesMeta,
        spentMinutes.isAcceptableOrUnknown(
          data['spent_minutes']!,
          _spentMinutesMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roleRowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}role_row_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      activity: $EntriesTable.$converteractivity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}activity'],
        )!,
      ),
      subtype: $EntriesTable.$convertersubtypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}subtype'],
        ),
      ),
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}count'],
      ),
      questionsPerPaper: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}questions_per_paper'],
      ),
      spentMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spent_minutes'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: $EntriesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      source: $EntriesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
    );
  }

  @override
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Activity, String, String> $converteractivity =
      const EnumNameConverter<Activity>(Activity.values);
  static JsonTypeConverter2<Subtype, String, String> $convertersubtype =
      const EnumNameConverter<Subtype>(Subtype.values);
  static JsonTypeConverter2<Subtype?, String?, String?> $convertersubtypen =
      JsonTypeConverter2.asNullable($convertersubtype);
  static JsonTypeConverter2<EntryStatus, String, String> $converterstatus =
      const EnumNameConverter<EntryStatus>(EntryStatus.values);
  static JsonTypeConverter2<EntrySource, String, String> $convertersource =
      const EnumNameConverter<EntrySource>(EntrySource.values);
}

class EntryRow extends DataClass implements Insertable<EntryRow> {
  final String id;

  /// Null only for drafts that have no module yet.
  final int? roleRowId;
  final String date;
  final Activity activity;
  final Subtype? subtype;
  final double? count;

  /// REAL so fractional opening balances (weighted Qs/paper) survive import.
  final double? questionsPerPaper;

  /// Private; never feeds any credited total.
  final int? spentMinutes;
  final String? note;
  final EntryStatus status;
  final EntrySource source;
  final String? rawText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isDemo;
  const EntryRow({
    required this.id,
    this.roleRowId,
    required this.date,
    required this.activity,
    this.subtype,
    this.count,
    this.questionsPerPaper,
    this.spentMinutes,
    this.note,
    required this.status,
    required this.source,
    this.rawText,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDemo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || roleRowId != null) {
      map['role_row_id'] = Variable<int>(roleRowId);
    }
    map['date'] = Variable<String>(date);
    {
      map['activity'] = Variable<String>(
        $EntriesTable.$converteractivity.toSql(activity),
      );
    }
    if (!nullToAbsent || subtype != null) {
      map['subtype'] = Variable<String>(
        $EntriesTable.$convertersubtypen.toSql(subtype),
      );
    }
    if (!nullToAbsent || count != null) {
      map['count'] = Variable<double>(count);
    }
    if (!nullToAbsent || questionsPerPaper != null) {
      map['questions_per_paper'] = Variable<double>(questionsPerPaper);
    }
    if (!nullToAbsent || spentMinutes != null) {
      map['spent_minutes'] = Variable<int>(spentMinutes);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['status'] = Variable<String>(
        $EntriesTable.$converterstatus.toSql(status),
      );
    }
    {
      map['source'] = Variable<String>(
        $EntriesTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || rawText != null) {
      map['raw_text'] = Variable<String>(rawText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['is_demo'] = Variable<bool>(isDemo);
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      roleRowId: roleRowId == null && nullToAbsent
          ? const Value.absent()
          : Value(roleRowId),
      date: Value(date),
      activity: Value(activity),
      subtype: subtype == null && nullToAbsent
          ? const Value.absent()
          : Value(subtype),
      count: count == null && nullToAbsent
          ? const Value.absent()
          : Value(count),
      questionsPerPaper: questionsPerPaper == null && nullToAbsent
          ? const Value.absent()
          : Value(questionsPerPaper),
      spentMinutes: spentMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(spentMinutes),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      source: Value(source),
      rawText: rawText == null && nullToAbsent
          ? const Value.absent()
          : Value(rawText),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      isDemo: Value(isDemo),
    );
  }

  factory EntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryRow(
      id: serializer.fromJson<String>(json['id']),
      roleRowId: serializer.fromJson<int?>(json['roleRowId']),
      date: serializer.fromJson<String>(json['date']),
      activity: $EntriesTable.$converteractivity.fromJson(
        serializer.fromJson<String>(json['activity']),
      ),
      subtype: $EntriesTable.$convertersubtypen.fromJson(
        serializer.fromJson<String?>(json['subtype']),
      ),
      count: serializer.fromJson<double?>(json['count']),
      questionsPerPaper: serializer.fromJson<double?>(
        json['questionsPerPaper'],
      ),
      spentMinutes: serializer.fromJson<int?>(json['spentMinutes']),
      note: serializer.fromJson<String?>(json['note']),
      status: $EntriesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      source: $EntriesTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      rawText: serializer.fromJson<String?>(json['rawText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roleRowId': serializer.toJson<int?>(roleRowId),
      'date': serializer.toJson<String>(date),
      'activity': serializer.toJson<String>(
        $EntriesTable.$converteractivity.toJson(activity),
      ),
      'subtype': serializer.toJson<String?>(
        $EntriesTable.$convertersubtypen.toJson(subtype),
      ),
      'count': serializer.toJson<double?>(count),
      'questionsPerPaper': serializer.toJson<double?>(questionsPerPaper),
      'spentMinutes': serializer.toJson<int?>(spentMinutes),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(
        $EntriesTable.$converterstatus.toJson(status),
      ),
      'source': serializer.toJson<String>(
        $EntriesTable.$convertersource.toJson(source),
      ),
      'rawText': serializer.toJson<String?>(rawText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'isDemo': serializer.toJson<bool>(isDemo),
    };
  }

  EntryRow copyWith({
    String? id,
    Value<int?> roleRowId = const Value.absent(),
    String? date,
    Activity? activity,
    Value<Subtype?> subtype = const Value.absent(),
    Value<double?> count = const Value.absent(),
    Value<double?> questionsPerPaper = const Value.absent(),
    Value<int?> spentMinutes = const Value.absent(),
    Value<String?> note = const Value.absent(),
    EntryStatus? status,
    EntrySource? source,
    Value<String?> rawText = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? isDemo,
  }) => EntryRow(
    id: id ?? this.id,
    roleRowId: roleRowId.present ? roleRowId.value : this.roleRowId,
    date: date ?? this.date,
    activity: activity ?? this.activity,
    subtype: subtype.present ? subtype.value : this.subtype,
    count: count.present ? count.value : this.count,
    questionsPerPaper: questionsPerPaper.present
        ? questionsPerPaper.value
        : this.questionsPerPaper,
    spentMinutes: spentMinutes.present ? spentMinutes.value : this.spentMinutes,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
    source: source ?? this.source,
    rawText: rawText.present ? rawText.value : this.rawText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isDemo: isDemo ?? this.isDemo,
  );
  EntryRow copyWithCompanion(EntriesCompanion data) {
    return EntryRow(
      id: data.id.present ? data.id.value : this.id,
      roleRowId: data.roleRowId.present ? data.roleRowId.value : this.roleRowId,
      date: data.date.present ? data.date.value : this.date,
      activity: data.activity.present ? data.activity.value : this.activity,
      subtype: data.subtype.present ? data.subtype.value : this.subtype,
      count: data.count.present ? data.count.value : this.count,
      questionsPerPaper: data.questionsPerPaper.present
          ? data.questionsPerPaper.value
          : this.questionsPerPaper,
      spentMinutes: data.spentMinutes.present
          ? data.spentMinutes.value
          : this.spentMinutes,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryRow(')
          ..write('id: $id, ')
          ..write('roleRowId: $roleRowId, ')
          ..write('date: $date, ')
          ..write('activity: $activity, ')
          ..write('subtype: $subtype, ')
          ..write('count: $count, ')
          ..write('questionsPerPaper: $questionsPerPaper, ')
          ..write('spentMinutes: $spentMinutes, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('rawText: $rawText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roleRowId,
    date,
    activity,
    subtype,
    count,
    questionsPerPaper,
    spentMinutes,
    note,
    status,
    source,
    rawText,
    createdAt,
    updatedAt,
    deletedAt,
    isDemo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryRow &&
          other.id == this.id &&
          other.roleRowId == this.roleRowId &&
          other.date == this.date &&
          other.activity == this.activity &&
          other.subtype == this.subtype &&
          other.count == this.count &&
          other.questionsPerPaper == this.questionsPerPaper &&
          other.spentMinutes == this.spentMinutes &&
          other.note == this.note &&
          other.status == this.status &&
          other.source == this.source &&
          other.rawText == this.rawText &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isDemo == this.isDemo);
}

class EntriesCompanion extends UpdateCompanion<EntryRow> {
  final Value<String> id;
  final Value<int?> roleRowId;
  final Value<String> date;
  final Value<Activity> activity;
  final Value<Subtype?> subtype;
  final Value<double?> count;
  final Value<double?> questionsPerPaper;
  final Value<int?> spentMinutes;
  final Value<String?> note;
  final Value<EntryStatus> status;
  final Value<EntrySource> source;
  final Value<String?> rawText;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> isDemo;
  final Value<int> rowid;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.roleRowId = const Value.absent(),
    this.date = const Value.absent(),
    this.activity = const Value.absent(),
    this.subtype = const Value.absent(),
    this.count = const Value.absent(),
    this.questionsPerPaper = const Value.absent(),
    this.spentMinutes = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.rawText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntriesCompanion.insert({
    required String id,
    this.roleRowId = const Value.absent(),
    required String date,
    required Activity activity,
    this.subtype = const Value.absent(),
    this.count = const Value.absent(),
    this.questionsPerPaper = const Value.absent(),
    this.spentMinutes = const Value.absent(),
    this.note = const Value.absent(),
    required EntryStatus status,
    required EntrySource source,
    this.rawText = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       activity = Value(activity),
       status = Value(status),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EntryRow> custom({
    Expression<String>? id,
    Expression<int>? roleRowId,
    Expression<String>? date,
    Expression<String>? activity,
    Expression<String>? subtype,
    Expression<double>? count,
    Expression<double>? questionsPerPaper,
    Expression<int>? spentMinutes,
    Expression<String>? note,
    Expression<String>? status,
    Expression<String>? source,
    Expression<String>? rawText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? isDemo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roleRowId != null) 'role_row_id': roleRowId,
      if (date != null) 'date': date,
      if (activity != null) 'activity': activity,
      if (subtype != null) 'subtype': subtype,
      if (count != null) 'count': count,
      if (questionsPerPaper != null) 'questions_per_paper': questionsPerPaper,
      if (spentMinutes != null) 'spent_minutes': spentMinutes,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (rawText != null) 'raw_text': rawText,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isDemo != null) 'is_demo': isDemo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntriesCompanion copyWith({
    Value<String>? id,
    Value<int?>? roleRowId,
    Value<String>? date,
    Value<Activity>? activity,
    Value<Subtype?>? subtype,
    Value<double?>? count,
    Value<double?>? questionsPerPaper,
    Value<int?>? spentMinutes,
    Value<String?>? note,
    Value<EntryStatus>? status,
    Value<EntrySource>? source,
    Value<String?>? rawText,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<bool>? isDemo,
    Value<int>? rowid,
  }) {
    return EntriesCompanion(
      id: id ?? this.id,
      roleRowId: roleRowId ?? this.roleRowId,
      date: date ?? this.date,
      activity: activity ?? this.activity,
      subtype: subtype ?? this.subtype,
      count: count ?? this.count,
      questionsPerPaper: questionsPerPaper ?? this.questionsPerPaper,
      spentMinutes: spentMinutes ?? this.spentMinutes,
      note: note ?? this.note,
      status: status ?? this.status,
      source: source ?? this.source,
      rawText: rawText ?? this.rawText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDemo: isDemo ?? this.isDemo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roleRowId.present) {
      map['role_row_id'] = Variable<int>(roleRowId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(
        $EntriesTable.$converteractivity.toSql(activity.value),
      );
    }
    if (subtype.present) {
      map['subtype'] = Variable<String>(
        $EntriesTable.$convertersubtypen.toSql(subtype.value),
      );
    }
    if (count.present) {
      map['count'] = Variable<double>(count.value);
    }
    if (questionsPerPaper.present) {
      map['questions_per_paper'] = Variable<double>(questionsPerPaper.value);
    }
    if (spentMinutes.present) {
      map['spent_minutes'] = Variable<int>(spentMinutes.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $EntriesTable.$converterstatus.toSql(status.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $EntriesTable.$convertersource.toSql(source.value),
      );
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('roleRowId: $roleRowId, ')
          ..write('date: $date, ')
          ..write('activity: $activity, ')
          ..write('subtype: $subtype, ')
          ..write('count: $count, ')
          ..write('questionsPerPaper: $questionsPerPaper, ')
          ..write('spentMinutes: $spentMinutes, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('rawText: $rawText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntryPhotosTable extends EntryPhotos
    with TableInfo<$EntryPhotosTable, EntryPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntryPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, filePath, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntryPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EntryPhotosTable createAlias(String alias) {
    return $EntryPhotosTable(attachedDatabase, alias);
  }
}

class EntryPhoto extends DataClass implements Insertable<EntryPhoto> {
  final int id;
  final String entryId;
  final String filePath;
  final DateTime createdAt;
  const EntryPhoto({
    required this.id,
    required this.entryId,
    required this.filePath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entry_id'] = Variable<String>(entryId);
    map['file_path'] = Variable<String>(filePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EntryPhotosCompanion toCompanion(bool nullToAbsent) {
    return EntryPhotosCompanion(
      id: Value(id),
      entryId: Value(entryId),
      filePath: Value(filePath),
      createdAt: Value(createdAt),
    );
  }

  factory EntryPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryPhoto(
      id: serializer.fromJson<int>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entryId': serializer.toJson<String>(entryId),
      'filePath': serializer.toJson<String>(filePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EntryPhoto copyWith({
    int? id,
    String? entryId,
    String? filePath,
    DateTime? createdAt,
  }) => EntryPhoto(
    id: id ?? this.id,
    entryId: entryId ?? this.entryId,
    filePath: filePath ?? this.filePath,
    createdAt: createdAt ?? this.createdAt,
  );
  EntryPhoto copyWithCompanion(EntryPhotosCompanion data) {
    return EntryPhoto(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryPhoto(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entryId, filePath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryPhoto &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.filePath == this.filePath &&
          other.createdAt == this.createdAt);
}

class EntryPhotosCompanion extends UpdateCompanion<EntryPhoto> {
  final Value<int> id;
  final Value<String> entryId;
  final Value<String> filePath;
  final Value<DateTime> createdAt;
  const EntryPhotosCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EntryPhotosCompanion.insert({
    this.id = const Value.absent(),
    required String entryId,
    required String filePath,
    required DateTime createdAt,
  }) : entryId = Value(entryId),
       filePath = Value(filePath),
       createdAt = Value(createdAt);
  static Insertable<EntryPhoto> custom({
    Expression<int>? id,
    Expression<String>? entryId,
    Expression<String>? filePath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EntryPhotosCompanion copyWith({
    Value<int>? id,
    Value<String>? entryId,
    Value<String>? filePath,
    Value<DateTime>? createdAt,
  }) {
    return EntryPhotosCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryPhotosCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OtherCategoriesTable extends OtherCategories
    with TableInfo<$OtherCategoriesTable, OtherCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OtherCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'other_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<OtherCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OtherCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OtherCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $OtherCategoriesTable createAlias(String alias) {
    return $OtherCategoriesTable(attachedDatabase, alias);
  }
}

class OtherCategory extends DataClass implements Insertable<OtherCategory> {
  final int id;
  final String name;
  final int sortOrder;
  const OtherCategory({
    required this.id,
    required this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  OtherCategoriesCompanion toCompanion(bool nullToAbsent) {
    return OtherCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory OtherCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OtherCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  OtherCategory copyWith({int? id, String? name, int? sortOrder}) =>
      OtherCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  OtherCategory copyWithCompanion(OtherCategoriesCompanion data) {
    return OtherCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OtherCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OtherCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class OtherCategoriesCompanion extends UpdateCompanion<OtherCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  const OtherCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  OtherCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int sortOrder,
  }) : name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<OtherCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  OtherCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? sortOrder,
  }) {
    return OtherCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OtherCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $OtherWorkTable extends OtherWork
    with TableInfo<$OtherWorkTable, OtherWorkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OtherWorkTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES other_categories (id)',
    ),
  );
  static const VerificationMeta _spentMinutesMeta = const VerificationMeta(
    'spentMinutes',
  );
  @override
  late final GeneratedColumn<int> spentMinutes = GeneratedColumn<int>(
    'spent_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    categoryId,
    spentMinutes,
    note,
    createdAt,
    isDemo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'other_work';
  @override
  VerificationContext validateIntegrity(
    Insertable<OtherWorkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('spent_minutes')) {
      context.handle(
        _spentMinutesMeta,
        spentMinutes.isAcceptableOrUnknown(
          data['spent_minutes']!,
          _spentMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_spentMinutesMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OtherWorkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OtherWorkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      spentMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spent_minutes'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
    );
  }

  @override
  $OtherWorkTable createAlias(String alias) {
    return $OtherWorkTable(attachedDatabase, alias);
  }
}

class OtherWorkRow extends DataClass implements Insertable<OtherWorkRow> {
  final String id;
  final String date;
  final int categoryId;
  final int spentMinutes;
  final String? note;
  final DateTime createdAt;
  final bool isDemo;
  const OtherWorkRow({
    required this.id,
    required this.date,
    required this.categoryId,
    required this.spentMinutes,
    this.note,
    required this.createdAt,
    required this.isDemo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['category_id'] = Variable<int>(categoryId);
    map['spent_minutes'] = Variable<int>(spentMinutes);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_demo'] = Variable<bool>(isDemo);
    return map;
  }

  OtherWorkCompanion toCompanion(bool nullToAbsent) {
    return OtherWorkCompanion(
      id: Value(id),
      date: Value(date),
      categoryId: Value(categoryId),
      spentMinutes: Value(spentMinutes),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      isDemo: Value(isDemo),
    );
  }

  factory OtherWorkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OtherWorkRow(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      spentMinutes: serializer.fromJson<int>(json['spentMinutes']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'categoryId': serializer.toJson<int>(categoryId),
      'spentMinutes': serializer.toJson<int>(spentMinutes),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDemo': serializer.toJson<bool>(isDemo),
    };
  }

  OtherWorkRow copyWith({
    String? id,
    String? date,
    int? categoryId,
    int? spentMinutes,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    bool? isDemo,
  }) => OtherWorkRow(
    id: id ?? this.id,
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
    spentMinutes: spentMinutes ?? this.spentMinutes,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    isDemo: isDemo ?? this.isDemo,
  );
  OtherWorkRow copyWithCompanion(OtherWorkCompanion data) {
    return OtherWorkRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      spentMinutes: data.spentMinutes.present
          ? data.spentMinutes.value
          : this.spentMinutes,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OtherWorkRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('spentMinutes: $spentMinutes, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, categoryId, spentMinutes, note, createdAt, isDemo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OtherWorkRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.categoryId == this.categoryId &&
          other.spentMinutes == this.spentMinutes &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.isDemo == this.isDemo);
}

class OtherWorkCompanion extends UpdateCompanion<OtherWorkRow> {
  final Value<String> id;
  final Value<String> date;
  final Value<int> categoryId;
  final Value<int> spentMinutes;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<bool> isDemo;
  final Value<int> rowid;
  const OtherWorkCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.spentMinutes = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OtherWorkCompanion.insert({
    required String id,
    required String date,
    required int categoryId,
    required int spentMinutes,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.isDemo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       categoryId = Value(categoryId),
       spentMinutes = Value(spentMinutes),
       createdAt = Value(createdAt);
  static Insertable<OtherWorkRow> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<int>? categoryId,
    Expression<int>? spentMinutes,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDemo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (categoryId != null) 'category_id': categoryId,
      if (spentMinutes != null) 'spent_minutes': spentMinutes,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (isDemo != null) 'is_demo': isDemo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OtherWorkCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<int>? categoryId,
    Value<int>? spentMinutes,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<bool>? isDemo,
    Value<int>? rowid,
  }) {
    return OtherWorkCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      spentMinutes: spentMinutes ?? this.spentMinutes,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isDemo: isDemo ?? this.isDemo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (spentMinutes.present) {
      map['spent_minutes'] = Variable<int>(spentMinutes.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OtherWorkCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('spentMinutes: $spentMinutes, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimetableSlotsTable extends TimetableSlots
    with TableInfo<$TimetableSlotsTable, TimetableSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimetableSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roleRowIdMeta = const VerificationMeta(
    'roleRowId',
  );
  @override
  late final GeneratedColumn<int> roleRowId = GeneratedColumn<int>(
    'role_row_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES role_rows (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SlotKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SlotKind>($TimetableSlotsTable.$converterkind);
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roleRowId,
    kind,
    weekday,
    startTime,
    endTime,
    isDemo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timetable_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimetableSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('role_row_id')) {
      context.handle(
        _roleRowIdMeta,
        roleRowId.isAcceptableOrUnknown(data['role_row_id']!, _roleRowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roleRowIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimetableSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimetableSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      roleRowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}role_row_id'],
      )!,
      kind: $TimetableSlotsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
    );
  }

  @override
  $TimetableSlotsTable createAlias(String alias) {
    return $TimetableSlotsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SlotKind, String, String> $converterkind =
      const EnumNameConverter<SlotKind>(SlotKind.values);
}

class TimetableSlot extends DataClass implements Insertable<TimetableSlot> {
  final int id;
  final int roleRowId;
  final SlotKind kind;

  /// 1 = Monday … 7 = Sunday (Dart's DateTime.weekday).
  final int weekday;
  final String startTime;
  final String endTime;
  final bool isDemo;
  const TimetableSlot({
    required this.id,
    required this.roleRowId,
    required this.kind,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.isDemo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['role_row_id'] = Variable<int>(roleRowId);
    {
      map['kind'] = Variable<String>(
        $TimetableSlotsTable.$converterkind.toSql(kind),
      );
    }
    map['weekday'] = Variable<int>(weekday);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['is_demo'] = Variable<bool>(isDemo);
    return map;
  }

  TimetableSlotsCompanion toCompanion(bool nullToAbsent) {
    return TimetableSlotsCompanion(
      id: Value(id),
      roleRowId: Value(roleRowId),
      kind: Value(kind),
      weekday: Value(weekday),
      startTime: Value(startTime),
      endTime: Value(endTime),
      isDemo: Value(isDemo),
    );
  }

  factory TimetableSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimetableSlot(
      id: serializer.fromJson<int>(json['id']),
      roleRowId: serializer.fromJson<int>(json['roleRowId']),
      kind: $TimetableSlotsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      weekday: serializer.fromJson<int>(json['weekday']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roleRowId': serializer.toJson<int>(roleRowId),
      'kind': serializer.toJson<String>(
        $TimetableSlotsTable.$converterkind.toJson(kind),
      ),
      'weekday': serializer.toJson<int>(weekday),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'isDemo': serializer.toJson<bool>(isDemo),
    };
  }

  TimetableSlot copyWith({
    int? id,
    int? roleRowId,
    SlotKind? kind,
    int? weekday,
    String? startTime,
    String? endTime,
    bool? isDemo,
  }) => TimetableSlot(
    id: id ?? this.id,
    roleRowId: roleRowId ?? this.roleRowId,
    kind: kind ?? this.kind,
    weekday: weekday ?? this.weekday,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    isDemo: isDemo ?? this.isDemo,
  );
  TimetableSlot copyWithCompanion(TimetableSlotsCompanion data) {
    return TimetableSlot(
      id: data.id.present ? data.id.value : this.id,
      roleRowId: data.roleRowId.present ? data.roleRowId.value : this.roleRowId,
      kind: data.kind.present ? data.kind.value : this.kind,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimetableSlot(')
          ..write('id: $id, ')
          ..write('roleRowId: $roleRowId, ')
          ..write('kind: $kind, ')
          ..write('weekday: $weekday, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, roleRowId, kind, weekday, startTime, endTime, isDemo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimetableSlot &&
          other.id == this.id &&
          other.roleRowId == this.roleRowId &&
          other.kind == this.kind &&
          other.weekday == this.weekday &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.isDemo == this.isDemo);
}

class TimetableSlotsCompanion extends UpdateCompanion<TimetableSlot> {
  final Value<int> id;
  final Value<int> roleRowId;
  final Value<SlotKind> kind;
  final Value<int> weekday;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<bool> isDemo;
  const TimetableSlotsCompanion({
    this.id = const Value.absent(),
    this.roleRowId = const Value.absent(),
    this.kind = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isDemo = const Value.absent(),
  });
  TimetableSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int roleRowId,
    required SlotKind kind,
    required int weekday,
    required String startTime,
    required String endTime,
    this.isDemo = const Value.absent(),
  }) : roleRowId = Value(roleRowId),
       kind = Value(kind),
       weekday = Value(weekday),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<TimetableSlot> custom({
    Expression<int>? id,
    Expression<int>? roleRowId,
    Expression<String>? kind,
    Expression<int>? weekday,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<bool>? isDemo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roleRowId != null) 'role_row_id': roleRowId,
      if (kind != null) 'kind': kind,
      if (weekday != null) 'weekday': weekday,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (isDemo != null) 'is_demo': isDemo,
    });
  }

  TimetableSlotsCompanion copyWith({
    Value<int>? id,
    Value<int>? roleRowId,
    Value<SlotKind>? kind,
    Value<int>? weekday,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<bool>? isDemo,
  }) {
    return TimetableSlotsCompanion(
      id: id ?? this.id,
      roleRowId: roleRowId ?? this.roleRowId,
      kind: kind ?? this.kind,
      weekday: weekday ?? this.weekday,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isDemo: isDemo ?? this.isDemo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roleRowId.present) {
      map['role_row_id'] = Variable<int>(roleRowId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TimetableSlotsTable.$converterkind.toSql(kind.value),
      );
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetableSlotsCompanion(')
          ..write('id: $id, ')
          ..write('roleRowId: $roleRowId, ')
          ..write('kind: $kind, ')
          ..write('weekday: $weekday, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }
}

class $ReminderSettingsTable extends ReminderSettings
    with TableInfo<$ReminderSettingsTable, ReminderSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderSettingsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<ReminderKind, String> key =
      GeneratedColumn<String>(
        'key',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReminderKind>($ReminderSettingsTable.$converterkey);
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, enabled, time, weekday];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  ReminderSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderSetting(
      key: $ReminderSettingsTable.$converterkey.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}key'],
        )!,
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      ),
    );
  }

  @override
  $ReminderSettingsTable createAlias(String alias) {
    return $ReminderSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderKind, String, String> $converterkey =
      const EnumNameConverter<ReminderKind>(ReminderKind.values);
}

class ReminderSetting extends DataClass implements Insertable<ReminderSetting> {
  final ReminderKind key;
  final bool enabled;
  final String time;

  /// Weekly reminder only; 1 = Monday … 7 = Sunday.
  final int? weekday;
  const ReminderSetting({
    required this.key,
    required this.enabled,
    required this.time,
    this.weekday,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['key'] = Variable<String>(
        $ReminderSettingsTable.$converterkey.toSql(key),
      );
    }
    map['enabled'] = Variable<bool>(enabled);
    map['time'] = Variable<String>(time);
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<int>(weekday);
    }
    return map;
  }

  ReminderSettingsCompanion toCompanion(bool nullToAbsent) {
    return ReminderSettingsCompanion(
      key: Value(key),
      enabled: Value(enabled),
      time: Value(time),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
    );
  }

  factory ReminderSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderSetting(
      key: $ReminderSettingsTable.$converterkey.fromJson(
        serializer.fromJson<String>(json['key']),
      ),
      enabled: serializer.fromJson<bool>(json['enabled']),
      time: serializer.fromJson<String>(json['time']),
      weekday: serializer.fromJson<int?>(json['weekday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(
        $ReminderSettingsTable.$converterkey.toJson(key),
      ),
      'enabled': serializer.toJson<bool>(enabled),
      'time': serializer.toJson<String>(time),
      'weekday': serializer.toJson<int?>(weekday),
    };
  }

  ReminderSetting copyWith({
    ReminderKind? key,
    bool? enabled,
    String? time,
    Value<int?> weekday = const Value.absent(),
  }) => ReminderSetting(
    key: key ?? this.key,
    enabled: enabled ?? this.enabled,
    time: time ?? this.time,
    weekday: weekday.present ? weekday.value : this.weekday,
  );
  ReminderSetting copyWithCompanion(ReminderSettingsCompanion data) {
    return ReminderSetting(
      key: data.key.present ? data.key.value : this.key,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      time: data.time.present ? data.time.value : this.time,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSetting(')
          ..write('key: $key, ')
          ..write('enabled: $enabled, ')
          ..write('time: $time, ')
          ..write('weekday: $weekday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, enabled, time, weekday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderSetting &&
          other.key == this.key &&
          other.enabled == this.enabled &&
          other.time == this.time &&
          other.weekday == this.weekday);
}

class ReminderSettingsCompanion extends UpdateCompanion<ReminderSetting> {
  final Value<ReminderKind> key;
  final Value<bool> enabled;
  final Value<String> time;
  final Value<int?> weekday;
  final Value<int> rowid;
  const ReminderSettingsCompanion({
    this.key = const Value.absent(),
    this.enabled = const Value.absent(),
    this.time = const Value.absent(),
    this.weekday = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderSettingsCompanion.insert({
    required ReminderKind key,
    required bool enabled,
    required String time,
    this.weekday = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       enabled = Value(enabled),
       time = Value(time);
  static Insertable<ReminderSetting> custom({
    Expression<String>? key,
    Expression<bool>? enabled,
    Expression<String>? time,
    Expression<int>? weekday,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (enabled != null) 'enabled': enabled,
      if (time != null) 'time': time,
      if (weekday != null) 'weekday': weekday,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderSettingsCompanion copyWith({
    Value<ReminderKind>? key,
    Value<bool>? enabled,
    Value<String>? time,
    Value<int?>? weekday,
    Value<int>? rowid,
  }) {
    return ReminderSettingsCompanion(
      key: key ?? this.key,
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
      weekday: weekday ?? this.weekday,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(
        $ReminderSettingsTable.$converterkey.toSql(key.value),
      );
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingsCompanion(')
          ..write('key: $key, ')
          ..write('enabled: $enabled, ')
          ..write('time: $time, ')
          ..write('weekday: $weekday, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DayReviewsTable extends DayReviews
    with TableInfo<$DayReviewsTable, DayReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DayReviewStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DayReviewStatus>($DayReviewsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [date, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayReview> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DayReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayReview(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      status: $DayReviewsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $DayReviewsTable createAlias(String alias) {
    return $DayReviewsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DayReviewStatus, String, String> $converterstatus =
      const EnumNameConverter<DayReviewStatus>(DayReviewStatus.values);
}

class DayReview extends DataClass implements Insertable<DayReview> {
  final String date;
  final DayReviewStatus status;
  const DayReview({required this.date, required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    {
      map['status'] = Variable<String>(
        $DayReviewsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  DayReviewsCompanion toCompanion(bool nullToAbsent) {
    return DayReviewsCompanion(date: Value(date), status: Value(status));
  }

  factory DayReview.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayReview(
      date: serializer.fromJson<String>(json['date']),
      status: $DayReviewsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'status': serializer.toJson<String>(
        $DayReviewsTable.$converterstatus.toJson(status),
      ),
    };
  }

  DayReview copyWith({String? date, DayReviewStatus? status}) =>
      DayReview(date: date ?? this.date, status: status ?? this.status);
  DayReview copyWithCompanion(DayReviewsCompanion data) {
    return DayReview(
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayReview(')
          ..write('date: $date, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayReview &&
          other.date == this.date &&
          other.status == this.status);
}

class DayReviewsCompanion extends UpdateCompanion<DayReview> {
  final Value<String> date;
  final Value<DayReviewStatus> status;
  final Value<int> rowid;
  const DayReviewsCompanion({
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayReviewsCompanion.insert({
    required String date,
    required DayReviewStatus status,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       status = Value(status);
  static Insertable<DayReview> custom({
    Expression<String>? date,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayReviewsCompanion copyWith({
    Value<String>? date,
    Value<DayReviewStatus>? status,
    Value<int>? rowid,
  }) {
    return DayReviewsCompanion(
      date: date ?? this.date,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DayReviewsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayReviewsCompanion(')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PgSupervisionTable extends PgSupervision
    with TableInfo<$PgSupervisionTable, PgSupervisionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PgSupervisionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _academicYearLabelMeta = const VerificationMeta(
    'academicYearLabel',
  );
  @override
  late final GeneratedColumn<String> academicYearLabel =
      GeneratedColumn<String>(
        'academic_year_label',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _studentsMeta = const VerificationMeta(
    'students',
  );
  @override
  late final GeneratedColumn<int> students = GeneratedColumn<int>(
    'students',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [academicYearLabel, students];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pg_supervision';
  @override
  VerificationContext validateIntegrity(
    Insertable<PgSupervisionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('academic_year_label')) {
      context.handle(
        _academicYearLabelMeta,
        academicYearLabel.isAcceptableOrUnknown(
          data['academic_year_label']!,
          _academicYearLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_academicYearLabelMeta);
    }
    if (data.containsKey('students')) {
      context.handle(
        _studentsMeta,
        students.isAcceptableOrUnknown(data['students']!, _studentsMeta),
      );
    } else if (isInserting) {
      context.missing(_studentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {academicYearLabel};
  @override
  PgSupervisionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PgSupervisionRow(
      academicYearLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_year_label'],
      )!,
      students: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}students'],
      )!,
    );
  }

  @override
  $PgSupervisionTable createAlias(String alias) {
    return $PgSupervisionTable(attachedDatabase, alias);
  }
}

class PgSupervisionRow extends DataClass
    implements Insertable<PgSupervisionRow> {
  final String academicYearLabel;
  final int students;
  const PgSupervisionRow({
    required this.academicYearLabel,
    required this.students,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['academic_year_label'] = Variable<String>(academicYearLabel);
    map['students'] = Variable<int>(students);
    return map;
  }

  PgSupervisionCompanion toCompanion(bool nullToAbsent) {
    return PgSupervisionCompanion(
      academicYearLabel: Value(academicYearLabel),
      students: Value(students),
    );
  }

  factory PgSupervisionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PgSupervisionRow(
      academicYearLabel: serializer.fromJson<String>(json['academicYearLabel']),
      students: serializer.fromJson<int>(json['students']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'academicYearLabel': serializer.toJson<String>(academicYearLabel),
      'students': serializer.toJson<int>(students),
    };
  }

  PgSupervisionRow copyWith({String? academicYearLabel, int? students}) =>
      PgSupervisionRow(
        academicYearLabel: academicYearLabel ?? this.academicYearLabel,
        students: students ?? this.students,
      );
  PgSupervisionRow copyWithCompanion(PgSupervisionCompanion data) {
    return PgSupervisionRow(
      academicYearLabel: data.academicYearLabel.present
          ? data.academicYearLabel.value
          : this.academicYearLabel,
      students: data.students.present ? data.students.value : this.students,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PgSupervisionRow(')
          ..write('academicYearLabel: $academicYearLabel, ')
          ..write('students: $students')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(academicYearLabel, students);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PgSupervisionRow &&
          other.academicYearLabel == this.academicYearLabel &&
          other.students == this.students);
}

class PgSupervisionCompanion extends UpdateCompanion<PgSupervisionRow> {
  final Value<String> academicYearLabel;
  final Value<int> students;
  final Value<int> rowid;
  const PgSupervisionCompanion({
    this.academicYearLabel = const Value.absent(),
    this.students = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PgSupervisionCompanion.insert({
    required String academicYearLabel,
    required int students,
    this.rowid = const Value.absent(),
  }) : academicYearLabel = Value(academicYearLabel),
       students = Value(students);
  static Insertable<PgSupervisionRow> custom({
    Expression<String>? academicYearLabel,
    Expression<int>? students,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (academicYearLabel != null) 'academic_year_label': academicYearLabel,
      if (students != null) 'students': students,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PgSupervisionCompanion copyWith({
    Value<String>? academicYearLabel,
    Value<int>? students,
    Value<int>? rowid,
  }) {
    return PgSupervisionCompanion(
      academicYearLabel: academicYearLabel ?? this.academicYearLabel,
      students: students ?? this.students,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (academicYearLabel.present) {
      map['academic_year_label'] = Variable<String>(academicYearLabel.value);
    }
    if (students.present) {
      map['students'] = Variable<int>(students.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PgSupervisionCompanion(')
          ..write('academicYearLabel: $academicYearLabel, ')
          ..write('students: $students, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PeriodsTable extends Periods with TableInfo<$PeriodsTable, Period> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lockedAtMeta = const VerificationMeta(
    'lockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lockedAt = GeneratedColumn<DateTime>(
    'locked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    startDate,
    endDate,
    lockedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Period> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('locked_at')) {
      context.handle(
        _lockedAtMeta,
        lockedAt.isAcceptableOrUnknown(data['locked_at']!, _lockedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Period map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Period(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
      lockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}locked_at'],
      ),
    );
  }

  @override
  $PeriodsTable createAlias(String alias) {
    return $PeriodsTable(attachedDatabase, alias);
  }
}

class Period extends DataClass implements Insertable<Period> {
  final int id;
  final String label;
  final String startDate;
  final String endDate;
  final DateTime? lockedAt;
  const Period({
    required this.id,
    required this.label,
    required this.startDate,
    required this.endDate,
    this.lockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    if (!nullToAbsent || lockedAt != null) {
      map['locked_at'] = Variable<DateTime>(lockedAt);
    }
    return map;
  }

  PeriodsCompanion toCompanion(bool nullToAbsent) {
    return PeriodsCompanion(
      id: Value(id),
      label: Value(label),
      startDate: Value(startDate),
      endDate: Value(endDate),
      lockedAt: lockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedAt),
    );
  }

  factory Period.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Period(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
      lockedAt: serializer.fromJson<DateTime?>(json['lockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
      'lockedAt': serializer.toJson<DateTime?>(lockedAt),
    };
  }

  Period copyWith({
    int? id,
    String? label,
    String? startDate,
    String? endDate,
    Value<DateTime?> lockedAt = const Value.absent(),
  }) => Period(
    id: id ?? this.id,
    label: label ?? this.label,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    lockedAt: lockedAt.present ? lockedAt.value : this.lockedAt,
  );
  Period copyWithCompanion(PeriodsCompanion data) {
    return Period(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      lockedAt: data.lockedAt.present ? data.lockedAt.value : this.lockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Period(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('lockedAt: $lockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, startDate, endDate, lockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Period &&
          other.id == this.id &&
          other.label == this.label &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.lockedAt == this.lockedAt);
}

class PeriodsCompanion extends UpdateCompanion<Period> {
  final Value<int> id;
  final Value<String> label;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<DateTime?> lockedAt;
  const PeriodsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.lockedAt = const Value.absent(),
  });
  PeriodsCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required String startDate,
    required String endDate,
    this.lockedAt = const Value.absent(),
  }) : label = Value(label),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Period> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<DateTime>? lockedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (lockedAt != null) 'locked_at': lockedAt,
    });
  }

  PeriodsCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<String>? startDate,
    Value<String>? endDate,
    Value<DateTime?>? lockedAt,
  }) {
    return PeriodsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lockedAt: lockedAt ?? this.lockedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (lockedAt.present) {
      map['locked_at'] = Variable<DateTime>(lockedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('lockedAt: $lockedAt')
          ..write(')'))
        .toString();
  }
}

class $TimetableAnswersTable extends TimetableAnswers
    with TableInfo<$TimetableAnswersTable, TimetableAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimetableAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotIdMeta = const VerificationMeta('slotId');
  @override
  late final GeneratedColumn<int> slotId = GeneratedColumn<int>(
    'slot_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES timetable_slots (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SlotAnswer, String> answer =
      GeneratedColumn<String>(
        'answer',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SlotAnswer>($TimetableAnswersTable.$converteranswer);
  @override
  List<GeneratedColumn> get $columns => [date, slotId, answer];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timetable_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimetableAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('slot_id')) {
      context.handle(
        _slotIdMeta,
        slotId.isAcceptableOrUnknown(data['slot_id']!, _slotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_slotIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, slotId};
  @override
  TimetableAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimetableAnswer(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      slotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_id'],
      )!,
      answer: $TimetableAnswersTable.$converteranswer.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}answer'],
        )!,
      ),
    );
  }

  @override
  $TimetableAnswersTable createAlias(String alias) {
    return $TimetableAnswersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SlotAnswer, String, String> $converteranswer =
      const EnumNameConverter<SlotAnswer>(SlotAnswer.values);
}

class TimetableAnswer extends DataClass implements Insertable<TimetableAnswer> {
  final String date;
  final int slotId;
  final SlotAnswer answer;
  const TimetableAnswer({
    required this.date,
    required this.slotId,
    required this.answer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['slot_id'] = Variable<int>(slotId);
    {
      map['answer'] = Variable<String>(
        $TimetableAnswersTable.$converteranswer.toSql(answer),
      );
    }
    return map;
  }

  TimetableAnswersCompanion toCompanion(bool nullToAbsent) {
    return TimetableAnswersCompanion(
      date: Value(date),
      slotId: Value(slotId),
      answer: Value(answer),
    );
  }

  factory TimetableAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimetableAnswer(
      date: serializer.fromJson<String>(json['date']),
      slotId: serializer.fromJson<int>(json['slotId']),
      answer: $TimetableAnswersTable.$converteranswer.fromJson(
        serializer.fromJson<String>(json['answer']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'slotId': serializer.toJson<int>(slotId),
      'answer': serializer.toJson<String>(
        $TimetableAnswersTable.$converteranswer.toJson(answer),
      ),
    };
  }

  TimetableAnswer copyWith({String? date, int? slotId, SlotAnswer? answer}) =>
      TimetableAnswer(
        date: date ?? this.date,
        slotId: slotId ?? this.slotId,
        answer: answer ?? this.answer,
      );
  TimetableAnswer copyWithCompanion(TimetableAnswersCompanion data) {
    return TimetableAnswer(
      date: data.date.present ? data.date.value : this.date,
      slotId: data.slotId.present ? data.slotId.value : this.slotId,
      answer: data.answer.present ? data.answer.value : this.answer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimetableAnswer(')
          ..write('date: $date, ')
          ..write('slotId: $slotId, ')
          ..write('answer: $answer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, slotId, answer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimetableAnswer &&
          other.date == this.date &&
          other.slotId == this.slotId &&
          other.answer == this.answer);
}

class TimetableAnswersCompanion extends UpdateCompanion<TimetableAnswer> {
  final Value<String> date;
  final Value<int> slotId;
  final Value<SlotAnswer> answer;
  final Value<int> rowid;
  const TimetableAnswersCompanion({
    this.date = const Value.absent(),
    this.slotId = const Value.absent(),
    this.answer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimetableAnswersCompanion.insert({
    required String date,
    required int slotId,
    required SlotAnswer answer,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       slotId = Value(slotId),
       answer = Value(answer);
  static Insertable<TimetableAnswer> custom({
    Expression<String>? date,
    Expression<int>? slotId,
    Expression<String>? answer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (slotId != null) 'slot_id': slotId,
      if (answer != null) 'answer': answer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimetableAnswersCompanion copyWith({
    Value<String>? date,
    Value<int>? slotId,
    Value<SlotAnswer>? answer,
    Value<int>? rowid,
  }) {
    return TimetableAnswersCompanion(
      date: date ?? this.date,
      slotId: slotId ?? this.slotId,
      answer: answer ?? this.answer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (slotId.present) {
      map['slot_id'] = Variable<int>(slotId.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(
        $TimetableAnswersTable.$converteranswer.toSql(answer.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetableAnswersCompanion(')
          ..write('date: $date, ')
          ..write('slotId: $slotId, ')
          ..write('answer: $answer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfileTable profile = $ProfileTable(this);
  late final $RatesTable rates = $RatesTable(this);
  late final $RoleRowsTable roleRows = $RoleRowsTable(this);
  late final $EntriesTable entries = $EntriesTable(this);
  late final $EntryPhotosTable entryPhotos = $EntryPhotosTable(this);
  late final $OtherCategoriesTable otherCategories = $OtherCategoriesTable(
    this,
  );
  late final $OtherWorkTable otherWork = $OtherWorkTable(this);
  late final $TimetableSlotsTable timetableSlots = $TimetableSlotsTable(this);
  late final $ReminderSettingsTable reminderSettings = $ReminderSettingsTable(
    this,
  );
  late final $DayReviewsTable dayReviews = $DayReviewsTable(this);
  late final $PgSupervisionTable pgSupervision = $PgSupervisionTable(this);
  late final $PeriodsTable periods = $PeriodsTable(this);
  late final $TimetableAnswersTable timetableAnswers = $TimetableAnswersTable(
    this,
  );
  late final Index entriesDate = Index(
    'entries_date',
    'CREATE INDEX entries_date ON entries (date)',
  );
  late final Index entriesRoleRow = Index(
    'entries_role_row',
    'CREATE INDEX entries_role_row ON entries (role_row_id)',
  );
  late final Index entriesStatus = Index(
    'entries_status',
    'CREATE INDEX entries_status ON entries (status)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profile,
    rates,
    roleRows,
    entries,
    entryPhotos,
    otherCategories,
    otherWork,
    timetableSlots,
    reminderSettings,
    dayReviews,
    pgSupervision,
    periods,
    timetableAnswers,
    entriesDate,
    entriesRoleRow,
    entriesStatus,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('entry_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'role_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('timetable_slots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'timetable_slots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('timetable_answers', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfileTableCreateCompanionBuilder = ProfileCompanion Function({
  Value<int> id,
  required String staffName,
  required String displayName,
  required String academicYearLabel,
  Value<String?> workbookFileName,
  Value<DateTime?> importedAt,
  Value<String?> submissionDate,
  Value<bool> onboardingDone,
  Value<bool> isDemo,
});
typedef $$ProfileTableUpdateCompanionBuilder = ProfileCompanion Function({
  Value<int> id,
  Value<String> staffName,
  Value<String> displayName,
  Value<String> academicYearLabel,
  Value<String?> workbookFileName,
  Value<DateTime?> importedAt,
  Value<String?> submissionDate,
  Value<bool> onboardingDone,
  Value<bool> isDemo,
});

class $$ProfileTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileTable> {
  $$ProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get staffName => $composableBuilder(
    column: $table.staffName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicYearLabel => $composableBuilder(
    column: $table.academicYearLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workbookFileName => $composableBuilder(
    column: $table.workbookFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get submissionDate => $composableBuilder(
    column: $table.submissionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileTable> {
  $$ProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get staffName => $composableBuilder(
    column: $table.staffName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicYearLabel => $composableBuilder(
    column: $table.academicYearLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workbookFileName => $composableBuilder(
    column: $table.workbookFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get submissionDate => $composableBuilder(
    column: $table.submissionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileTable> {
  $$ProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get staffName =>
      $composableBuilder(column: $table.staffName, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get academicYearLabel => $composableBuilder(
    column: $table.academicYearLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workbookFileName => $composableBuilder(
    column: $table.workbookFileName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get submissionDate => $composableBuilder(
    column: $table.submissionDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);
}

class $$ProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileTable,
          ProfileRow,
          $$ProfileTableFilterComposer,
          $$ProfileTableOrderingComposer,
          $$ProfileTableAnnotationComposer,
          $$ProfileTableCreateCompanionBuilder,
          $$ProfileTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfileTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfileTableTableManager(_$AppDatabase db, $ProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> staffName = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> academicYearLabel = const Value.absent(),
                Value<String?> workbookFileName = const Value.absent(),
                Value<DateTime?> importedAt = const Value.absent(),
                Value<String?> submissionDate = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
              }) => ProfileCompanion(
                id: id,
                staffName: staffName,
                displayName: displayName,
                academicYearLabel: academicYearLabel,
                workbookFileName: workbookFileName,
                importedAt: importedAt,
                submissionDate: submissionDate,
                onboardingDone: onboardingDone,
                isDemo: isDemo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String staffName,
                required String displayName,
                required String academicYearLabel,
                Value<String?> workbookFileName = const Value.absent(),
                Value<DateTime?> importedAt = const Value.absent(),
                Value<String?> submissionDate = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
              }) => ProfileCompanion.insert(
                id: id,
                staffName: staffName,
                displayName: displayName,
                academicYearLabel: academicYearLabel,
                workbookFileName: workbookFileName,
                importedAt: importedAt,
                submissionDate: submissionDate,
                onboardingDone: onboardingDone,
                isDemo: isDemo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfileTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $ProfileTable, ProfileRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileTable,
      ProfileRow,
      $$ProfileTableFilterComposer,
      $$ProfileTableOrderingComposer,
      $$ProfileTableAnnotationComposer,
      $$ProfileTableCreateCompanionBuilder,
      $$ProfileTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfileTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$RatesTableCreateCompanionBuilder = RatesCompanion Function({
  required RateKey key,
  required String label,
  required double hours,
  Value<String?> sourceCell,
  Value<bool> isDefault,
  Value<int> rowid,
});
typedef $$RatesTableUpdateCompanionBuilder = RatesCompanion Function({
  Value<RateKey> key,
  Value<String> label,
  Value<double> hours,
  Value<String?> sourceCell,
  Value<bool> isDefault,
  Value<int> rowid,
});

class $$RatesTableFilterComposer extends Composer<_$AppDatabase, $RatesTable> {
  $$RatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<RateKey, RateKey, String> get key =>
      $composableBuilder(
        column: $table.key,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceCell => $composableBuilder(
    column: $table.sourceCell,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RatesTableOrderingComposer
    extends Composer<_$AppDatabase, $RatesTable> {
  $$RatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceCell => $composableBuilder(
    column: $table.sourceCell,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RatesTable> {
  $$RatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<RateKey, String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<String> get sourceCell => $composableBuilder(
    column: $table.sourceCell,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);
}

class $$RatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RatesTable,
          RateRow,
          $$RatesTableFilterComposer,
          $$RatesTableOrderingComposer,
          $$RatesTableAnnotationComposer,
          $$RatesTableCreateCompanionBuilder,
          $$RatesTableUpdateCompanionBuilder,
          (RateRow, BaseReferences<_$AppDatabase, $RatesTable, RateRow>),
          RateRow,
          PrefetchHooks Function()
        > {
  $$RatesTableTableManager(_$AppDatabase db, $RatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<RateKey> key = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> hours = const Value.absent(),
                Value<String?> sourceCell = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RatesCompanion(
                key: key,
                label: label,
                hours: hours,
                sourceCell: sourceCell,
                isDefault: isDefault,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required RateKey key,
                required String label,
                required double hours,
                Value<String?> sourceCell = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RatesCompanion.insert(
                key: key,
                label: label,
                hours: hours,
                sourceCell: sourceCell,
                isDefault: isDefault,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RatesTable, RateRow>(table),
                  BaseReferences<_$AppDatabase, $RatesTable, RateRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RatesTable,
      RateRow,
      $$RatesTableFilterComposer,
      $$RatesTableOrderingComposer,
      $$RatesTableAnnotationComposer,
      $$RatesTableCreateCompanionBuilder,
      $$RatesTableUpdateCompanionBuilder,
      (RateRow, BaseReferences<_$AppDatabase, $RatesTable, RateRow>),
      RateRow,
      PrefetchHooks Function()
    >;
typedef $$RoleRowsTableCreateCompanionBuilder = RoleRowsCompanion Function({
  Value<int> id,
  required String moduleCode,
  required String batch,
  required String moduleName,
  required ModuleType moduleType,
  Value<double> credits,
  Value<int> students,
  required Role role,
  Value<int?> sheetRow,
  Value<bool> isActive,
  Value<bool> isDemo,
});
typedef $$RoleRowsTableUpdateCompanionBuilder = RoleRowsCompanion Function({
  Value<int> id,
  Value<String> moduleCode,
  Value<String> batch,
  Value<String> moduleName,
  Value<ModuleType> moduleType,
  Value<double> credits,
  Value<int> students,
  Value<Role> role,
  Value<int?> sheetRow,
  Value<bool> isActive,
  Value<bool> isDemo,
});

final class $$RoleRowsTableReferences
    extends BaseReferences<_$AppDatabase, $RoleRowsTable, RoleRow> {
  $$RoleRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntriesTable, List<EntryRow>> _entriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.entries,
    aliasName: 'role_rows__id__entries__role_row_id',
  );

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.roleRowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimetableSlotsTable, List<TimetableSlot>>
  _timetableSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timetableSlots,
    aliasName: 'role_rows__id__timetable_slots__role_row_id',
  );

  $$TimetableSlotsTableProcessedTableManager get timetableSlotsRefs {
    final manager = $$TimetableSlotsTableTableManager(
      $_db,
      $_db.timetableSlots,
    ).filter((f) => f.roleRowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timetableSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoleRowsTableFilterComposer
    extends Composer<_$AppDatabase, $RoleRowsTable> {
  $$RoleRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleCode => $composableBuilder(
    column: $table.moduleCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batch => $composableBuilder(
    column: $table.batch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ModuleType, ModuleType, String>
  get moduleType => $composableBuilder(
    column: $table.moduleType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get credits => $composableBuilder(
    column: $table.credits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get students => $composableBuilder(
    column: $table.students,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Role, Role, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sheetRow => $composableBuilder(
    column: $table.sheetRow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> entriesRefs(
    Expression<bool> Function($$EntriesTableFilterComposer f) f,
  ) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.roleRowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timetableSlotsRefs(
    Expression<bool> Function($$TimetableSlotsTableFilterComposer f) f,
  ) {
    final $$TimetableSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.roleRowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableFilterComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoleRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoleRowsTable> {
  $$RoleRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleCode => $composableBuilder(
    column: $table.moduleCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batch => $composableBuilder(
    column: $table.batch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleType => $composableBuilder(
    column: $table.moduleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get credits => $composableBuilder(
    column: $table.credits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get students => $composableBuilder(
    column: $table.students,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sheetRow => $composableBuilder(
    column: $table.sheetRow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoleRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoleRowsTable> {
  $$RoleRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moduleCode => $composableBuilder(
    column: $table.moduleCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get batch =>
      $composableBuilder(column: $table.batch, builder: (column) => column);

  GeneratedColumn<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ModuleType, String> get moduleType =>
      $composableBuilder(
        column: $table.moduleType,
        builder: (column) => column,
      );

  GeneratedColumn<double> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<int> get students =>
      $composableBuilder(column: $table.students, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Role, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get sheetRow =>
      $composableBuilder(column: $table.sheetRow, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  Expression<T> entriesRefs<T extends Object>(
    Expression<T> Function($$EntriesTableAnnotationComposer a) f,
  ) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.roleRowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timetableSlotsRefs<T extends Object>(
    Expression<T> Function($$TimetableSlotsTableAnnotationComposer a) f,
  ) {
    final $$TimetableSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.roleRowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoleRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoleRowsTable,
          RoleRow,
          $$RoleRowsTableFilterComposer,
          $$RoleRowsTableOrderingComposer,
          $$RoleRowsTableAnnotationComposer,
          $$RoleRowsTableCreateCompanionBuilder,
          $$RoleRowsTableUpdateCompanionBuilder,
          (RoleRow, $$RoleRowsTableReferences),
          RoleRow,
          PrefetchHooks Function({bool entriesRefs, bool timetableSlotsRefs})
        > {
  $$RoleRowsTableTableManager(_$AppDatabase db, $RoleRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoleRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoleRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoleRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> moduleCode = const Value.absent(),
                Value<String> batch = const Value.absent(),
                Value<String> moduleName = const Value.absent(),
                Value<ModuleType> moduleType = const Value.absent(),
                Value<double> credits = const Value.absent(),
                Value<int> students = const Value.absent(),
                Value<Role> role = const Value.absent(),
                Value<int?> sheetRow = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
              }) => RoleRowsCompanion(
                id: id,
                moduleCode: moduleCode,
                batch: batch,
                moduleName: moduleName,
                moduleType: moduleType,
                credits: credits,
                students: students,
                role: role,
                sheetRow: sheetRow,
                isActive: isActive,
                isDemo: isDemo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String moduleCode,
                required String batch,
                required String moduleName,
                required ModuleType moduleType,
                Value<double> credits = const Value.absent(),
                Value<int> students = const Value.absent(),
                required Role role,
                Value<int?> sheetRow = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
              }) => RoleRowsCompanion.insert(
                id: id,
                moduleCode: moduleCode,
                batch: batch,
                moduleName: moduleName,
                moduleType: moduleType,
                credits: credits,
                students: students,
                role: role,
                sheetRow: sheetRow,
                isActive: isActive,
                isDemo: isDemo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoleRowsTable, RoleRow>(table),
                  $$RoleRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({entriesRefs = false, timetableSlotsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (entriesRefs) db.entries,
                    if (timetableSlotsRefs) db.timetableSlots,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (entriesRefs)
                        await $_getPrefetchedDataByColumns<
                          RoleRow,
                          $RoleRowsTable,
                          EntryRow,
                          $EntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoleRowsTableReferences
                              ._entriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoleRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).entriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'role_row_id',
                          typedResults: items,
                        ),
                      if (timetableSlotsRefs)
                        await $_getPrefetchedDataByColumns<
                          RoleRow,
                          $RoleRowsTable,
                          TimetableSlot,
                          $TimetableSlotsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoleRowsTableReferences
                              ._timetableSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoleRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).timetableSlotsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'role_row_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoleRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoleRowsTable,
      RoleRow,
      $$RoleRowsTableFilterComposer,
      $$RoleRowsTableOrderingComposer,
      $$RoleRowsTableAnnotationComposer,
      $$RoleRowsTableCreateCompanionBuilder,
      $$RoleRowsTableUpdateCompanionBuilder,
      (RoleRow, $$RoleRowsTableReferences),
      RoleRow,
      PrefetchHooks Function({bool entriesRefs, bool timetableSlotsRefs})
    >;
typedef $$EntriesTableCreateCompanionBuilder = EntriesCompanion Function({
  required String id,
  Value<int?> roleRowId,
  required String date,
  required Activity activity,
  Value<Subtype?> subtype,
  Value<double?> count,
  Value<double?> questionsPerPaper,
  Value<int?> spentMinutes,
  Value<String?> note,
  required EntryStatus status,
  required EntrySource source,
  Value<String?> rawText,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isDemo,
  Value<int> rowid,
});
typedef $$EntriesTableUpdateCompanionBuilder = EntriesCompanion Function({
  Value<String> id,
  Value<int?> roleRowId,
  Value<String> date,
  Value<Activity> activity,
  Value<Subtype?> subtype,
  Value<double?> count,
  Value<double?> questionsPerPaper,
  Value<int?> spentMinutes,
  Value<String?> note,
  Value<EntryStatus> status,
  Value<EntrySource> source,
  Value<String?> rawText,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> isDemo,
  Value<int> rowid,
});

final class $$EntriesTableReferences
    extends BaseReferences<_$AppDatabase, $EntriesTable, EntryRow> {
  $$EntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoleRowsTable _roleRowIdTable(_$AppDatabase db) =>
      db.roleRows.createAlias('entries__role_row_id__role_rows__id');

  $$RoleRowsTableProcessedTableManager? get roleRowId {
    final $_column = $_itemColumn<int>('role_row_id');
    if ($_column == null) return null;
    final manager = $$RoleRowsTableTableManager(
      $_db,
      $_db.roleRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roleRowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EntryPhotosTable, List<EntryPhoto>>
  _entryPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.entryPhotos,
    aliasName: 'entries__id__entry_photos__entry_id',
  );

  $$EntryPhotosTableProcessedTableManager get entryPhotosRefs {
    final manager = $$EntryPhotosTableTableManager(
      $_db,
      $_db.entryPhotos,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entryPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EntriesTableFilterComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Activity, Activity, String> get activity =>
      $composableBuilder(
        column: $table.activity,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Subtype?, Subtype, String> get subtype =>
      $composableBuilder(
        column: $table.subtype,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get questionsPerPaper => $composableBuilder(
    column: $table.questionsPerPaper,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spentMinutes => $composableBuilder(
    column: $table.spentMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EntryStatus, EntryStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<EntrySource, EntrySource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );

  $$RoleRowsTableFilterComposer get roleRowId {
    final $$RoleRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleRowId,
      referencedTable: $db.roleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleRowsTableFilterComposer(
            $db: $db,
            $table: $db.roleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> entryPhotosRefs(
    Expression<bool> Function($$EntryPhotosTableFilterComposer f) f,
  ) {
    final $$EntryPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entryPhotos,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryPhotosTableFilterComposer(
            $db: $db,
            $table: $db.entryPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get questionsPerPaper => $composableBuilder(
    column: $table.questionsPerPaper,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spentMinutes => $composableBuilder(
    column: $table.spentMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoleRowsTableOrderingComposer get roleRowId {
    final $$RoleRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleRowId,
      referencedTable: $db.roleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleRowsTableOrderingComposer(
            $db: $db,
            $table: $db.roleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Activity, String> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Subtype?, String> get subtype =>
      $composableBuilder(column: $table.subtype, builder: (column) => column);

  GeneratedColumn<double> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<double> get questionsPerPaper => $composableBuilder(
    column: $table.questionsPerPaper,
    builder: (column) => column,
  );

  GeneratedColumn<int> get spentMinutes => $composableBuilder(
    column: $table.spentMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntryStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntrySource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  $$RoleRowsTableAnnotationComposer get roleRowId {
    final $$RoleRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleRowId,
      referencedTable: $db.roleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.roleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> entryPhotosRefs<T extends Object>(
    Expression<T> Function($$EntryPhotosTableAnnotationComposer a) f,
  ) {
    final $$EntryPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entryPhotos,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.entryPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntriesTable,
          EntryRow,
          $$EntriesTableFilterComposer,
          $$EntriesTableOrderingComposer,
          $$EntriesTableAnnotationComposer,
          $$EntriesTableCreateCompanionBuilder,
          $$EntriesTableUpdateCompanionBuilder,
          (EntryRow, $$EntriesTableReferences),
          EntryRow,
          PrefetchHooks Function({bool roleRowId, bool entryPhotosRefs})
        > {
  $$EntriesTableTableManager(_$AppDatabase db, $EntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int?> roleRowId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<Activity> activity = const Value.absent(),
                Value<Subtype?> subtype = const Value.absent(),
                Value<double?> count = const Value.absent(),
                Value<double?> questionsPerPaper = const Value.absent(),
                Value<int?> spentMinutes = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<EntryStatus> status = const Value.absent(),
                Value<EntrySource> source = const Value.absent(),
                Value<String?> rawText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion(
                id: id,
                roleRowId: roleRowId,
                date: date,
                activity: activity,
                subtype: subtype,
                count: count,
                questionsPerPaper: questionsPerPaper,
                spentMinutes: spentMinutes,
                note: note,
                status: status,
                source: source,
                rawText: rawText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDemo: isDemo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int?> roleRowId = const Value.absent(),
                required String date,
                required Activity activity,
                Value<Subtype?> subtype = const Value.absent(),
                Value<double?> count = const Value.absent(),
                Value<double?> questionsPerPaper = const Value.absent(),
                Value<int?> spentMinutes = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required EntryStatus status,
                required EntrySource source,
                Value<String?> rawText = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion.insert(
                id: id,
                roleRowId: roleRowId,
                date: date,
                activity: activity,
                subtype: subtype,
                count: count,
                questionsPerPaper: questionsPerPaper,
                spentMinutes: spentMinutes,
                note: note,
                status: status,
                source: source,
                rawText: rawText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isDemo: isDemo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EntriesTable, EntryRow>(table),
                  $$EntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({roleRowId = false, entryPhotosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (entryPhotosRefs) db.entryPhotos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (roleRowId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.roleRowId,
                            referencedTable: $$EntriesTableReferences
                                ._roleRowIdTable(db),
                            referencedColumn: $$EntriesTableReferences
                                ._roleRowIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (entryPhotosRefs)
                        await $_getPrefetchedDataByColumns<
                          EntryRow,
                          $EntriesTable,
                          EntryPhoto,
                          $EntryPhotosTable
                        >(
                          currentTable: table,
                          referencedTable: $$EntriesTableReferences
                              ._entryPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).entryPhotosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntriesTable,
      EntryRow,
      $$EntriesTableFilterComposer,
      $$EntriesTableOrderingComposer,
      $$EntriesTableAnnotationComposer,
      $$EntriesTableCreateCompanionBuilder,
      $$EntriesTableUpdateCompanionBuilder,
      (EntryRow, $$EntriesTableReferences),
      EntryRow,
      PrefetchHooks Function({bool roleRowId, bool entryPhotosRefs})
    >;
typedef $$EntryPhotosTableCreateCompanionBuilder =
    EntryPhotosCompanion Function({
      Value<int> id,
      required String entryId,
      required String filePath,
      required DateTime createdAt,
    });
typedef $$EntryPhotosTableUpdateCompanionBuilder =
    EntryPhotosCompanion Function({
      Value<int> id,
      Value<String> entryId,
      Value<String> filePath,
      Value<DateTime> createdAt,
    });

final class $$EntryPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $EntryPhotosTable, EntryPhoto> {
  $$EntryPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntriesTable _entryIdTable(_$AppDatabase db) =>
      db.entries.createAlias('entry_photos__entry_id__entries__id');

  $$EntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EntryPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $EntryPhotosTable> {
  $$EntryPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EntriesTableFilterComposer get entryId {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntryPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $EntryPhotosTable> {
  $$EntryPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntriesTableOrderingComposer get entryId {
    final $$EntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableOrderingComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntryPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntryPhotosTable> {
  $$EntryPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EntriesTableAnnotationComposer get entryId {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntryPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntryPhotosTable,
          EntryPhoto,
          $$EntryPhotosTableFilterComposer,
          $$EntryPhotosTableOrderingComposer,
          $$EntryPhotosTableAnnotationComposer,
          $$EntryPhotosTableCreateCompanionBuilder,
          $$EntryPhotosTableUpdateCompanionBuilder,
          (EntryPhoto, $$EntryPhotosTableReferences),
          EntryPhoto,
          PrefetchHooks Function({bool entryId})
        > {
  $$EntryPhotosTableTableManager(_$AppDatabase db, $EntryPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntryPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntryPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntryPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EntryPhotosCompanion(
                id: id,
                entryId: entryId,
                filePath: filePath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entryId,
                required String filePath,
                required DateTime createdAt,
              }) => EntryPhotosCompanion.insert(
                id: id,
                entryId: entryId,
                filePath: filePath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EntryPhotosTable, EntryPhoto>(table),
                  $$EntryPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$EntryPhotosTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$EntryPhotosTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EntryPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntryPhotosTable,
      EntryPhoto,
      $$EntryPhotosTableFilterComposer,
      $$EntryPhotosTableOrderingComposer,
      $$EntryPhotosTableAnnotationComposer,
      $$EntryPhotosTableCreateCompanionBuilder,
      $$EntryPhotosTableUpdateCompanionBuilder,
      (EntryPhoto, $$EntryPhotosTableReferences),
      EntryPhoto,
      PrefetchHooks Function({bool entryId})
    >;
typedef $$OtherCategoriesTableCreateCompanionBuilder =
    OtherCategoriesCompanion Function({
      Value<int> id,
      required String name,
      required int sortOrder,
    });
typedef $$OtherCategoriesTableUpdateCompanionBuilder =
    OtherCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> sortOrder,
    });

final class $$OtherCategoriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $OtherCategoriesTable, OtherCategory> {
  $$OtherCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$OtherWorkTable, List<OtherWorkRow>>
  _otherWorkRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.otherWork,
    aliasName: 'other_categories__id__other_work__category_id',
  );

  $$OtherWorkTableProcessedTableManager get otherWorkRefs {
    final manager = $$OtherWorkTableTableManager(
      $_db,
      $_db.otherWork,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_otherWorkRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OtherCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $OtherCategoriesTable> {
  $$OtherCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> otherWorkRefs(
    Expression<bool> Function($$OtherWorkTableFilterComposer f) f,
  ) {
    final $$OtherWorkTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.otherWork,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OtherWorkTableFilterComposer(
            $db: $db,
            $table: $db.otherWork,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OtherCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OtherCategoriesTable> {
  $$OtherCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OtherCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OtherCategoriesTable> {
  $$OtherCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> otherWorkRefs<T extends Object>(
    Expression<T> Function($$OtherWorkTableAnnotationComposer a) f,
  ) {
    final $$OtherWorkTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.otherWork,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OtherWorkTableAnnotationComposer(
            $db: $db,
            $table: $db.otherWork,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OtherCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OtherCategoriesTable,
          OtherCategory,
          $$OtherCategoriesTableFilterComposer,
          $$OtherCategoriesTableOrderingComposer,
          $$OtherCategoriesTableAnnotationComposer,
          $$OtherCategoriesTableCreateCompanionBuilder,
          $$OtherCategoriesTableUpdateCompanionBuilder,
          (OtherCategory, $$OtherCategoriesTableReferences),
          OtherCategory,
          PrefetchHooks Function({bool otherWorkRefs})
        > {
  $$OtherCategoriesTableTableManager(
    _$AppDatabase db,
    $OtherCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OtherCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OtherCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OtherCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => OtherCategoriesCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int sortOrder,
              }) => OtherCategoriesCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OtherCategoriesTable, OtherCategory>(table),
                  $$OtherCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({otherWorkRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (otherWorkRefs) db.otherWork],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (otherWorkRefs)
                    await $_getPrefetchedDataByColumns<
                      OtherCategory,
                      $OtherCategoriesTable,
                      OtherWorkRow,
                      $OtherWorkTable
                    >(
                      currentTable: table,
                      referencedTable: $$OtherCategoriesTableReferences
                          ._otherWorkRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OtherCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).otherWorkRefs,
                      currentColumn: 'id',
                      referencedColumn: 'category_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OtherCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OtherCategoriesTable,
      OtherCategory,
      $$OtherCategoriesTableFilterComposer,
      $$OtherCategoriesTableOrderingComposer,
      $$OtherCategoriesTableAnnotationComposer,
      $$OtherCategoriesTableCreateCompanionBuilder,
      $$OtherCategoriesTableUpdateCompanionBuilder,
      (OtherCategory, $$OtherCategoriesTableReferences),
      OtherCategory,
      PrefetchHooks Function({bool otherWorkRefs})
    >;
typedef $$OtherWorkTableCreateCompanionBuilder = OtherWorkCompanion Function({
  required String id,
  required String date,
  required int categoryId,
  required int spentMinutes,
  Value<String?> note,
  required DateTime createdAt,
  Value<bool> isDemo,
  Value<int> rowid,
});
typedef $$OtherWorkTableUpdateCompanionBuilder = OtherWorkCompanion Function({
  Value<String> id,
  Value<String> date,
  Value<int> categoryId,
  Value<int> spentMinutes,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<bool> isDemo,
  Value<int> rowid,
});

final class $$OtherWorkTableReferences
    extends BaseReferences<_$AppDatabase, $OtherWorkTable, OtherWorkRow> {
  $$OtherWorkTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OtherCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .otherCategories
      .createAlias('other_work__category_id__other_categories__id');

  $$OtherCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$OtherCategoriesTableTableManager(
      $_db,
      $_db.otherCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OtherWorkTableFilterComposer
    extends Composer<_$AppDatabase, $OtherWorkTable> {
  $$OtherWorkTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spentMinutes => $composableBuilder(
    column: $table.spentMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );

  $$OtherCategoriesTableFilterComposer get categoryId {
    final $$OtherCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.otherCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OtherCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.otherCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OtherWorkTableOrderingComposer
    extends Composer<_$AppDatabase, $OtherWorkTable> {
  $$OtherWorkTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spentMinutes => $composableBuilder(
    column: $table.spentMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );

  $$OtherCategoriesTableOrderingComposer get categoryId {
    final $$OtherCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.otherCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OtherCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.otherCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OtherWorkTableAnnotationComposer
    extends Composer<_$AppDatabase, $OtherWorkTable> {
  $$OtherWorkTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get spentMinutes => $composableBuilder(
    column: $table.spentMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  $$OtherCategoriesTableAnnotationComposer get categoryId {
    final $$OtherCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.otherCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OtherCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.otherCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OtherWorkTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OtherWorkTable,
          OtherWorkRow,
          $$OtherWorkTableFilterComposer,
          $$OtherWorkTableOrderingComposer,
          $$OtherWorkTableAnnotationComposer,
          $$OtherWorkTableCreateCompanionBuilder,
          $$OtherWorkTableUpdateCompanionBuilder,
          (OtherWorkRow, $$OtherWorkTableReferences),
          OtherWorkRow,
          PrefetchHooks Function({bool categoryId})
        > {
  $$OtherWorkTableTableManager(_$AppDatabase db, $OtherWorkTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OtherWorkTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OtherWorkTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OtherWorkTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> spentMinutes = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OtherWorkCompanion(
                id: id,
                date: date,
                categoryId: categoryId,
                spentMinutes: spentMinutes,
                note: note,
                createdAt: createdAt,
                isDemo: isDemo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required int categoryId,
                required int spentMinutes,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isDemo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OtherWorkCompanion.insert(
                id: id,
                date: date,
                categoryId: categoryId,
                spentMinutes: spentMinutes,
                note: note,
                createdAt: createdAt,
                isDemo: isDemo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OtherWorkTable, OtherWorkRow>(table),
                  $$OtherWorkTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$OtherWorkTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$OtherWorkTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OtherWorkTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OtherWorkTable,
      OtherWorkRow,
      $$OtherWorkTableFilterComposer,
      $$OtherWorkTableOrderingComposer,
      $$OtherWorkTableAnnotationComposer,
      $$OtherWorkTableCreateCompanionBuilder,
      $$OtherWorkTableUpdateCompanionBuilder,
      (OtherWorkRow, $$OtherWorkTableReferences),
      OtherWorkRow,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$TimetableSlotsTableCreateCompanionBuilder =
    TimetableSlotsCompanion Function({
      Value<int> id,
      required int roleRowId,
      required SlotKind kind,
      required int weekday,
      required String startTime,
      required String endTime,
      Value<bool> isDemo,
    });
typedef $$TimetableSlotsTableUpdateCompanionBuilder =
    TimetableSlotsCompanion Function({
      Value<int> id,
      Value<int> roleRowId,
      Value<SlotKind> kind,
      Value<int> weekday,
      Value<String> startTime,
      Value<String> endTime,
      Value<bool> isDemo,
    });

final class $$TimetableSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $TimetableSlotsTable, TimetableSlot> {
  $$TimetableSlotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoleRowsTable _roleRowIdTable(_$AppDatabase db) =>
      db.roleRows.createAlias('timetable_slots__role_row_id__role_rows__id');

  $$RoleRowsTableProcessedTableManager get roleRowId {
    final $_column = $_itemColumn<int>('role_row_id')!;

    final manager = $$RoleRowsTableTableManager(
      $_db,
      $_db.roleRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roleRowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TimetableAnswersTable, List<TimetableAnswer>>
  _timetableAnswersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timetableAnswers,
    aliasName: 'timetable_slots__id__timetable_answers__slot_id',
  );

  $$TimetableAnswersTableProcessedTableManager get timetableAnswersRefs {
    final manager = $$TimetableAnswersTableTableManager(
      $_db,
      $_db.timetableAnswers,
    ).filter((f) => f.slotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _timetableAnswersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TimetableSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $TimetableSlotsTable> {
  $$TimetableSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SlotKind, SlotKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );

  $$RoleRowsTableFilterComposer get roleRowId {
    final $$RoleRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleRowId,
      referencedTable: $db.roleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleRowsTableFilterComposer(
            $db: $db,
            $table: $db.roleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> timetableAnswersRefs(
    Expression<bool> Function($$TimetableAnswersTableFilterComposer f) f,
  ) {
    final $$TimetableAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timetableAnswers,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableAnswersTableFilterComposer(
            $db: $db,
            $table: $db.timetableAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimetableSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $TimetableSlotsTable> {
  $$TimetableSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoleRowsTableOrderingComposer get roleRowId {
    final $$RoleRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleRowId,
      referencedTable: $db.roleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleRowsTableOrderingComposer(
            $db: $db,
            $table: $db.roleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimetableSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimetableSlotsTable> {
  $$TimetableSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SlotKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  $$RoleRowsTableAnnotationComposer get roleRowId {
    final $$RoleRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleRowId,
      referencedTable: $db.roleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoleRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.roleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> timetableAnswersRefs<T extends Object>(
    Expression<T> Function($$TimetableAnswersTableAnnotationComposer a) f,
  ) {
    final $$TimetableAnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timetableAnswers,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableAnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.timetableAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimetableSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimetableSlotsTable,
          TimetableSlot,
          $$TimetableSlotsTableFilterComposer,
          $$TimetableSlotsTableOrderingComposer,
          $$TimetableSlotsTableAnnotationComposer,
          $$TimetableSlotsTableCreateCompanionBuilder,
          $$TimetableSlotsTableUpdateCompanionBuilder,
          (TimetableSlot, $$TimetableSlotsTableReferences),
          TimetableSlot,
          PrefetchHooks Function({bool roleRowId, bool timetableAnswersRefs})
        > {
  $$TimetableSlotsTableTableManager(
    _$AppDatabase db,
    $TimetableSlotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimetableSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimetableSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimetableSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> roleRowId = const Value.absent(),
                Value<SlotKind> kind = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
              }) => TimetableSlotsCompanion(
                id: id,
                roleRowId: roleRowId,
                kind: kind,
                weekday: weekday,
                startTime: startTime,
                endTime: endTime,
                isDemo: isDemo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int roleRowId,
                required SlotKind kind,
                required int weekday,
                required String startTime,
                required String endTime,
                Value<bool> isDemo = const Value.absent(),
              }) => TimetableSlotsCompanion.insert(
                id: id,
                roleRowId: roleRowId,
                kind: kind,
                weekday: weekday,
                startTime: startTime,
                endTime: endTime,
                isDemo: isDemo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TimetableSlotsTable, TimetableSlot>(table),
                  $$TimetableSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({roleRowId = false, timetableAnswersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timetableAnswersRefs) db.timetableAnswers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (roleRowId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.roleRowId,
                            referencedTable: $$TimetableSlotsTableReferences
                                ._roleRowIdTable(db),
                            referencedColumn: $$TimetableSlotsTableReferences
                                ._roleRowIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timetableAnswersRefs)
                        await $_getPrefetchedDataByColumns<
                          TimetableSlot,
                          $TimetableSlotsTable,
                          TimetableAnswer,
                          $TimetableAnswersTable
                        >(
                          currentTable: table,
                          referencedTable: $$TimetableSlotsTableReferences
                              ._timetableAnswersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TimetableSlotsTableReferences(
                                db,
                                table,
                                p0,
                              ).timetableAnswersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'slot_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TimetableSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimetableSlotsTable,
      TimetableSlot,
      $$TimetableSlotsTableFilterComposer,
      $$TimetableSlotsTableOrderingComposer,
      $$TimetableSlotsTableAnnotationComposer,
      $$TimetableSlotsTableCreateCompanionBuilder,
      $$TimetableSlotsTableUpdateCompanionBuilder,
      (TimetableSlot, $$TimetableSlotsTableReferences),
      TimetableSlot,
      PrefetchHooks Function({bool roleRowId, bool timetableAnswersRefs})
    >;
typedef $$ReminderSettingsTableCreateCompanionBuilder =
    ReminderSettingsCompanion Function({
      required ReminderKind key,
      required bool enabled,
      required String time,
      Value<int?> weekday,
      Value<int> rowid,
    });
typedef $$ReminderSettingsTableUpdateCompanionBuilder =
    ReminderSettingsCompanion Function({
      Value<ReminderKind> key,
      Value<bool> enabled,
      Value<String> time,
      Value<int?> weekday,
      Value<int> rowid,
    });

class $$ReminderSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<ReminderKind, ReminderKind, String> get key =>
      $composableBuilder(
        column: $table.key,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<ReminderKind, String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);
}

class $$ReminderSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderSettingsTable,
          ReminderSetting,
          $$ReminderSettingsTableFilterComposer,
          $$ReminderSettingsTableOrderingComposer,
          $$ReminderSettingsTableAnnotationComposer,
          $$ReminderSettingsTableCreateCompanionBuilder,
          $$ReminderSettingsTableUpdateCompanionBuilder,
          (
            ReminderSetting,
            BaseReferences<
              _$AppDatabase,
              $ReminderSettingsTable,
              ReminderSetting
            >,
          ),
          ReminderSetting,
          PrefetchHooks Function()
        > {
  $$ReminderSettingsTableTableManager(
    _$AppDatabase db,
    $ReminderSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<ReminderKind> key = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderSettingsCompanion(
                key: key,
                enabled: enabled,
                time: time,
                weekday: weekday,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required ReminderKind key,
                required bool enabled,
                required String time,
                Value<int?> weekday = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderSettingsCompanion.insert(
                key: key,
                enabled: enabled,
                time: time,
                weekday: weekday,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReminderSettingsTable, ReminderSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReminderSettingsTable,
                    ReminderSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderSettingsTable,
      ReminderSetting,
      $$ReminderSettingsTableFilterComposer,
      $$ReminderSettingsTableOrderingComposer,
      $$ReminderSettingsTableAnnotationComposer,
      $$ReminderSettingsTableCreateCompanionBuilder,
      $$ReminderSettingsTableUpdateCompanionBuilder,
      (
        ReminderSetting,
        BaseReferences<_$AppDatabase, $ReminderSettingsTable, ReminderSetting>,
      ),
      ReminderSetting,
      PrefetchHooks Function()
    >;
typedef $$DayReviewsTableCreateCompanionBuilder = DayReviewsCompanion Function({
  required String date,
  required DayReviewStatus status,
  Value<int> rowid,
});
typedef $$DayReviewsTableUpdateCompanionBuilder = DayReviewsCompanion Function({
  Value<String> date,
  Value<DayReviewStatus> status,
  Value<int> rowid,
});

class $$DayReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $DayReviewsTable> {
  $$DayReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DayReviewStatus, DayReviewStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$DayReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $DayReviewsTable> {
  $$DayReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayReviewsTable> {
  $$DayReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DayReviewStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$DayReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayReviewsTable,
          DayReview,
          $$DayReviewsTableFilterComposer,
          $$DayReviewsTableOrderingComposer,
          $$DayReviewsTableAnnotationComposer,
          $$DayReviewsTableCreateCompanionBuilder,
          $$DayReviewsTableUpdateCompanionBuilder,
          (
            DayReview,
            BaseReferences<_$AppDatabase, $DayReviewsTable, DayReview>,
          ),
          DayReview,
          PrefetchHooks Function()
        > {
  $$DayReviewsTableTableManager(_$AppDatabase db, $DayReviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<DayReviewStatus> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => DayReviewsCompanion(date: date, status: status, rowid: rowid),
          createCompanionCallback:
              ({
                required String date,
                required DayReviewStatus status,
                Value<int> rowid = const Value.absent(),
              }) => DayReviewsCompanion.insert(
                date: date,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayReviewsTable, DayReview>(table),
                  BaseReferences<_$AppDatabase, $DayReviewsTable, DayReview>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayReviewsTable,
      DayReview,
      $$DayReviewsTableFilterComposer,
      $$DayReviewsTableOrderingComposer,
      $$DayReviewsTableAnnotationComposer,
      $$DayReviewsTableCreateCompanionBuilder,
      $$DayReviewsTableUpdateCompanionBuilder,
      (DayReview, BaseReferences<_$AppDatabase, $DayReviewsTable, DayReview>),
      DayReview,
      PrefetchHooks Function()
    >;
typedef $$PgSupervisionTableCreateCompanionBuilder =
    PgSupervisionCompanion Function({
      required String academicYearLabel,
      required int students,
      Value<int> rowid,
    });
typedef $$PgSupervisionTableUpdateCompanionBuilder =
    PgSupervisionCompanion Function({
      Value<String> academicYearLabel,
      Value<int> students,
      Value<int> rowid,
    });

class $$PgSupervisionTableFilterComposer
    extends Composer<_$AppDatabase, $PgSupervisionTable> {
  $$PgSupervisionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get academicYearLabel => $composableBuilder(
    column: $table.academicYearLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get students => $composableBuilder(
    column: $table.students,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PgSupervisionTableOrderingComposer
    extends Composer<_$AppDatabase, $PgSupervisionTable> {
  $$PgSupervisionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get academicYearLabel => $composableBuilder(
    column: $table.academicYearLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get students => $composableBuilder(
    column: $table.students,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PgSupervisionTableAnnotationComposer
    extends Composer<_$AppDatabase, $PgSupervisionTable> {
  $$PgSupervisionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get academicYearLabel => $composableBuilder(
    column: $table.academicYearLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get students =>
      $composableBuilder(column: $table.students, builder: (column) => column);
}

class $$PgSupervisionTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PgSupervisionTable,
          PgSupervisionRow,
          $$PgSupervisionTableFilterComposer,
          $$PgSupervisionTableOrderingComposer,
          $$PgSupervisionTableAnnotationComposer,
          $$PgSupervisionTableCreateCompanionBuilder,
          $$PgSupervisionTableUpdateCompanionBuilder,
          (
            PgSupervisionRow,
            BaseReferences<
              _$AppDatabase,
              $PgSupervisionTable,
              PgSupervisionRow
            >,
          ),
          PgSupervisionRow,
          PrefetchHooks Function()
        > {
  $$PgSupervisionTableTableManager(_$AppDatabase db, $PgSupervisionTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PgSupervisionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PgSupervisionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PgSupervisionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> academicYearLabel = const Value.absent(),
                Value<int> students = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PgSupervisionCompanion(
                academicYearLabel: academicYearLabel,
                students: students,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String academicYearLabel,
                required int students,
                Value<int> rowid = const Value.absent(),
              }) => PgSupervisionCompanion.insert(
                academicYearLabel: academicYearLabel,
                students: students,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PgSupervisionTable, PgSupervisionRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PgSupervisionTable,
                    PgSupervisionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PgSupervisionTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PgSupervisionTable,
      PgSupervisionRow,
      $$PgSupervisionTableFilterComposer,
      $$PgSupervisionTableOrderingComposer,
      $$PgSupervisionTableAnnotationComposer,
      $$PgSupervisionTableCreateCompanionBuilder,
      $$PgSupervisionTableUpdateCompanionBuilder,
      (
        PgSupervisionRow,
        BaseReferences<_$AppDatabase, $PgSupervisionTable, PgSupervisionRow>,
      ),
      PgSupervisionRow,
      PrefetchHooks Function()
    >;
typedef $$PeriodsTableCreateCompanionBuilder = PeriodsCompanion Function({
  Value<int> id,
  required String label,
  required String startDate,
  required String endDate,
  Value<DateTime?> lockedAt,
});
typedef $$PeriodsTableUpdateCompanionBuilder = PeriodsCompanion Function({
  Value<int> id,
  Value<String> label,
  Value<String> startDate,
  Value<String> endDate,
  Value<DateTime?> lockedAt,
});

class $$PeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lockedAt => $composableBuilder(
    column: $table.lockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lockedAt => $composableBuilder(
    column: $table.lockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lockedAt =>
      $composableBuilder(column: $table.lockedAt, builder: (column) => column);
}

class $$PeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeriodsTable,
          Period,
          $$PeriodsTableFilterComposer,
          $$PeriodsTableOrderingComposer,
          $$PeriodsTableAnnotationComposer,
          $$PeriodsTableCreateCompanionBuilder,
          $$PeriodsTableUpdateCompanionBuilder,
          (Period, BaseReferences<_$AppDatabase, $PeriodsTable, Period>),
          Period,
          PrefetchHooks Function()
        > {
  $$PeriodsTableTableManager(_$AppDatabase db, $PeriodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<DateTime?> lockedAt = const Value.absent(),
              }) => PeriodsCompanion(
                id: id,
                label: label,
                startDate: startDate,
                endDate: endDate,
                lockedAt: lockedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                required String startDate,
                required String endDate,
                Value<DateTime?> lockedAt = const Value.absent(),
              }) => PeriodsCompanion.insert(
                id: id,
                label: label,
                startDate: startDate,
                endDate: endDate,
                lockedAt: lockedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PeriodsTable, Period>(table),
                  BaseReferences<_$AppDatabase, $PeriodsTable, Period>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeriodsTable,
      Period,
      $$PeriodsTableFilterComposer,
      $$PeriodsTableOrderingComposer,
      $$PeriodsTableAnnotationComposer,
      $$PeriodsTableCreateCompanionBuilder,
      $$PeriodsTableUpdateCompanionBuilder,
      (Period, BaseReferences<_$AppDatabase, $PeriodsTable, Period>),
      Period,
      PrefetchHooks Function()
    >;
typedef $$TimetableAnswersTableCreateCompanionBuilder =
    TimetableAnswersCompanion Function({
      required String date,
      required int slotId,
      required SlotAnswer answer,
      Value<int> rowid,
    });
typedef $$TimetableAnswersTableUpdateCompanionBuilder =
    TimetableAnswersCompanion Function({
      Value<String> date,
      Value<int> slotId,
      Value<SlotAnswer> answer,
      Value<int> rowid,
    });

final class $$TimetableAnswersTableReferences
    extends
        BaseReferences<_$AppDatabase, $TimetableAnswersTable, TimetableAnswer> {
  $$TimetableAnswersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TimetableSlotsTable _slotIdTable(_$AppDatabase db) => db
      .timetableSlots
      .createAlias('timetable_answers__slot_id__timetable_slots__id');

  $$TimetableSlotsTableProcessedTableManager get slotId {
    final $_column = $_itemColumn<int>('slot_id')!;

    final manager = $$TimetableSlotsTableTableManager(
      $_db,
      $_db.timetableSlots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_slotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimetableAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $TimetableAnswersTable> {
  $$TimetableAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SlotAnswer, SlotAnswer, String> get answer =>
      $composableBuilder(
        column: $table.answer,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$TimetableSlotsTableFilterComposer get slotId {
    final $$TimetableSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableFilterComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimetableAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $TimetableAnswersTable> {
  $$TimetableAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  $$TimetableSlotsTableOrderingComposer get slotId {
    final $$TimetableSlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableOrderingComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimetableAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimetableAnswersTable> {
  $$TimetableAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SlotAnswer, String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  $$TimetableSlotsTableAnnotationComposer get slotId {
    final $$TimetableSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimetableAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimetableAnswersTable,
          TimetableAnswer,
          $$TimetableAnswersTableFilterComposer,
          $$TimetableAnswersTableOrderingComposer,
          $$TimetableAnswersTableAnnotationComposer,
          $$TimetableAnswersTableCreateCompanionBuilder,
          $$TimetableAnswersTableUpdateCompanionBuilder,
          (TimetableAnswer, $$TimetableAnswersTableReferences),
          TimetableAnswer,
          PrefetchHooks Function({bool slotId})
        > {
  $$TimetableAnswersTableTableManager(
    _$AppDatabase db,
    $TimetableAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimetableAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimetableAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimetableAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> slotId = const Value.absent(),
                Value<SlotAnswer> answer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimetableAnswersCompanion(
                date: date,
                slotId: slotId,
                answer: answer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required int slotId,
                required SlotAnswer answer,
                Value<int> rowid = const Value.absent(),
              }) => TimetableAnswersCompanion.insert(
                date: date,
                slotId: slotId,
                answer: answer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TimetableAnswersTable, TimetableAnswer>(table),
                  $$TimetableAnswersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({slotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (slotId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.slotId,
                        referencedTable: $$TimetableAnswersTableReferences
                            ._slotIdTable(db),
                        referencedColumn: $$TimetableAnswersTableReferences
                            ._slotIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TimetableAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimetableAnswersTable,
      TimetableAnswer,
      $$TimetableAnswersTableFilterComposer,
      $$TimetableAnswersTableOrderingComposer,
      $$TimetableAnswersTableAnnotationComposer,
      $$TimetableAnswersTableCreateCompanionBuilder,
      $$TimetableAnswersTableUpdateCompanionBuilder,
      (TimetableAnswer, $$TimetableAnswersTableReferences),
      TimetableAnswer,
      PrefetchHooks Function({bool slotId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfileTableTableManager get profile =>
      $$ProfileTableTableManager(_db, _db.profile);
  $$RatesTableTableManager get rates =>
      $$RatesTableTableManager(_db, _db.rates);
  $$RoleRowsTableTableManager get roleRows =>
      $$RoleRowsTableTableManager(_db, _db.roleRows);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
  $$EntryPhotosTableTableManager get entryPhotos =>
      $$EntryPhotosTableTableManager(_db, _db.entryPhotos);
  $$OtherCategoriesTableTableManager get otherCategories =>
      $$OtherCategoriesTableTableManager(_db, _db.otherCategories);
  $$OtherWorkTableTableManager get otherWork =>
      $$OtherWorkTableTableManager(_db, _db.otherWork);
  $$TimetableSlotsTableTableManager get timetableSlots =>
      $$TimetableSlotsTableTableManager(_db, _db.timetableSlots);
  $$ReminderSettingsTableTableManager get reminderSettings =>
      $$ReminderSettingsTableTableManager(_db, _db.reminderSettings);
  $$DayReviewsTableTableManager get dayReviews =>
      $$DayReviewsTableTableManager(_db, _db.dayReviews);
  $$PgSupervisionTableTableManager get pgSupervision =>
      $$PgSupervisionTableTableManager(_db, _db.pgSupervision);
  $$PeriodsTableTableManager get periods =>
      $$PeriodsTableTableManager(_db, _db.periods);
  $$TimetableAnswersTableTableManager get timetableAnswers =>
      $$TimetableAnswersTableTableManager(_db, _db.timetableAnswers);
}
