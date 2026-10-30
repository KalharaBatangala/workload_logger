/// A minimal read-only .xlsx reader that returns the values Excel computed
/// (the cached `<v>` of formula cells), which the `excel` package discards.
/// Pure Dart; safe to run in a background isolate.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import '../../domain/workbook_mapping.dart';

/// Thrown when the file is not a readable .xlsx workbook.
class XlsxFormatException implements Exception {
  XlsxFormatException(this.message);

  final String message;

  @override
  String toString() => 'XlsxFormatException: $message';
}

/// One cell: its value as Excel last computed it, and its formula if any.
class XlsxCell {
  const XlsxCell(this.value, [this.formula]);

  /// A [num], [String] or [bool]; null for empty and error cells (#REF!…).
  final Object? value;

  /// Formula text without the leading "=", or "" for a shared-formula cell
  /// that only refers to another cell's formula. Null for plain values.
  final String? formula;

  /// The value as text, trimmed; "" for non-text or empty cells.
  String get text => value is String ? (value as String).trim() : '';

  bool get isEmpty =>
      value == null || (value is String && (value as String).trim().isEmpty);

  @override
  String toString() =>
      'XlsxCell($value${formula == null ? '' : ', =$formula'})';
}

/// The non-empty cells of one worksheet, addressed by 1-based row and 0-based
/// column (column A = 0, matching [columnIndex]).
class SheetData {
  SheetData(this.name, this._rows);

  final String name;
  final Map<int, Map<int, XlsxCell>> _rows;

  static const _empty = XlsxCell(null);

  XlsxCell cell(int row, int column) => _rows[row]?[column] ?? _empty;

  /// Cell by reference, e.g. `at('AC', 129)`.
  XlsxCell at(String columnLetters, int row) =>
      cell(row, columnIndex(columnLetters));

  /// Whether the row has no non-empty cell at all.
  bool isRowEmpty(int row) =>
      _rows[row]?.values.every((c) => c.isEmpty) ?? true;

  /// The highest row number holding any cell.
  int get lastRow => _rows.keys.fold(0, (max, row) => row > max ? row : max);

  /// Every non-empty cell, in no particular order.
  Iterable<XlsxCell> get cells => _rows.values.expand((row) => row.values);
}

class XlsxReader {
  XlsxReader._(this._archive, this._sheetPaths, this._sharedStrings);

  /// Opens a workbook from the bytes of an .xlsx file.
  factory XlsxReader.fromBytes(Uint8List bytes) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw XlsxFormatException('This is not an .xlsx file.');
    }
    XmlDocument part(String path) {
      final file = archive.findFile(path);
      if (file == null) {
        throw XlsxFormatException('The workbook is missing $path.');
      }
      return XmlDocument.parse(utf8.decode(file.content as List<int>));
    }

    // workbook.xml lists sheets by relationship id; the rels file maps ids to
    // worksheet paths.
    final workbook = part('xl/workbook.xml');
    final rels = part('xl/_rels/workbook.xml.rels');
    final targets = {
      for (final rel in rels.findAllElements('Relationship'))
        rel.getAttribute('Id')!: rel.getAttribute('Target')!,
    };
    final sheetPaths = <String, String>{};
    for (final sheet in workbook.findAllElements('sheet')) {
      final id = sheet.attributes.firstWhere((a) => a.name.local == 'id').value;
      final target = targets[id];
      if (target == null) continue;
      sheetPaths[sheet.getAttribute('name')!] = target.startsWith('/')
          ? target.substring(1)
          : 'xl/$target';
    }

    final shared = archive.findFile('xl/sharedStrings.xml') == null
        ? const <String>[]
        : [
            for (final si in part('xl/sharedStrings.xml').findAllElements('si'))
              _sharedStringText(si),
          ];
    return XlsxReader._(archive, sheetPaths, shared);
  }

  final Archive _archive;
  final Map<String, String> _sheetPaths;
  final List<String> _sharedStrings;

  List<String> get sheetNames => _sheetPaths.keys.toList();

  bool hasSheet(String name) => _sheetPaths.containsKey(name);

  /// Parses one worksheet. Throws [XlsxFormatException] if it does not exist.
  SheetData readSheet(String name) {
    final path = _sheetPaths[name];
    final file = path == null ? null : _archive.findFile(path);
    if (file == null) {
      throw XlsxFormatException('The workbook has no "$name" sheet.');
    }
    final document = XmlDocument.parse(utf8.decode(file.content as List<int>));
    final rows = <int, Map<int, XlsxCell>>{};
    for (final c in document.findAllElements('c')) {
      final ref = c.getAttribute('r');
      if (ref == null) continue;
      final match = _cellRef.firstMatch(ref);
      if (match == null) continue;
      final column = columnIndex(match.group(1)!);
      final row = int.parse(match.group(2)!);
      final cell = _readCell(c);
      if (cell.value == null && cell.formula == null) continue;
      (rows[row] ??= {})[column] = cell;
    }
    return SheetData(name, rows);
  }

  static final _cellRef = RegExp(r'^([A-Z]+)(\d+)$');

  XlsxCell _readCell(XmlElement c) {
    final type = c.getAttribute('t');
    final f = c.getElement('f');
    final formula = f?.innerText;
    final v = c.getElement('v')?.innerText;

    final Object? value = switch (type) {
      's' => v == null ? null : _sharedStrings[int.parse(v)],
      'str' => v,
      'inlineStr' => c.findAllElements('t').map((t) => t.innerText).join(),
      'b' => v == null ? null : v == '1',
      'e' => null, // #REF!, #DIV/0! …
      _ => v == null ? null : num.tryParse(v),
    };
    return XlsxCell(value, formula);
  }

  /// Text of a shared string: plain `<t>` or rich-text runs `<r><t>`, but not
  /// phonetic hints (`<rPh>`).
  static String _sharedStringText(XmlElement si) => si.childElements
      .expand(
        (child) => switch (child.name.local) {
          't' => [child.innerText],
          'r' => child.findElements('t').map((t) => t.innerText),
          _ => const <String>[],
        },
      )
      .join();
}
