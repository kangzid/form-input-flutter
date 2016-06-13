import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lottie/lottie.dart';
import '../../../data/storage/firestore_service.dart';
import '../../../models/mahasiswa_model.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator, // ✅ Aktifkan validator
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.indigoAccent),
        filled: true,
        fillColor: Colors.indigo[900]!.withOpacity(0.1),
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigoAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigoAccent.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigoAccent, width: 2),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class DetailMahasiswaPage extends StatefulWidget {
  final Mahasiswa mahasiswa;

  const DetailMahasiswaPage({super.key, required this.mahasiswa});

  @override
  State<DetailMahasiswaPage> createState() => _DetailMahasiswaPageState();
}

class _DetailMahasiswaPageState extends State<DetailMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _npmController;
  late TextEditingController _prodiController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.mahasiswa.nama);
    _npmController = TextEditingController(text: widget.mahasiswa.npm);
    _prodiController = TextEditingController(text: widget.mahasiswa.prodi);
  }

  /// ✅ show SnackBar (untuk berhasil update)
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.black87),
            SizedBox(width: 8),
            Text(message, style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: color,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// ⚠️ show AwesomeDialog (untuk duplikat NPM)
  void _showDuplicateAlert() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'NPM Sudah Terdaftar!',
      desc:
          'Mahasiswa dengan NPM ini sudah ada di data.\nSilakan periksa kembali input Anda.',
      customHeader: Lottie.asset(
        'assets/animations/warning.json',
        height: 100,
        repeat: false,
      ),
      btnOkOnPress: () {},
      btnOkColor: Colors.orangeAccent,
    ).show();
  }

  /// 🧠 Proses update data mahasiswa
  Future<void> _updateMahasiswa() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = Mahasiswa(
      nama: _namaController.text.trim(),
      npm: _npmController.text.trim(),
      prodi: _prodiController.text.trim(),
    );

    final existingList = await _firestoreService.getMahasiswaFuture();
    final isDuplicate = existingList.any(
      (m) => m.npm == updated.npm && m.npm != widget.mahasiswa.npm,
    );

    if (isDuplicate) {
      _showDuplicateAlert();
      return;
    }

    await _firestoreService.updateMahasiswa(widget.mahasiswa.npm, updated);
    _showSnackBar("Data berhasil diperbarui!", Colors.green);

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: const Text('Edit Data Mahasiswa'),
        backgroundColor: Colors.indigo[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Card(
            color: Colors.indigo[800],
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  InputField(
                    controller: _namaController,
                    label: 'Nama Mahasiswa',
                    icon: Icons.person,
                    validator: (value) =>
                        value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    controller: _npmController,
                    label: 'NPM',
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'NPM tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    controller: _prodiController,
                    label: 'Program Studi',
                    icon: Icons.school,
                    validator: (value) =>
                        value!.isEmpty ? 'Prodi tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: _updateMahasiswa,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
