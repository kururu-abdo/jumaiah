class Validations {
  

  static bool  isValidEmail(String email) {
bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.trim());
    print(emailValid);

return emailValid;


  }
}