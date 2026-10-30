# Workload Logger — Build Plan

Work top to bottom, one milestone per session. Start each milestone in plan mode, agree the plan,
build, run on the phone, then tick the boxes and commit.
Definition of done for every milestone: `flutter analyze` clean · `flutter test` green ·
runs on the Android phone · boxes ticked · git commit.

## Phase 1 — Personal logger (v1)

### M0 · Project foundation
- [ ] Flutter project `workload_logger` (org `lk.ac.ruh.eie`), Android only for now, minSdk 24
- [ ] Packages from CLAUDE.md added with `flutter pub add`
- [ ] Plus Jakarta Sans TTFs (400, 500, 600, 700, 800) in `assets/fonts/`, registered in pubspec
- [ ] `core/theme/tokens.dart` + `app_theme.dart` from SPEC §11
- [ ] Folder structure from CLAUDE.md; `analysis_options.yaml` with flutter_lints
- [ ] go_router shell: bottom bar (Today, History, Log, Summary, Setup) with placeholder screens
- [ ] Raised gold Log button opens a full-screen placeholder route
- [ ] App name "Workload Logger", simple navy/gold launcher icon (placeholder OK)

### M1 · Domain and credit maths (pure Dart, no UI)
- [ ] Enums: Role, ModuleType, Activity, Subtype, Category (11 summary categories)
- [ ] `RateSet` with defaults from SPEC §3.1
- [ ] `workbook_mapping.dart`: activity/subtype ↔ Data_Entry columns (SPEC §3.2)
- [ ] `credit_calculator.dart`: per-entry credit, per-role-row inputs → 11 categories (SPEC §4)
- [ ] Roll-up of entries → workbook inputs incl. weighted Qs/paper (SPEC §7.1)
- [ ] Activity availability by role and module type (SPEC §5)
- [ ] Unit tests for every fixture in SPEC §13

### M2 · Database
- [ ] Drift tables from SPEC §6, database class, migrations set up (schemaVersion 1)
- [ ] Repositories: profile, rates, roleRows, entries (+ soft delete/undo), photos, otherWork,
      timetable, reminderSettings, dayReviews, pg, periods
- [ ] Riverpod providers exposing streams (today's entries, totals, drafts…)
- [ ] Demo seed (SPEC §3.3 rows + opening balances), flagged as demo, removable
- [ ] Repository tests on an in-memory database

### M3 · Workbook import + onboarding
- [ ] Import service: rates by label (SPEC §3.1), staff list, role rows, PG count, opening balances
- [ ] Graceful handling of known issues (SPEC §3.5); rate warnings collected
- [ ] Onboarding screens (SPEC §8.9): welcome → load workbook → pick name → reminder time → Today
- [ ] "Try with demo data" path
- [ ] Test: importing `docs/reference/DEIE_Workload_Model_V10_1.xlsx` gives 8 rows and 78.7 h

### M4 · Logging flow
- [ ] StepHeader, ActivityTile, SegmentedChoice, CountStepper, CreditStrip, DateChips widgets
- [ ] Step 1 Which module (SPEC §8.2), merged codes, batch handling, Other-work entry point
- [ ] Step 2 What did you do (SPEC §8.3), activities by role/type, role grouping (EC5207)
- [ ] Step 3 Type + count (SPEC §8.4) with live credit, Qs/paper for marking, date, optional fields, photo
- [ ] Save / Save as draft; remembered defaults (last subtype, last Qs/paper)
- [ ] Saved screen (SPEC §8.5) with Done / Log another / Undo
- [ ] Other-work form (category, time spent, note)
- [ ] Widget tests: quiz 10 → "+1.0 h"; switching to Structured → "15.0 h"

### M5 · Today
- [ ] Greeting, hero card with today / week / year totals (SPEC §8.1)
- [ ] Timetable suggestion cards with Yes / Other hours / No
- [ ] Logged today list (tap to edit), Quick log chips, zero-rows nudge
- [ ] Empty states

### M6 · History and drafts
- [ ] All entries grouped by day; Drafts tab with Finish / Discard
- [ ] Batch progress cards for marking
- [ ] Edit sheet + delete with undo snackbar; locked periods read-only

### M7 · Summary and export
- [ ] Period selector, hero, category bars, zero chips, role-row list + detail (SPEC §8.7)
- [ ] Export `.xlsx` with 4 sheets (SPEC §7.3) via share sheet
- [ ] Evidence-log export
- [ ] Close period (lock)
- [ ] Test: exported My Data_Entry rows reproduce the fixture hours

### M8 · Setup, timetable and reminders
- [ ] Setup screen sections (SPEC §8.8): workload file, rates view, timetable CRUD, reminders,
      PG students, other-work categories, submission date, remove demo data
- [ ] Notifications (SPEC §9): evening, next-morning, weekly, submission; actions Log work /
      Lecture done / Nothing; deep links into the log flow with the right date
- [ ] Android 13 notification permission flow; reschedule on start, settings change and save

### M9 · Polish and release
- [ ] Accessibility pass (labels, 44 dp targets, text scaling to 1.3×)
- [ ] Validation warnings (SPEC §12)
- [ ] Final launcher icon and splash in navy/gold
- [ ] `flutter build apk --release`, install on the phone, one week of real use

## Phase 2 — Smarter capture
- [ ] Quick text entry parser + confirmation card (SPEC §10), then voice input (speech_to_text)
- [ ] Home-screen widget (home_widget) with recent modules and "+"
- [ ] Backup to the owner's Google Drive app folder + restore; "Backed up" status in Setup
- [ ] Weekly review screen; calendar hints from device calendar
- [ ] Photos bundled into evidence export (zip)
- [ ] iOS build (if needed)

## Phase 3 — Department version (only if the department wants it)
- [ ] Admin uploads Teacher List + rates once a year; each staff member logs their own work
- [ ] Compiler receives combined Data_Entry for all staff (replaces regenerate.py)
- [ ] Accounts, sync, permissions — needs a separate design round
