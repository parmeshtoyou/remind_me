import 'package:intl/intl.dart';

String getFormattedDate(DateTime dateTime) {
  DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm');
  DateTime inputDate = inputFormat.parse(dateTime.toString());
  DateFormat outputFormat = DateFormat('dd/MM/yyyy');
  return outputFormat.format(inputDate);
}
