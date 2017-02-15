import 'package:flutter/material.dart';
import 'package:form_input/data/storage/local_storage.dart';
import 'package:another_flushbar/flushbar.dart';
import '../widgets/input_field.dart';
import 'data_list_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lottie/lottie.dart';

class FormInputPage extends StatefulWidget {
  const FormInputPage({super.key});

  @override
  State<FormInputPage> createState() => _FormInputPageState();
}

class _FormInputPageState extends State<FormInputPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();

  List<Map<String, String>> mahasiswaList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final list = await LocalStorage.loadDataList();
    setState(() {
      mahasiswaList = list.reversed.toList(); // biar data terbaru di atas
    });
  }

  Future<void> _saveData() async {
    final nama = _namaController.text.trim();
    final npm = _npmController.text.trim();
    final prodi = _prodiController.text.trim();

    if (nama.isEmpty || npm.isEmpty || prodi.isEmpty) {
      _showFlushbar("Semua field harus diisi!", Colors.orangeAccent);
      return;
    }

    // Ambil semua data untuk cek duplikat NPM
    final existingData = await LocalStorage.loadDataList();
    final npmSudahAda = existingData.any((item) => item['npm'] == npm);

    if (npmSudahAda) {
      _showDuplicateAlert();
      return; // stop proses simpan
    }

    final data = {'nama': nama, 'npm': npm, 'prodi': prodi};

    await LocalStorage.saveDataList(data);
    _namaController.clear();
    _npmController.clear();
    _prodiController.clear();

    await _loadSavedData();
    _showFlushbar("Data berhasil disimpan!", Colors.greenAccent);
  }

  void _showFlushbar(String message, Color color) {
    Flushbar(
      message: message,
      backgroundColor: color,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(Icons.info_outline, color: Colors.black87),
      messageColor: Colors.black,
    ).show(context);
  }

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

  @override
  Widget build(BuildContext context) {
    final latestData = mahasiswaList.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Input Mahasiswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InputField(
              controller: _namaController,
              label: 'Nama',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            InputField(
              controller: _npmController,
              label: 'NPM',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            InputField(
              controller: _prodiController,
              label: 'Prodi',
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Simpan Data'),
            ),
            const SizedBox(height: 30),
            if (latestData.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "3 Data Terbaru:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...latestData.map((mhs) => Card(
                        color: Colors.indigo[900],
                        child: ListTile(
                          title: Text(mhs['nama'] ?? ''),
                          subtitle: Text(
                              "NPM: ${mhs['npm']}\nProdi: ${mhs['prodi']}"),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Center(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.list_alt),
                      label: const Text("Lihat Semua Data"),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DataListPage()),
                        );
                        _loadSavedData(); // refresh saat kembali
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
