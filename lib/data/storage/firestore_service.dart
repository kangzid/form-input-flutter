import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/mahasiswa_model.dart';

class FirestoreService {
  final CollectionReference _mahasiswaCollection =
      FirebaseFirestore.instance.collection('mahasiswa');

  // Tambah mahasiswa baru (Gunakan NPM sebagai Document ID agar unik)
  Future<void> addMahasiswa(Mahasiswa data) async {
    await _mahasiswaCollection.doc(data.npm).set(data.toMap());
  }

  // Ambil data mahasiswa (Stream agar realtime)
  Stream<List<Mahasiswa>> getMahasiswaStream() {
    return _mahasiswaCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Mahasiswa.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Ambil data mahasiswa (Future - sekali ambil)
  Future<List<Mahasiswa>> getMahasiswaFuture() async {
    final snapshot = await _mahasiswaCollection.get();
    return snapshot.docs.map((doc) {
      return Mahasiswa.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Hapus berdasarkan NPM (karena NPM jadi Doc ID)
  Future<void> deleteMahasiswaByNpm(String npm) async {
    await _mahasiswaCollection.doc(npm).delete();
  }

  // Update data mahasiswa
  Future<void> updateMahasiswa(String oldNpm, Mahasiswa updatedData) async {
    // Jika NPM berubah, kita perlu hapus yang lama dan buat baru
    // Jika NPM tidak berubah, cukup update
    if (oldNpm != updatedData.npm) {
      await deleteMahasiswaByNpm(oldNpm);
      await addMahasiswa(updatedData);
    } else {
      await _mahasiswaCollection.doc(oldNpm).update(updatedData.toMap());
    }
  }
}
