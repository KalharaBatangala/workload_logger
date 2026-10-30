# Workload Logger — instructions for Claude Code

A personal Android app (Flutter) for **Kalhara Batangala**, Lecturer, Department of Electrical
and Information Engineering (DEIE), University of Ruhuna. It lets him log academic work on his
phone as it happens (or later the same day), and at the end of the period produces **his own rows
of the DEIE Workload Model workbook (V10.1), in the workbook's exact column layout**, so nothing
is retyped.

## Read before you work

- `docs/SPEC.md` — the full product spec: workload rules, data model, every screen, design tokens,
  reminder logic, import/export. Read the sections relevant to your task before changing code.
- `docs/PLAN.md` — milestones with checkboxes. Work on ONE milestone at a time, in order.
- `docs/design/` — screenshots of the approved screens. The UI must match them closely.
- `docs/reference/DEIE_Workload_Model_V10_1.xlsx` — the real workbook, used for import tests.

## The one rule that matters most

The workload model credits **counted outputs × fixed rates**, never time spent.
10 quiz questions prepared = 10 × 0.1 h = 1.0 h, no matter how long it took.

- Store **counts**, never credited hours. Hours are always derived from counts + current rates.
- "Time actually spent" is an optional, private field. It never feeds any credited total.
- Rates come from the imported Admin_Config sheet, never hard-coded in UI code.
  The defaults in SPEC §3.1 are only for tests and as a fallback.
- All credit maths lives in ONE place: `lib/domain/credit_calculator.dart` (pure functions,
  fully unit-tested against the fixtures in SPEC §13).

## Tech stack (decided — ask before changing or adding packages)

- Flutter stable, Dart 3, Material 3. Android first (minSdk 24); keep code platform-neutral for iOS later.
- State: `flutter_riverpod` (Notifier / AsyncNotifier providers).
- Local database: `drift` (SQLite). Offline-first; the database is the single source of truth.
- Navigation: `go_router`, `StatefulShellRoute.indexedStack` for the bottom bar.
- Excel import/export: `excel`. Files and sharing: `file_picker`, `share_plus`, `path_provider`.
- Photos: `image_picker`. IDs: `uuid`. Dates and formatting: `intl`.
- Notifications: `flutter_local_notifications`, `timezone`, `flutter_timezone`.
- Font: Plus Jakarta Sans, bundled as asset TTFs (weights 400–800). No runtime font downloads.
- Add packages with `flutter pub add <name>`; never hand-type version numbers.
- No network access in v1. The app must fully work in airplane mode.

## Project structure

```
lib/
  main.dart                 app entry, ProviderScope, timezone + notification init
  app.dart                  MaterialApp.router, theme, router
  core/theme/               tokens.dart (colours, type, radii, spacing), app_theme.dart
  core/widgets/             shared components (see SPEC §11.4)
  core/router.dart
  domain/                   pure Dart: enums, models, rates, credit_calculator, workbook_mapping,
                            quick_entry_parser (phase 2)
  data/db/                  drift tables + database
  data/repositories/        one repository per aggregate (entries, role rows, rates, settings…)
  data/workbook/            xlsx import + export
  features/<feature>/       today, log, history, summary, setup, reminders
                            (each: screens/, widgets/, providers.dart)
test/                       mirrors lib/; domain tests need no Flutter
```

## Coding rules

- No business logic in widgets. Widgets read providers; providers call repositories and domain.
- One screen per file. Keep widgets small; extract repeated UI into `core/widgets/`.
- Colours, text styles, radii and spacing come ONLY from `core/theme/tokens.dart`. No hex in widgets.
- Every tappable element is at least 44×44 dp; icon-only buttons get a `Semantics`/tooltip label.
- Hours are displayed with one decimal and an "h" (`1.0 h`, `+4.5 h`). Keep full precision internally.
- Dates are stored as local calendar dates (`yyyy-MM-dd`). Times are stored separately.
- Never edit generated files (`*.g.dart`). Regenerate with build_runner.
- Demo or sample data must be clearly flagged and removable from Setup.
- Do not invent workload rules. If the spec does not cover a case, stop and ask
  (open questions are listed in SPEC §14).

## Commands

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run                      # on the connected Android phone
flutter build apk --release
```

A task is done only when `flutter analyze` shows no issues and `flutter test` passes.

## How to work with me

- I'm new to Flutter app architecture. When you finish a step, explain in a few plain sentences
  what you built, why you built it that way, and exactly how I can try it on my phone.
- Start each milestone with a short plan and wait for my OK before writing lots of code.
- After a milestone: tick its boxes in `docs/PLAN.md` and suggest a git commit message.
- Prefer small, reviewable changes over large rewrites.
- If something in the design screenshots conflicts with the spec, follow the spec and tell me.

## Glossary

- **Role row**: one row of the workbook's Data_Entry sheet = one module + batch + staff + role.
  Roles: Coordinator, Teacher, Second Examiner, Moderator.
- **CA**: continuous assessment (quizzes, mid-semester tests, assignments). **End exam**: end-semester exam.
- **Papers marked × Qs/paper**: how the workbook counts marking (answers marked = papers × questions per paper).
- **Credited hours**: hours the workload model awards. **Time spent**: what it actually took (private).
- **Entry**: one logged piece of work (a count on a date). **Draft**: an entry missing information.
- **Other work**: work the model does not count (research, advising, committees…). Kept separate.
- **Opening balance**: values already present in the workbook when it was imported.
