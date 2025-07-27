import 'package:intl/intl.dart';

extension DateFormatyyyymmddMonthExtension on DateTime {
  String toDateyyyymmddFormattedString() =>
      DateFormat('yyyy-MM-dd').format(this);
}

extension DateFormatddmmExtension on DateTime {
  String toDateddmmFormattedString() => DateFormat('dd MMM').format(this);
}

extension DateFormatddmmmyyyyExtension on DateTime {
  String toDateddmmmyyyyFormattedString() =>
      DateFormat('dd MMM yyyy').format(this);
}

extension DateFormatyyyymmddMonthDayExtension on DateTime {
  String toFormattedDateDayTimeString() =>
      DateFormat('d MMMM yyyy').format(this);
}

extension DateFormateeddmmmyyyyExtension on DateTime {
  String toDayDateeddmmmyyyyFormattedString() =>
      DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(this);
}

extension FormattedDateExtension on DateTime {
  /// Mengembalikan format: `22 February, 11.17`
  String toDateTimePartString() {
    final datePart = DateFormat('dd MMM yyyy').format(this);
    final timePart = DateFormat('HH.mm').format(this);
    return '$datePart - $timePart';
  }
}
