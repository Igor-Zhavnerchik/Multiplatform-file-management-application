import 'package:supabase_flutter/supabase_flutter.dart';

class CurrentUserService {
  final SupabaseClient client;

  CurrentUserService({required this.client});

  String get currentUserId => client.auth.currentUser!.id;
}
