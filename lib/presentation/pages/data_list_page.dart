import 'package:flutter/material.dart';
import '../../../data/storage/firestore_service.dart';
import '../../../models/mahasiswa_model.dart';
import 'detail_mahasiswa_page.dart';

class DataListPage extends StatefulWidget {
  const DataListPage({super.key});

  @override
  State<DataListPage> createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  List<Mahasiswa> mahasiswaList = [];
  List<int> selectedIndexes = [];
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final list = await _firestoreService.getMahasiswaFuture();
    setState(() {
      mahasiswaList = list.reversed.toList();
    });
  }

  Future<void> _deleteSelected() async {
    if (selectedIndexes.isEmpty) return;

    final selectedNPMs =
        selectedIndexes.map((index) => mahasiswaList[index].npm).toList();

    for (var npm in selectedNPMs) {
      await _firestoreService.deleteMahasiswaByNpm(npm);
    }

    setState(() {
      selectedIndexes.clear();
    });

    await _loadSavedData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data terpilih berhasil dihapus!'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 20, left: 12, right: 12),
      ),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa'),
        actions: [
          if (selectedIndexes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _deleteSelected,
            ),
        ],
      ),
      body: mahasiswaList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada data tersimpan.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mahasiswaList.length,
              itemBuilder: (context, index) {
                final mhs = mahasiswaList[index];
                final selected = selectedIndexes.contains(index);

                return GestureDetector(
                  onLongPress: () => _toggleSelection(index),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailMahasiswaPage(mahasiswa: mhs),
                      ),
                    );
                    _loadSavedData();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama: ${mhs.nama}',
                                style: const TextStyle(fontSize: 16)),
                            Text('NPM: ${mhs.npm}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Prodi: ${mhs.prodi}',
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: Colors.amberAccent, size: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
