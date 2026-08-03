import 'package:intl/intl.dart';

abstract final class RegionalConfig {
  static const locale = 'es_EC';
  static const currencyCode = 'USD';
  static const currencySymbol = r'$';
  static const timezone = 'America/Guayaquil';
  static const visibleDatePattern = 'dd/MM/yyyy';
  static const visibleTimePattern = 'HH:mm';

  static String formatMoney(num value) {
    return NumberFormat.currency(
      locale: locale,
      name: currencyCode,
      symbol: currencySymbol,
      decimalDigits: 2,
    ).format(value);
  }

  static String formatDate(DateTime value) {
    return DateFormat(visibleDatePattern, locale).format(value.toLocal());
  }

  static String formatTime(DateTime value) {
    return DateFormat(visibleTimePattern, locale).format(value.toLocal());
  }
}
