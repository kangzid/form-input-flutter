import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/mahasiswa_model.dart';

class LocalStorage {
  static const String keyMahasiswa = 'dataMahasiswa';

  // Simpan data mahasiswa (list)
  static Future<void> saveMahasiswa(List<Mahasiswa> data) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = data.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(keyMahasiswa, encoded);
  }

  // Ambil data mahasiswa (list)
  static Future<List<Mahasiswa>> getMahasiswa() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedList = prefs.getStringList(keyMahasiswa);
    if (encodedList == null) return [];
    return encodedList.map((e) => Mahasiswa.fromMap(jsonDecode(e))).toList();
  }

  // Tambah satu mahasiswa baru
  static Future<void> addMahasiswa(Mahasiswa newData) async {
    final currentData = await getMahasiswa();
    currentData.add(newData);
    await saveMahasiswa(currentData);
  }

  // Hapus berdasarkan NPM
  static Future<void> deleteMahasiswaByNpm(String npm) async {
    final currentData = await getMahasiswa();
    final updatedData = currentData.where((m) => m.npm != npm).toList();
    await saveMahasiswa(updatedData);
  }

  // 🔥 Update data mahasiswa berdasarkan NPM lama
  static Future<void> updateMahasiswa(
      String oldNpm, Mahasiswa updatedData) async {
    final currentData = await getMahasiswa();
    final index = currentData.indexWhere((m) => m.npm == oldNpm);

    if (index != -1) {
      currentData[index] = updatedData; // Ganti data lama dengan data baru
      await saveMahasiswa(currentData);
    }
  }

  // Hapus semua data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyMahasiswa);
  }
}
