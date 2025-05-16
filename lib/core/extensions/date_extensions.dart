import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String formatYMD() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
