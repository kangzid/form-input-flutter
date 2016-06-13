class Mahasiswa {
  final String nama;
  final String npm;
  final String prodi;

  Mahasiswa({
    required this.nama,
    required this.npm,
    required this.prodi,
  });

  // Convert object ke Map (untuk disimpan di SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'npm': npm,
      'prodi': prodi,
    };
  }

  // Convert Map ke Object (saat load dari SharedPreferences)
  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      nama: map['nama'] ?? '',
      npm: map['npm'] ?? '',
      prodi: map['prodi'] ?? '',
    );
  }

  // Convert object ke JSON string
  String toJson() => toMap().toString();

  // Untuk debugging, menampilkan data di print()
  @override
  String toString() {
    return 'Mahasiswa(nama: $nama, npm: $npm, prodi: $prodi)';
  }
}
