// The owner's role rows in V10.1 with their opening balances (SPEC §3.3),
// shared by the domain tests and, later, the demo-seed and import tests.

import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/role_row.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

class OwnerRow {
  const OwnerRow(this.sheetRow, this.info, this.openingInputs);

  final int sheetRow;
  final RoleRowInfo info;
  final Map<InputColumn, double> openingInputs;

  WorkbookInputs get inputs => WorkbookInputs(openingInputs);
}

const _dsa = 'Data Structures and Algorithms';
const _ood = 'Object Oriented Design Patterns and Principles';
const _devOps = 'DevOps Engineering';

const ee3202Teacher = OwnerRow(
  129,
  RoleRowInfo(
    moduleCode: 'EE3202',
    batch: '25th',
    moduleName: _dsa,
    moduleType: ModuleType.taught,
    role: Role.teacher,
  ),
  {InputColumn.ac: 74, InputColumn.ad: 1},
);
const ec3202Teacher = OwnerRow(
  165,
  RoleRowInfo(
    moduleCode: 'EC3202',
    batch: '25th',
    moduleName: _dsa,
    moduleType: ModuleType.taught,
    role: Role.teacher,
  ),
  {InputColumn.ac: 193, InputColumn.ad: 1},
);
const ec5204SecondExaminer25 = OwnerRow(
  291,
  RoleRowInfo(
    moduleCode: 'EC5204',
    batch: '25th',
    moduleName: _ood,
    moduleType: ModuleType.taught,
    role: Role.secondExaminer,
  ),
  {},
);
const ec5406Teacher = OwnerRow(
  310,
  RoleRowInfo(
    moduleCode: 'EC5406',
    batch: '25th',
    moduleName: 'Software Group Project',
    moduleType: ModuleType.project,
    role: Role.teacher,
    students: 200,
  ),
  {InputColumn.x: 200, InputColumn.ae: 50},
);
const ec5207SecondExaminer = OwnerRow(
  318,
  RoleRowInfo(
    moduleCode: 'EC5207',
    batch: '25th',
    moduleName: _devOps,
    moduleType: ModuleType.taught,
    role: Role.secondExaminer,
    students: 180,
  ),
  {},
);
const ec5207Moderator = OwnerRow(
  319,
  RoleRowInfo(
    moduleCode: 'EC5207',
    batch: '25th',
    moduleName: _devOps,
    moduleType: ModuleType.taught,
    role: Role.moderator,
    students: 180,
  ),
  {},
);
const ec5208Teacher = OwnerRow(
  321,
  RoleRowInfo(
    moduleCode: 'EC5208',
    batch: '25th',
    moduleName: 'Mobile Application Development',
    moduleType: ModuleType.taught,
    role: Role.teacher,
  ),
  {},
);
const ec5204SecondExaminer24 = OwnerRow(
  400,
  RoleRowInfo(
    moduleCode: 'EC5204',
    batch: '24th',
    moduleName: _ood,
    moduleType: ModuleType.taught,
    role: Role.secondExaminer,
  ),
  {},
);

/// All 8 rows in workbook order.
const ownerRows = [
  ee3202Teacher,
  ec3202Teacher,
  ec5204SecondExaminer25,
  ec5406Teacher,
  ec5207SecondExaminer,
  ec5207Moderator,
  ec5208Teacher,
  ec5204SecondExaminer24,
];
