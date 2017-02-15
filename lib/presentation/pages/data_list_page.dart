import 'package:flutter/material.dart';
import 'package:form_input/data/storage/local_storage.dart';
import 'detail_mahasiswa_page.dart';
import 'package:another_flushbar/flushbar.dart';

class DataListPage extends StatefulWidget {
  const DataListPage({super.key});

  @override
  State<DataListPage> createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  List<Map<String, String>> mahasiswaList = [];
  List<String> selectedNpmList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await LocalStorage.loadDataList();
    setState(() {
      mahasiswaList = list.reversed.toList();
    });
  }

  void _toggleSelection(String npm) {
    setState(() {
      if (selectedNpmList.contains(npm)) {
        selectedNpmList.remove(npm);
      } else {
        selectedNpmList.add(npm);
      }
    });
  }

  Future<void> _deleteSelected() async {
    if (selectedNpmList.isEmpty) return;

    await LocalStorage.deleteByNpmList(selectedNpmList);
    selectedNpmList.clear();
    await _loadData();

    _showFlushbar("Data terpilih berhasil dihapus!", Colors.redAccent);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        actions: [
          if (selectedNpmList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _deleteSelected,
            ),
        ],
      ),
      body: mahasiswaList.isEmpty
          ? const Center(child: Text('Belum ada data'))
          : ListView.builder(
              itemCount: mahasiswaList.length,
              itemBuilder: (context, index) {
                final mhs = mahasiswaList[index];
                final selected = selectedNpmList.contains(mhs['npm']);

                return GestureDetector(
                  onLongPress: () => _toggleSelection(mhs['npm']!),
                  onTap: () {
                    if (selectedNpmList.isNotEmpty) {
                      _toggleSelection(mhs['npm']!);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailMahasiswaPage(data: mhs),
                        ),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.indigoAccent.withOpacity(0.4)
                          : Colors.indigo[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            selected ? Colors.indigoAccent : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      title: Text(mhs['nama'] ?? '',
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        "NPM: ${mhs['npm']}\nProdi: ${mhs['prodi']}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
