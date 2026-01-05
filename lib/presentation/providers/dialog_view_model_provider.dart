import 'package:cross_platform_project/presentation/view_models/dialog_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dialogViewModelProvider = NotifierProvider<DialogViewModel, DialogState>(() {
  
  return DialogViewModel();
},);