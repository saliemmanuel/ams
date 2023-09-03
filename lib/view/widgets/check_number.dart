class CheckPhoneNumber {
  static bool check(String chaine) {
    RegExp regex = RegExp(r'^6[75982]');
    if (regex.hasMatch(chaine) && chaine.length == 9) {
      return true;
    }
    return false;
  }
}
