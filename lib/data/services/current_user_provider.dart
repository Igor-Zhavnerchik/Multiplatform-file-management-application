import 'package:cross_platform_project/domain/entities/user_entity.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';

class CurrentUserProvider {
  final AuthRepository auth;
  CurrentUserProvider({required this.auth});

  String? get currentUserId => auth.getCurrentUser()?.id;
  UserEntity? get currentUser => auth.getCurrentUser();
}
