import 'package:flutter/material.dart';
import '../../data/repository/kategoriKeluargaRepo.dart';
import '../../data/model/request/kategorikeluargaRequest.dart';

class KategoriKeluargaScreen extends StatefulWidget {
  const KategoriKeluargaScreen({super.key});

  @override
  _KategoriKeluargaScreenState createState() => _KategoriKeluargaScreenState();
}

class _KategoriKeluargaScreenState extends State<KategoriKeluargaScreen> {
  final KategoriKeluargaRepository _repo = KategoriKeluargaRepository();
  List<dynamic> _kategoriList = [];
  bool _isLoading = true;

  final Color goldColor = const Color(0xFFFFD700);

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  Future<void> _fetchKategori() async {
    setState(() => _isLoading = true);
    final data = await _repo.getAll();
    setState(() {
      _kategoriList = data;
      _isLoading = false;
    });
  }

  void _showForm({Map<String, dynamic>? kategori}) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(
      text: kategori?['name'] ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(kategori == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Kategori',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: goldColor),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final req = KategoriKeluargaRequest(nama: nameController.text);
                bool success;
                if (kategori == null) {
                  success = await _repo.create(req);
                } else {
                  success = await _repo.update(kategori['kategori_keluarga_id'], req);
                }
                if (success) {
                  Navigator.pop(context);
                  _fetchKategori();
                }
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _deleteKategori(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Hapus Kategori'),
        content: const Text('Yakin ingin menghapus kategori ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _repo.delete(id);
      _fetchKategori();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kategori Keluarga', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kategoriList.isEmpty
              ? const Center(child: Text('Belum ada kategori'))
              : ListView.builder(
                  itemCount: _kategoriList.length,
                  itemBuilder: (context, i) {
                    final kategori = _kategoriList[i];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 1.5,
                      child: ListTile(
                        leading: const Icon(Icons.category),
                        title: Text(kategori['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(kategori: kategori),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _deleteKategori(kategori['kategori_keluarga_id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: goldColor,
        foregroundColor: Colors.black,
        onPressed: () => _showForm(),
        tooltip: 'Tambah Kategori',
        child: const Icon(Icons.add),
      ),
    );
  }
}
