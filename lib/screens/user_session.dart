class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;

  UserSession._internal();

  // Kullanıcı bilgilerini tutacak değişkenler
  String? email;
  String? username;

  void setUser({required String email, required String username}) {
    this.email = email;
    this.username = username;
  }

  void clearUser() {
    email = null;
    username = null;
  }
}

final userSession = UserSession();
