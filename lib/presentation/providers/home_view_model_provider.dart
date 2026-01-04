import 'package:cross_platform_project/presentation/view_models/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeViewState>(
  () => HomeViewModel(),
);
