import 'package:date_formatter/date_formatter.dart';

formatDate({required String date, bool? enableHour = false}) {
  return DateFormatter.formatStringDate(
    date: DateTime.now().toString(),
    inputFormat: 'yyyy-MM-dd HH:mm:ss',
    outputFormat: 'dd-MMM-yyyy ${enableHour! ? "HH:mm" : ""}',
  );
}
