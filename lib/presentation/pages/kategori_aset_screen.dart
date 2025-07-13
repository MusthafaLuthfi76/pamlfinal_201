import 'package:flutter/material.dart';
import '../../data/model/response/kategoriResponse.dart';
import '../../data/model/request/kategoriRequest.dart';
import '../../data/repository/kategori_aset_repository.dart';

class KategoriAsetScreen extends StatefulWidget {
  const KategoriAsetScreen({super.key});

  @override
  _KategoriAsetScreenState createState() => _KategoriAsetScreenState();
}

class _KategoriAsetScreenState extends State<KategoriAsetScreen> {
  final KategoriAsetRepository _repo = KategoriAsetRepository();
  List<KategoriAset> _kategoriList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  Future<void> _fetchKategori() async {
    setState(() => _isLoading = true);
    final data = await _repo.getAll();
    setState(() {
      _kategoriList = data
          .map<KategoriAset>((e) => KategoriAset.fromMap(e))
          .toList();
      _isLoading = false;
    });
  }

  void _showForm({KategoriAset? kategori}) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(
      text: kategori?.name ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(kategori == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Nama Kategori'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final req = KategoriRequest(name: nameController.text);
                bool success;
                if (kategori == null) {
                  success = await _repo.create(req);
                } else {
                  success = await _repo.update(kategori.id!, req);
                }
                if (success) {
                  Navigator.pop(context);
                  _fetchKategori();
                }
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteKategori(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Kategori'),
        content: Text('Yakin ingin menghapus kategori ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus'),
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
      appBar: AppBar(title: Text('Kategori Aset')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _kategoriList.isEmpty
          ? Center(child: Text('Belum ada kategori'))
          : ListView.builder(
              itemCount: _kategoriList.length,
              itemBuilder: (context, i) {
                final kategori = _kategoriList[i];
                return ListTile(
                  title: Text(kategori.name ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showForm(kategori: kategori),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteKategori(kategori.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        tooltip: 'Tambah Kategori',
        child: Icon(Icons.add),
      ),
    );
  }
}
