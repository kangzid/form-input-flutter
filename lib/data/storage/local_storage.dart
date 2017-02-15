import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _key = 'mahasiswa_data';

  /// Simpan data baru ke daftar mahasiswa
  static Future<void> saveDataList(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil data lama
    final existingJson = prefs.getString(_key);
    List<Map<String, String>> existingList = [];

    if (existingJson != null) {
      final decoded = jsonDecode(existingJson) as List;
      existingList = decoded.map((e) => Map<String, String>.from(e)).toList();
    }

    // Tambahkan data baru
    existingList.add(data);

    // Simpan ulang
    await prefs.setString(_key, jsonEncode(existingList));
  }

  /// Ambil semua data mahasiswa
  static Future<List<Map<String, String>>> loadDataList() async {
    final prefs = await SharedPreferences.getInstance();
    final existingJson = prefs.getString(_key);

    if (existingJson == null) return [];

    final decoded = jsonDecode(existingJson) as List;
    return decoded.map((e) => Map<String, String>.from(e)).toList();
  }

  /// Hapus data berdasarkan NPM unik
  static Future<void> deleteByNpmList(List<String> npms) async {
    final prefs = await SharedPreferences.getInstance();
    final existingJson = prefs.getString(_key);
    if (existingJson == null) return;

    final decoded = jsonDecode(existingJson) as List;
    final list = decoded.map((e) => Map<String, String>.from(e)).toList();

    // Hapus berdasarkan NPM
    list.removeWhere((item) => npms.contains(item['npm']));

    await prefs.setString(_key, jsonEncode(list));
  }

  /// Hapus semua data (opsional)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
