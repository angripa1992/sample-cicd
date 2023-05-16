bool isEmailValid(String email) {
  return RegExp(
          r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(email);
}
