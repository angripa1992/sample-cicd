import 'package:klikit/app/constants.dart';
import 'package:klikit/app/session_manager.dart';

class UserPermissionManager {
  static final _instance = UserPermissionManager._internal();

  factory UserPermissionManager() => _instance;

  UserPermissionManager._internal();

  bool canCancelOrder() {
    final user = SessionManager().user();
    if (user == null) return false;
    return user.permissions.contains(UserPermission.cancelOrder);
  }

  bool isBizOwner() {
    final user = SessionManager().user();
    return user?.roles.first == UserRole.businessOwner;
  }

  bool isBranchManager() {
    final user = SessionManager().user();
    return user?.roles.first == UserRole.branchManger;
  }

  bool canOosMenu() {
    final user = SessionManager().user();
    if (user == null) return false;
    return user.permissions.contains(UserPermission.oosMenu);
  }

}
