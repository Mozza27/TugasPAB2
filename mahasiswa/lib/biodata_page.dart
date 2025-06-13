import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});
  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final TextEditingController npmController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController visiController = TextEditingController();

  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('mahasiswa');

  void simpanData() {
    final npm = npmController.text.trim();
    final nama = namaController.text.trim();
    final visi = visiController.text.trim();

    if (npm.isNotEmpty && nama.isNotEmpty && visi.isNotEmpty) {
      dbRef.push().set({
        'npm': npm,
        'nama': nama,
        'visi': visi,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan")),
        );
        npmController.clear();
        namaController.clear();
        visiController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi semua isian")),
      );
    }
  }

  @override
  void dispose() {
    npmController.dispose();
    namaController.dispose();
    visiController.dispose();
    super.dispose();
  }

  Widget buildInputCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2FF), // ungu pucat
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Biodata Mahasiswa",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildInputCard(icon: Icons.credit_card, label: "NPM", controller: npmController),
            buildInputCard(icon: Icons.person, label: "Nama", controller: namaController),
            buildInputCard(icon: Icons.flag, label: "Visi 5 Tahun", controller: visiController, maxLines: 3),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: simpanData,
              icon: const Icon(Icons.save),
              label: const Text("Simpan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
