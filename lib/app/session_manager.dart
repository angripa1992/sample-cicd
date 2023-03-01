import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';

import '../modules/user/domain/entities/user.dart';

class SessionManager {
  late AppPreferences _appPreferences;
  static final _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal() {
    _appPreferences = getIt.get();
    _init();
  }

  UserInfo? _user;

  void _init() {
    _user = _appPreferences.getUser().userInfo;
  }

  Future<void> saveUser(User user) async{
    _appPreferences.saveUser(user);
  }

  UserInfo currentUser() => _user!;

  int currentUserBranchId() => _user!.branchId;
}
