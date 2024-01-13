import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences sharedPreferences;
  var box = GetStorage();
  static init() async {
      await GetStorage.init();
  }

  saveData({required String key, required dynamic value}) {
    box.write(key, value);
  }

  dynamic getData({required String key}) {
    return box.read(key);
  }

  removeData({required String key}) async {
    box.remove(key);
  }
}
