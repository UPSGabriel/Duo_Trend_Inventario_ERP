import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:duo_trend_app/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tema usa identidad Duo Trend y Material 3', () {
    final theme = AppTheme.light();

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, AppColors.deepBlue);
    expect(theme.colorScheme.secondary, AppColors.warmYellow);
    expect(theme.scaffoldBackgroundColor, AppColors.background);
  });
}
