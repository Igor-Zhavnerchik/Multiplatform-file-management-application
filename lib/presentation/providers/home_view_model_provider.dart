import 'package:cross_platform_project/presentation/screens/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModelProvider =
    NotifierProvider.autoDispose<HomeViewModel, HomeViewState>(
      () => HomeViewModel(),
    );
