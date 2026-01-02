import 'package:cross_platform_project/presentation/services/history_navigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyNavigatorProvider = Provider.autoDispose<HistoryNavigator>((ref) {
  return HistoryNavigator();
});
