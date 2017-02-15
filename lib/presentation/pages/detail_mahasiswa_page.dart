import 'package:flutter/material.dart';

class DetailMahasiswaPage extends StatelessWidget {
  final Map<String, String> data;

  const DetailMahasiswaPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            color: Colors.indigo[900],
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_pin,
                      size: 80, color: Colors.indigoAccent[100]),
                  const SizedBox(height: 20),
                  Text(
                    data['nama'] ?? '-',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text("NPM: ${data['npm']}",
                      style: const TextStyle(fontSize: 18)),
                  Text("Prodi: ${data['prodi']}",
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
