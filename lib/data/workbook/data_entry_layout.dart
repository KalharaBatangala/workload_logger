/// The Data_Entry header rows of DEIE Workload Model V10.1 (rows 3 and 4),
/// reproduced exactly — line breaks included — in the export so the rows
/// paste straight into the department's sheet. A test compares these with
/// the reference workbook.
library;

/// Row 3: column letter → header text.
const dataEntryHeaderRow3 = <String, String>{
  'A': 'Module\nCode',
  'B': 'Batch',
  'C': 'Module Name\n',
  'D': 'Module Type\n(Taught/Project)',
  'E': 'Credits',
  'F': 'Total No. of\nStudents',
  'G': 'Staff Name',
  'H': 'Role',
  'I': 'Lecture Hrs\nConducted',
  'J': 'CA Preparation',
  'N': 'End Exam Preparation',
  'R': 'CA Marking / Evaluation',
  'Y': 'End Exam Marking / Evaluation (1st marking)',
  'AF': '2nd Marking - End Exam:\nPapers Marked (#)',
  'AG': 'Labs Prepared\n1st time (#)',
  'AH': 'Under Graduate Project Supervision:\nProjects Supervised (#)',
  'AI': 'Industrial Training Evaluation:\nStudents Evaluated (#)',
  'AJ': 'Coordination\nHours',
  'AK': '2nd Marking\nHours',
  'AL': 'Moderator\nHours',
  'AM': 'Teaching\nHours',
  'AN': 'CA Prep\nHours',
  'AO': 'Exam Prep\nHours',
  'AP': 'CA Marking\nHours',
  'AQ': 'Exam Marking\nHours',
  'AR': 'Lab Prep\nHours',
  'AS': 'Project Supervision\nHours',
  'AT': 'Industrial Training\nHours',
  'AU': 'TOTAL\nHOURS',
};

/// Row 4: column letter → sub-header text.
const dataEntryHeaderRow4 = <String, String>{
  'J': 'Quiz:\nQs Prepared (#)',
  'K': 'Structured:\nQs Prepared (#)',
  'L': 'Essay:\nQs Prepared (#)',
  'M': 'Project:\nAssessments Prepared (#)',
  'N': 'MCQ:\nQs Prepared (#)',
  'O': 'Structured:\nQs Prepared (#)',
  'P': 'Essay:\nQs Prepared (#)',
  'Q': 'Project:\nAssessments Prepared (#)',
  'R': 'Quiz:\nPapers Marked (#)',
  'S': 'Quiz:\nQs Marked/Paper (#)',
  'T': 'Structured:\nPapers Marked (#)',
  'U': 'Structured:\nQs Marked/Paper (#)',
  'V': 'Essay:\nPapers Marked (#)',
  'W': 'Essay:\nQs Marked/Paper (#)',
  'X': 'Project:\nStudents Evaluated (#)',
  'Y': 'MCQ:\nPapers Marked (#)',
  'Z': 'MCQ:\nQs Marked/Paper (#)',
  'AA': 'Structured:\nPapers Marked (#)',
  'AB': 'Structured:\nQs Marked/Paper (#)',
  'AC': 'Essay:\nPapers Marked (#)',
  'AD': 'Essay:\nQs Marked/Paper (#)',
  'AE': 'Project:\nStudents Evaluated (#)',
};

/// First data row, as in the department's sheet.
const dataEntryFirstRow = 5;
