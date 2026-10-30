# Workload Logger — Product Specification (v1)

Owner: Kalhara Batangala (Lecturer, DEIE, University of Ruhuna) · kalhara.b@eie.ruh.ac.lk
Status: approved concept and screen designs, 29 Oct 2026. Source workbook: DEIE_Workload_Model_V10_1.xlsx

Contents
1. Purpose and users
2. Core concept: counts × rates
3. The source workbook
4. Credit rules (exact formulas)
5. Activity catalogue
6. Data model
7. Roll-up, import and export
8. Screens
9. Reminders
10. Quick text entry (phase 2)
11. Design system
12. Validation and edge cases
13. Test fixtures
14. Open questions
15. Out of scope for v1

---

## 1. Purpose and users

The department records each academic's workload in an Excel workbook. Staff forget to fill it in at
the time, then reconstruct it weeks later. This app lives on the lecturer's phone so that a piece of
work (e.g. "prepared a 10-question quiz for EC5208") can be logged in under 15 seconds, the same day
or the next, and the workbook rows are produced automatically.

v1 user: one person (the owner). Data stays on the phone. No accounts, no server.

Design principles
1. Count, don't time.
2. Only your modules, only your roles — never type a module code.
3. Three taps and a number.
4. Logging late is fine (Today / Yesterday / pick a date).
5. Capture now, finish later (drafts).
6. Show the credit immediately after saving.
7. Works with no signal.
8. The output matches the workbook exactly.

## 2. Core concept: counts × rates

Every input column in the workbook is one of three kinds:

| Kind | Examples | What the user enters |
| --- | --- | --- |
| Count × rate | questions prepared, papers marked, students evaluated, labs prepared first time, projects supervised | a number |
| Actual hours | lecture hours conducted | hours (0.5 steps) |
| Flat per role | Coordination 10 h (taught) / 25 h (project); Moderator 2 h per module | nothing — automatic |

## 3. The source workbook

Sheets: README, Admin_Config, Teacher List, Staff_List, Data_Entry, PG_Project_Supervision,
(hidden) Copy of PG_Project_Supervision, Workload_Summary.

The app reads **Admin_Config**, **Data_Entry**, **Staff_List** and **PG_Project_Supervision**.

### 3.1 Admin_Config — rates (hours)

Match rates by the **label text in column A** (trimmed, case-insensitive), not by cell address —
the department's own regenerate script does the same. Column B holds a number or a simple formula
like `=6/60`; evaluate `=a/b`, `=a*b`, `=a` patterns. If a label is missing or unparseable, use the
default below and show a warning in Setup.

| key | label in column A | cell | default (h) |
| --- | --- | --- | --- |
| creditHours | Hours allocated per 1 credit (reference) | B5 | 14 (info only) |
| coordTaught | Module Coordination - Taught module (per semester) | B6 | 10 |
| coordProject | Module Coordination - Project module (per semester) | B7 | 25 |
| secondMarkPaper | Second marking - End exam (hours per paper) | B8 | 0.1 (=6/60) |
| moderator | Moderator (per module, per semester) | B9 | 2 |
| labFirstTime | Lab preparation - first time only (per lab) | B10 | 20 |
| caPrepQuiz | Quiz question (section 2) | B13 | 0.1 (=6/60) |
| caPrepStructured | Structured question (section 2) | B14 | 1.5 |
| caPrepEssay | Essay question (section 2) | B15 | 2 |
| caPrepProject | Project-type CA preparation | B16 | 5 |
| examPrepMcq | MCQ question (section 3) | B19 | 0.1 |
| examPrepStructured | Structured question (section 3) | B20 | 1.5 |
| examPrepEssay | Essay question (section 3) | B21 | 2 |
| examPrepProject | Project-type end exam preparation | B22 | 5 |
| caMarkQuiz | CA - Quiz | B25 | 0 |
| caMarkStructured | CA - Structured | B26 | 0.1 (=6/60) |
| caMarkEssay | CA - Essay | B27 | 0.1 (=6/60) |
| caMarkProject | CA - Project evaluation | B28 | 0.2 (=12/60) |
| examMarkMcq | Exam - MCQ | B31 | 0.002 |
| examMarkStructured | Exam - Structured | B32 | 0.1 |
| examMarkEssay | Exam - Essay | B33 | 0.1 |
| examMarkProject | Exam - Project evaluation | B34 | 0.2 (=12/60) |
| projectSupervision | Project supervision (per project) | B37 | 30 |
| itEvaluation | Industrial Training Evaluation | B40 | 0.3 (=18/60) |
| pgSupervision | (not in Admin_Config — see §3.4) | — | 50 per student per year |

Note: "Quiz question", "Structured question" and "Essay question" labels appear in BOTH section 2
(CA prep, rows 12–16) and section 3 (end exam, rows 18–22). Disambiguate by the section heading
row above them ("2. CONTINUOUS ASSESSMENT…" / "3. END-OF-SEMESTER EXAM…"). The same applies to section 4
vs section 5 labels.

### 3.2 Data_Entry — columns

Header rows are 3 and 4; data starts at row 5 (rows 5–931 in V10.1). Stop at the first fully empty
row; skip rows whose column A or G is empty or "NA".

Descriptor columns: A Module Code · B Batch · C Module Name · D Module Type (Taught/Project) ·
E Credits · F Total No. of Students · G Staff Name · H Role.

Input columns (the app produces these):

| col | meaning | activity / subtype |
| --- | --- | --- |
| I | Lecture hours conducted | lecture |
| J | CA prep — Quiz: questions prepared | caPrep / quiz |
| K | CA prep — Structured: questions prepared | caPrep / structured |
| L | CA prep — Essay: questions prepared | caPrep / essay |
| M | CA prep — Project: assessments prepared | caPrep / project |
| N | End exam prep — MCQ: questions prepared | examPrep / mcq |
| O | End exam prep — Structured | examPrep / structured |
| P | End exam prep — Essay | examPrep / essay |
| Q | End exam prep — Project: assessments | examPrep / project |
| R, S | CA marking — Quiz: papers marked, Qs/paper | caMarking / quiz |
| T, U | CA marking — Structured: papers, Qs/paper | caMarking / structured |
| V, W | CA marking — Essay: papers, Qs/paper | caMarking / essay |
| X | CA — Project: students evaluated | caMarking / project |
| Y, Z | End exam marking — MCQ: papers, Qs/paper | examMarking / mcq |
| AA, AB | End exam marking — Structured: papers, Qs/paper | examMarking / structured |
| AC, AD | End exam marking — Essay: papers, Qs/paper | examMarking / essay |
| AE | End exam — Project: students evaluated | examMarking / project |
| AF | 2nd marking — end-exam papers marked | secondMarking |
| AG | Labs prepared first time | labFirstTime |
| AH | UG projects supervised | projectSupervision |
| AI | Industrial Training students evaluated | itEvaluation |

Hours columns (computed): AJ Coordination · AK 2nd Marking · AL Moderator · AM Teaching ·
AN CA Prep · AO Exam Prep · AP CA Marking · AQ Exam Marking · AR Lab Prep · AS Project Supervision ·
AT Industrial Training · AU TOTAL. These 11 categories are the app's summary categories.

### 3.3 Identity and role rows

On first import the user picks their name from Staff_List (B4:B78) — for the owner,
`Mr. Kalhara Batangala`. Role rows = Data_Entry rows where column G equals that name
(compare after trimming and collapsing whitespace).

The owner's rows in V10.1 (for fixtures and demo seed):

| sheet row | code | batch | name | type | credits | students | role | existing inputs |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 129 | EE3202 | 25th | Data Structures and Algorithms | Taught | 0 | 0 | Teacher | AC=74, AD=1 |
| 165 | EC3202 | 25th | Data Structures and Algorithms | Taught | 0 | 0 | Teacher | AC=193, AD=1 |
| 291 | EC5204 | 25th | Object Oriented Design Patterns and Principles | Taught | 0 | 0 | Second Examiner | — |
| 310 | EC5406 | 25th | Software Group Project | Project | 4 | 200 | Teacher | X=200, AE=50 |
| 318 | EC5207 | 25th | DevOps Engineering | Taught | 2 | 180 | Second Examiner | — |
| 319 | EC5207 | 25th | DevOps Engineering | Taught | 2 | 180 | Moderator | — |
| 321 | EC5208 | 25th | Mobile Application Development | Taught | 0 | 0 | Teacher | — |
| 400 | EC5204 | 24th | Object Oriented Design Patterns and Principles | Taught | 0 | 0 | Second Examiner | — |

### 3.4 PG_Project_Supervision

Column B = staff name (formula linking to Staff_List), C = number of PG students supervised,
D = C × 50. The 50 h rate is typed into the formula (the sheet's note wrongly says it is in
Admin_Config "Section 9"). The app keeps a single editable number per academic year
(Setup → Postgraduate supervision) and exports it on its own sheet.

### 3.5 Known workbook issues (handle gracefully, never crash)

- Workload_Summary "DEPARTMENT TOTAL" row contains `#REF!` — the app never reads Workload_Summary.
- PG rate is hard-coded 50 (see §3.4).
- Credits and No. of Students are 0 on several rows → student-count validation is skipped when 0.
- Data_Entry D402 has a typo validation list ("Coordinated,Project") — treat any D value other than
  "Project" as Taught.
- Row 914 contains junk ("NA" values) — skip.
- There are currently no Industrial Training rows; IT evaluation appears only if such a row exists.

## 4. Credit rules (exact formulas)

Given a role row's input values (I…AI) and the rate set R:

```
coordination   = role == Coordinator ? (type == Project ? R.coordProject : R.coordTaught) : 0
secondMarking  = role == Second Examiner ? AF × R.secondMarkPaper : 0
moderator      = role == Moderator ? R.moderator : 0
teaching       = I
caPrep         = J×R.caPrepQuiz + K×R.caPrepStructured + L×R.caPrepEssay + M×R.caPrepProject
examPrep       = N×R.examPrepMcq + O×R.examPrepStructured + P×R.examPrepEssay + Q×R.examPrepProject
caMarking      = R×S×R.caMarkQuiz + T×U×R.caMarkStructured + V×W×R.caMarkEssay + X×R.caMarkProject
examMarking    = Y×Z×R.examMarkMcq + AA×AB×R.examMarkStructured + AC×AD×R.examMarkEssay + AE×R.examMarkProject
labPrep        = AG × R.labFirstTime
supervision    = AH × R.projectSupervision
industrial     = AI × R.itEvaluation
total          = sum of the 11 above
```

Coordination and Moderator hours are credited **automatically** whenever the role row exists
(this matches the workbook's formulas). The user never logs them.

Per-entry credit (shown on "Saved", in History, etc.) = that entry's contribution using the same
rates, e.g. caPrep/quiz with count 10 → 10 × R.caPrepQuiz.

## 5. Activity catalogue

Activities offered depend on the role(s) and module type of the chosen module.

| activity | label in app | roles | module type | subtypes | inputs | credit |
| --- | --- | --- | --- | --- | --- | --- |
| lecture | Lecture conducted | Teacher | any | — | hours (0.5 steps) | hours |
| caPrep | Prepared CA | Teacher | Taught: quiz, structured, essay, project · Project: project | | count (questions; "assessments" for project) | count × rate |
| examPrep | Prepared end exam | Teacher | Taught: mcq, structured, essay, project · Project: project | | count | count × rate |
| caMarking | Marked CA | Teacher | Taught: quiz, structured, essay, project · Project: project | | papers + Qs/paper (project: students) | papers × qpp × rate |
| examMarking | Marked end exam | Teacher | Taught: mcq, structured, essay, project · Project: project | | papers + Qs/paper (project: students) | papers × qpp × rate |
| labFirstTime | New lab prepared | Teacher | Taught | — | number of labs | × 20 |
| projectSupervision | Projects supervised | Teacher | Project (also under "More" for Taught) | — | number of projects | × 30 |
| itEvaluation | IT students evaluated | Teacher | module name contains "Industrial Training" | — | students | × 0.3 |
| secondMarking | Papers second-marked | Second Examiner | any | — | papers | × 0.1 |
| moderationDone | Moderation done | Moderator | any | — | one tap | 0 (status only — hours are automatic) |
| other | Other work | any (not tied to a role row) | — | category | time spent + note | not credited |

Coordinator rows show an information card ("Coordination is credited automatically: 10 h") and no
activities.

When a module code has several role rows (EC5207: Second Examiner + Moderator), Step 2 shows the
activities of all its roles, grouped under role headings. When a code has two batches (EC5204 24th
and 25th), Step 1 lists it once ("24th and 25th") and Step 2 first shows a two-chip batch picker.

Remembered defaults: the last Qs/paper used for (role row, activity, subtype) pre-fills the next
marking entry; the last subtype used per (role row, activity) is pre-selected.

## 6. Data model (drift tables)

```
profile           id=1, staffName, displayName, academicYearLabel ("2025/26"),
                  workbookFileName, importedAt, submissionDate?, onboardingDone
rates             key PK, label, hours REAL, sourceCell, isDefault BOOL
role_rows         id PK, moduleCode, batch, moduleName, moduleType ('Taught'|'Project'),
                  credits, students, role, sheetRow, isActive
entries           id TEXT uuid PK, roleRowId FK?, date TEXT yyyy-MM-dd, activity, subtype?,
                  count REAL?, questionsPerPaper INT?, spentMinutes INT?, note?,
                  status ('complete'|'draft'), source ('manual'|'timetable'|'notification'|
                  'quickText'|'import'), rawText?, createdAt, updatedAt, deletedAt?
entry_photos      id PK, entryId FK, filePath, createdAt
other_work        id uuid PK, date, categoryId FK, spentMinutes, note?, createdAt
other_categories  id PK, name, sortOrder   (seed: Research, Administration / committees,
                  Student advising, Lab sessions conducted, Outreach, Self-development)
timetable_slots   id PK, roleRowId FK, kind ('lecture'|'lab'), weekday 1–7, start 'HH:mm', end 'HH:mm'
reminder_settings key PK ('evening'|'morning'|'weekly'|'submission'), enabled, time 'HH:mm', weekday?
day_reviews       date PK, status ('nothingToLog'|'reviewed')
pg_supervision    academicYearLabel PK, students INT
periods           id PK, label, startDate, endDate, lockedAt?   (closing a period makes its entries read-only)
```

Entries are soft-deleted (deletedAt) so "Undo" works. Drafts never count towards any total.

## 7. Roll-up, import and export

### 7.1 Roll-up (entries → workbook inputs)

For each role row, over complete, non-deleted entries in the selected period:
- I, J…Q, X, AE, AF, AG, AH, AI = sum of counts for the matching activity/subtype.
- Marking pairs (R/S, T/U, V/W, Y/Z, AA/AB, AC/AD): papers = sum of papers; Qs/paper =
  sum(papers × qpp) / sum(papers), written at full precision (never rounded in the file; display
  may round), so that papers × qpp reproduces the hours exactly even when batches used different
  Qs/paper.
- Opening-balance entries (source = import) are included like any other entry.

### 7.2 Import (Setup → Load workbook)

1. Pick an .xlsx with file_picker. Parse with `excel`.
2. Read rates (§3.1), staff names (Staff_List), the owner's role rows (§3.3), PG count (§3.4).
3. Show a preview: name, number of role rows, any rate warnings. Confirm.
4. First import: create role rows and convert every non-zero input on those rows into
   opening-balance entries (source = import, date = import date, note "From workbook V10.1").
5. Re-import (new year or corrected workbook): replace rates; match role rows by (code, batch, role);
   keep all manual entries; entries whose role row disappeared are flagged in History
   ("module no longer in workbook") rather than deleted. Ask before replacing opening balances.

### 7.3 Export (Summary → Export)

**Export my Data_Entry rows (.xlsx)**, file name `Workload_<StaffName>_<yyyy-MM-dd>.xlsx`, shared via
the Android share sheet. Sheets:
1. `My Data_Entry` — header rows identical to Data_Entry rows 3–4, then one row per role row in the
   workbook's order (columns A–H descriptors, I–AI inputs from §7.1, AJ–AU hours as values), then a
   totals row.
2. `Evidence log` — every entry: date, module, batch, role, activity, subtype, count, Qs/paper,
   credited h, time spent, note, photo count, logged at.
3. `Other work` — date, category, time spent, note.
4. `PG supervision` — students, hours.

**Export evidence log** — sheet 2 alone (optionally with photos zipped together; phase 2).

## 8. Screens

Phone frame 390 × 844 logical px. Light theme only in v1. Match `docs/design/` screenshots.

### 8.0 Navigation

Bottom bar on the four main tabs, height 86, white with a top border, five items:
Today (home icon) · History (clock) · **Log** (centre, raised 58×58 gold rounded-square with a
navy "+", 28 px above the bar) · Summary (bar-chart) · Setup (sliders). Active item navy + bold,
inactive grey. "Log" opens the logging flow as a full-screen route (no bottom bar).

### 8.1 Today (home)

Top to bottom, 20 px side padding, 18 px gaps:
1. Date line "Thursday, 29 October" (muted 13) + greeting "Good evening, Kalhara" (24/800;
   morning/afternoon/evening by time). Right: 44 px bell button → reminder settings.
2. **Hero card** (navy, radius 22): overline "CREDITED TODAY" (cream), entry count; big number
   "1.0" (48/800) + "hours"; divider; two stats: "4.8 h this week", "79.7 h this academic year".
   Week = Monday–Sunday.
3. **Timetable suggestion card** (only when today has an un-answered timetable slot): gold-border
   card, overline "FROM YOUR TIMETABLE", title "EC5208 lecture, 10:00 – 12:00", subtitle
   "Mobile Application Development · Did you conduct it?". Buttons: "Yes, 2 h" (navy, logs a lecture
   entry with the slot duration, source = timetable) · "Other hours" (opens Step 3 for lecture) ·
   "No" (dismisses for today). One card per slot.
4. **Logged today**: section title + "See all" (→ History). Entry rows: module badge, activity +
   subtype, detail line ("10 questions · logged 9:40 pm"), credit "+1.0 h" in gold-text. Tap to edit.
   Empty state: "Nothing logged yet today."
5. **Quick log** chips: the 3 most recently used modules (→ Step 2 with module pre-selected) +
   dashed "All modules" chip (→ Step 1).
6. **Zero-rows nudge** (gold-tint card, only if any non-automatic role row has no entries):
   "3 of your role rows are still at zero" + list of them → Summary.

### 8.2 Log — Step 1 "Which module?"

Full-screen. Header: close (X) · "Log work" · date chip (navy pill, "Today"; tap → date sheet with
Today / Yesterday / calendar). Progress: three 4 px bars, filled gold for completed steps.
Title "Which module?" (22/800).
- Quick entry text field "Or type: EC5208 quiz 10 questions" + mic button (phase 2 — in v1 show
  the field disabled with "Coming soon", or hide behind a feature flag).
- RECENT: the most recently used module as a large card with a 2 px gold border.
- ALL YOUR MODULES: one white card listing one row per module code (roles and batches merged):
  code badge, module name, "Teacher · 25th · Project" style subtitle. Last row: "Other — work
  outside the model" (dashed badge) → Other-work form.

### 8.3 Log — Step 2 "What did you do?"

Back button, same header and progress (2 of 3). Navy module strip (code badge in gold, name,
"Teacher · 25th batch", "Change" → Step 1). A 2-column grid of 128 px activity tiles (icon in a
40 px rounded square, title 15/700, hint 12 muted). Tiles for a Taught Teacher row:
Lecture conducted ("Enter hours") · Prepared CA ("Quiz, structured, essay, project") ·
Prepared end exam ("MCQ, structured, essay, project") · Marked CA ("Papers or students") ·
Marked end exam ("First marking, in batches") · New lab prepared ("First time only · 20 h each").
The most likely tile (last used for this module) gets a 2 px gold border.
Footer note: "Only Teacher activities are shown for EC5208…".

### 8.4 Log — Step 3 "Type + count"

Back, progress 3 of 3, module badge + activity title ("Prepared CA").
- TYPE: segmented control (4 options) in a pale track; selected = navy fill, white text.
- Count card (white, radius 20): label ("Questions prepared" / "Assessments prepared" /
  "Papers marked" / "Students evaluated" / "Hours"), big number (56/800) between a − button
  (outlined) and a + button (navy), quick-set chips (5, 10, 20; for marking also 25, 50; tap the
  number to type with the numeric keyboard).
- Marking only: a second smaller stepper "Questions per paper" (pre-filled from memory).
- **Live credit strip** (gold-soft): "10 × 6 min credited" on the left, "1.0 h" on the right;
  updates instantly with type and count. Format each rate in a friendly way: from 1 min to under
  1 h → minutes ("6 min", "12 min", "18 min"); under 1 min → hours with 3 decimals ("0.002 h");
  1 h or more → hours ("1.5 h", "20 h").
- WHEN: Today / Yesterday / Pick date (outlined chips, selected = 2 px navy border).
- OPTIONAL card: "Time actually spent" (e.g. "1 h"), "Note", "Add a photo as evidence".
- Sticky footer: navy "Save" button with a gold pill "+1.0 h". If required data is missing,
  the button reads "Save as draft".

### 8.5 Saved

Navy full screen. Gold 96 px circle with check; "+1.0 h" (44/800); "credited to CA Prep" (cream).
Detail card: module badge + name, "Prepared CA · Quiz · 10 questions · Today"; if time spent was
entered: "You spent 1 h; the model credits 1.0 h." plus "The rate matches your real time." when
within ±25 %, otherwise "This took longer/shorter than the model assumes." Three stat tiles: today,
this week, this year. Buttons: "Done" (gold, → Today), "Log another" (outlined, → Step 1),
"Undo" (text; soft-deletes the entry, → Step 3 with values restored).

### 8.6 History

Title "History". Segmented "All entries | Drafts · n".
- Draft cards (gold-soft): "DRAFT · NEEDS A COUNT", title, source text (e.g. the quick note),
  "Finish entry" (navy → Step 3 pre-filled) and "Discard".
- Batch progress cards for marking in progress: "EC3202 end-exam marking · 19.3 h", progress bar
  papers/students (target = module students when > 0), "193 of 193 papers · logged in 4 batches".
- Entries grouped by day, newest first ("TODAY · THU 29 OCT", "MON 26 OCT"). Other-work entries
  show a dashed "Other" badge and plain hours without "+", labelled "not in the workload model".
- Tap an entry → edit sheet (all Step 3 fields + delete). Locked periods are read-only.

### 8.7 Summary

Title "Summary" + period selector chip ("2025/26", also each semester/custom range).
- Hero (navy): "CREDITED THIS ACADEMIC YEAR", "79.7 hours", "Plus 2 h of other work, kept outside the model".
- "By category": horizontal bars for non-zero categories, sorted by hours, width relative to the
  largest; the category touched most recently uses the gold bar. Under a divider: "Nothing logged yet"
  chips for zero categories.
- "Your role rows": one line per role row: code badge, role (+ batch where needed), hours, or a
  gold "Nothing yet" pill. Tap → role-row detail (inputs I–AI as the workbook will receive them).
- Buttons: "Export my Data_Entry rows (.xlsx)" (navy, download icon) and
  "Export evidence log (every entry)" (outlined). Also "Close this period" in an overflow menu.

### 8.8 Setup

Sections:
- WORKLOAD FILE: card with spreadsheet icon, "DEIE Workload Model V10.1", "8 role rows for you ·
  rates from Admin_Config", button "Load a newer workbook". Tapping the card opens rates (read-only list).
- MY TIMETABLE: slot rows (code badge, Lecture/Lab, "Thu 10:00 – 12:00") + "Add a class slot".
- REMINDERS: four toggles with subtitles — Evening check-in (Every day at 8:30 pm), Next-morning
  catch-up (7:30 am, only if yesterday is empty), Weekly review (Fridays at 5:00 pm), Before
  submission (Lists role rows still at zero). Tap the text to change time/day.
- Also: Postgraduate supervision (students), Other-work categories, Submission date,
  Remove demo data, About.
- BACKUP (phase 2): status line "Backed up to your account · Today 9:41 pm" with a green dot.

### 8.9 First run (onboarding)

Three short screens: welcome ("Log your workload in seconds") → Load workbook (import, §7.2) →
pick your name → set evening reminder time (+ notification permission) → Today. Offer "Try with
demo data" which seeds §3.3 rows and a few sample entries flagged as demo.

### 8.10 Notification and home-screen widget

Notification (see §9): app icon (navy square, gold check), "Anything to log today?", body mentions
today's timetable slot, actions "Log work" · "Lecture done" · "Nothing".
Home-screen widget (phase 2, `home_widget`): "Workload · 1.0 h today" + a 4-column row of the three
recent module codes and a gold "+" (each deep-links into the log flow).

## 9. Reminders

Use `flutter_local_notifications` with `AndroidScheduleMode.inexactAllowWhileIdle` (no exact-alarm
permission needed). Request POST_NOTIFICATIONS on Android 13+. Reschedule all reminders on app
start, on settings change, and after every save.

- **Evening check-in** (default 20:30 daily): body = today's timetable slots if any
  ("EC5208 lecture was on your timetable. Did you also prepare, mark or evaluate anything?"),
  else "Anything to log today?". Actions: Log work (deep link → Step 1, date = today);
  Lecture done (only if a lecture slot today; creates the lecture entry silently, shows a confirmation
  notification); Nothing (writes day_reviews = nothingToLog). Skip today's evening reminder once an
  entry has been saved for today.
- **Next-morning catch-up** (default 07:30): only if yesterday had a timetable slot or was a weekday,
  has no entries, and no day_review. Deep link → Step 1 with date = yesterday.
- **Weekly review** (Friday 17:00): "This week: 4 entries, 7.5 h credited. 2 drafts waiting." → History.
- **Before submission**: if a submission date is set, 3 days before: "3 role rows are still at zero" → Summary.

## 10. Quick text entry (phase 2)

A local, rule-based parser (no AI, no network) in `domain/quick_entry_parser.dart`.
- Module: first token matching `[A-Z]{2}\d{4}` (case-insensitive); if absent, use the recent module.
- Activity: "lecture" → lecture; "prep|prepared|set" + type → caPrep; "exam" → examPrep (or
  examMarking with "mark"); "mark|marked|corrected" → caMarking; "second mark" → secondMarking;
  "lab" → labFirstTime; "moderat" → moderationDone.
- Type: quiz | mcq | structured | essay | project.
- Numbers: "10 questions|qs", "40 papers|scripts", "2 h|hours", "x 3 questions each" → qpp.
- Result: a confirmation card ("EC5208 · Prepared CA · Quiz · 10 questions · +1.0 h — Save?").
  Anything unresolved → saved as a draft with rawText kept.
Tests: at least 15 example phrases with expected parses.

## 11. Design system

### 11.1 Colours (tokens.dart)

| token | hex | use |
| --- | --- | --- |
| navy | #13234A | primary, text, hero cards, primary buttons |
| navyDeep | #0B1733 | lock-screen/notification background, text on gold |
| gold | #C8A24A | Log button, accents, Save pill, selected tile borders |
| goldText | #7A5C14 | credit numbers on white (passes contrast) |
| goldTextDeep | #5C4510 | text on goldSoft |
| goldSoft | #FBF1D6 | credit strip, draft cards, icon chips |
| goldBorder | #E6D3A0 | borders on gold-soft cards |
| goldTint | #FBF6E8 | nudge cards |
| cream | #E9D9A8 | overlines and units on navy |
| ground | #F5F6FA | screen background |
| surface | #FFFFFF | cards |
| chip | #E8ECF5 | module badges, segmented track |
| track | #EEF1F7 | bar backgrounds |
| border | #E3E6EE | card / bar borders |
| borderStrong | #CBD1DE | outlined buttons |
| divider | #EEF0F5 | list dividers |
| textBody | #3E475C | secondary body text |
| textMuted | #5B6478 | captions, labels |
| navInactive | #6B7386 | inactive tab |
| onNavyMuted | #C9D0E0 | secondary text on navy |
| success | #2E7D5B | backup OK dot |

### 11.2 Typography (Plus Jakarta Sans)

display 48/800 (−1 letter-spacing) · countBig 56/800 · screenTitle 26/800 · stepTitle 22/800 ·
greeting 24/800 · cardTitle 17/700 · section 16/700 · body 14–15/600 · caption 12–13/500 ·
overline 12/700, letter-spacing 1, uppercase · badge 12–13/800 · tab label 11 (600 inactive / 800 active).

### 11.3 Shape and spacing

Radii: hero 22, cards 16–20, tiles 18, buttons 12–16, chips/badges 8–10, Log button 20, pill chips 22.
Spacing scale 4/8/12/16/18/20/24. Screen side padding 20. Minimum touch target 44.
Elevation: none except the Log button (soft navy shadow). No gradients.

### 11.4 Shared components (core/widgets)

AppScaffold (ground + bottom bar) · HeroCard · AppCard · SectionLabel (overline) · ModuleBadge
(navy / pale / dashed variants) · EntryTile · CreditText ("+1.0 h") · StepHeader (back/close, title,
date chip, 3-step progress) · ActivityTile · SegmentedChoice · CountStepper · CreditStrip ·
DateChips · PrimaryButton / OutlineButton / TextButton · StatusPill ("Nothing yet") ·
CategoryBar · ToggleRow · EmptyState.

### 11.5 Icons

Simple 1.8–2 px stroke icons (Material Symbols Rounded or Lucide-style): home, clock, plus,
bar-chart, sliders, bell, calendar, chevron, back, close, check, mic, camera, presentation (lecture),
pencil (prepare), document (exam), check-square (marking), flask (lab), spreadsheet, download.
No emoji anywhere.

## 12. Validation and edge cases

- Counts: integers ≥ 1 (lecture hours: multiples of 0.5, ≤ 12 per entry).
- Marking non-project: Qs/paper required (1–100).
- Warn (don't block) when total papers/students for a role row would exceed the module's
  students (only when students > 0).
- Warn on a likely duplicate: same role row, activity, subtype, date and count within 10 minutes.
- Dates: not in the future; outside the current period → warning; locked period → blocked.
- A draft may miss count, subtype or module; it is excluded from totals and shown in Drafts.
- Rates changing after re-import recompute every total (entries store counts only).
- Deleting a role row's last entry never deletes the role row.
- Time zone: Asia/Colombo by default via flutter_timezone; dates follow the device's local date.

## 13. Test fixtures (must pass)

Using the default rates (§3.1) and the owner's opening balances (§3.3):

| role row | expected hours |
| --- | --- |
| EE3202 Teacher: AC=74, AD=1 | examMarking 7.4 |
| EC3202 Teacher: AC=193, AD=1 | examMarking 19.3 |
| EC5406 Teacher (Project): X=200, AE=50 | caMarking 40.0, examMarking 10.0, total 50.0 |
| EC5207 Moderator | moderator 2.0 |
| EC5207 / EC5204 Second Examiner, AF=0 | 0 |
| **Owner total** | CA Marking 40.0 · Exam Marking 36.7 · Moderator 2.0 · **78.7 h** (matches Workload_Summary) |

Plus single-entry cases:
- EC5208 caPrep/quiz 10 → 1.0 h (owner total becomes 79.7 h)
- caPrep/structured 3 → 4.5 h · caPrep/essay 2 → 4.0 h · caPrep/project 1 → 5.0 h
- examMarking/mcq 100 papers × 40 qpp → 8.0 h
- caMarking/structured 40 papers × 3 qpp → 12.0 h · caMarking/quiz any → 0 h
- secondMarking 40 papers → 4.0 h · labFirstTime 1 → 20 h · projectSupervision 2 → 60 h
- Coordinator of a Project module → 25 h; of a Taught module → 10 h
- Roll-up of examMarking/essay batches 40 papers × 1 qpp + 38 papers × 2 qpp → AC = 78,
  AD = 116/78 (≈ 1.487, full precision), examMarking = 11.6 h.
- Import of `docs/reference/DEIE_Workload_Model_V10_1.xlsx` for "Mr. Kalhara Batangala" → 8 role
  rows, rates equal to defaults, opening balances reproducing 78.7 h.

## 14. Open questions (ask the owner before deciding)

1. Are lab sessions conducted counted as "Lecture Hrs Conducted", or only as Other work?
2. Who compiles the department file, and is an exported file acceptable to them?
3. Should "time spent" ever be exported (as evidence for rate reviews) or stay private?
4. Academic year and semester boundaries for the period selector (exact dates).
5. iPhone support needed, or Android only?

## 15. Out of scope for v1

Cloud sync and backup, multi-user/department mode, AI parsing, iOS build, dark mode, calendar
integration, home-screen widget, voice input, editing the workbook in place (we export a separate
file). These are listed in docs/PLAN.md phase 2/3.
