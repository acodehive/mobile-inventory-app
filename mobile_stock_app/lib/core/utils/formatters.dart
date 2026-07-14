import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String currency(num value, {String symbol = '₹'}) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: symbol, decimalDigits: 0);
    return formatter.format(value);
  }

  static String compactNumber(num value) {
    return NumberFormat.compact().format(value);
  }

  static String date(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  static String dateTime(DateTime date) => DateFormat('dd MMM yyyy, hh:mm a').format(date);

  static String relativeDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    return AppFormatters.date(date);
  }

  static String profitMargin(double purchase, double selling) {
    if (purchase <= 0) return '—';
    final margin = ((selling - purchase) / purchase) * 100;
    return '${margin.toStringAsFixed(1)}%';
  }
}
