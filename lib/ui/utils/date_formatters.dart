import 'package:intl/intl.dart';

class DateFormatters {
  static final DateFormat dateFull = DateFormat.yMMMMd('fr_FR');
  static final DateFormat time = DateFormat.Hm('fr_FR');
  
  /// Format de date et heure combinés (ex: "15 janvier 2024 • 14:30")
  static String formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${dateFull.format(local)} • ${time.format(local)}';
  }
}

