import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/keluarga/bloc/keluarga_bloc.dart';
import 'package:emas_app/data/model/request/keluargaRequest.dart';
import 'package:emas_app/data/model/response/keluargaResponse.dart';
import 'package:emas_app/presentation/keluarga/bloc/kategori_keluarga_bloc.dart';

class KeluargaFormPage extends StatefulWidget {
  final Keluarga? keluarga;

  const KeluargaFormPage({super.key, this.keluarga});

  @override
  _KeluargaFormPageState createState() => _KeluargaFormPageState();
}

class _KeluargaFormPageState extends State<KeluargaFormPage> {
  final _namaController = TextEditingController();
  final _istriController = TextEditingController();
  final _jumlahAnakController = TextEditingController();
  int? _kategoriKeluargaId;
  String? _status;
  List<Map<String, dynamic>> _kategoriKeluargaList = [];

  @override
  void initState() {
    super.initState();
    if (widget.keluarga != null) {
      _namaController.text = widget.keluarga!.nama ?? '';
      _istriController.text = widget.keluarga!.istri ?? '';
      _jumlahAnakController.text = widget.keluarga!.jumlahAnak?.toString() ?? '';
      _kategoriKeluargaId = widget.keluarga!.kategoriKeluargaId;
      _status = widget.keluarga!.status;
    }

    context.read<KategoriKeluargaBloc>().add(FetchKategoriKeluargaEvent());
  }

  void _save() {
    if (_namaController.text.isEmpty || _status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nama dan status tidak boleh kosong")));
      return;
    }

    final keluargaRequest = KeluargaRequest(
      nama: _namaController.text,
      kategoriKeluargaId: _kategoriKeluargaId,
      status: _status,
      istri: _istriController.text,
      jumlahAnak: int.tryParse(_jumlahAnakController.text) ?? 0,
    );

    final keluargaBloc = context.read<KeluargaBloc>();

    if (widget.keluarga == null) {
      keluargaBloc.add(CreateKeluargaEvent(keluargaRequest));
    } else {
      keluargaBloc.add(UpdateKeluargaEvent(widget.keluarga!.keluargaId!, keluargaRequest));
    }

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFD700), width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          widget.keluarga == null ? 'Tambah Keluarga' : 'Edit Keluarga',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _namaController,
              decoration: _inputDecoration('Nama Keluarga', Icons.group),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: _inputDecoration('Status', Icons.verified_user),
              items: const [
                DropdownMenuItem(value: 'Menikah', child: Text('Menikah')),
                DropdownMenuItem(value: 'Belum Menikah', child: Text('Belum Menikah')),
              ],
              onChanged: (value) => setState(() => _status = value),
              validator: (value) => value == null ? 'Status harus dipilih' : null,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _istriController,
              decoration: _inputDecoration('Istri', Icons.female),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jumlahAnakController,
              decoration: _inputDecoration('Jumlah Anak', Icons.child_friendly),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            BlocBuilder<KategoriKeluargaBloc, KategoriKeluargaState>(
              builder: (context, state) {
                if (state is KategoriKeluargaLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is KategoriKeluargaLoadedState) {
                  _kategoriKeluargaList = state.kategoriKeluargaList;
                  return DropdownButtonFormField<int>(
                    value: _kategoriKeluargaId,
                    decoration: _inputDecoration('Kategori Keluarga', Icons.category),
                    items: _kategoriKeluargaList.map((kategori) {
                      return DropdownMenuItem<int>(
                        value: kategori['kategori_keluarga_id'],
                        child: Text(kategori['name'] ?? 'Tidak ada nama'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _kategoriKeluargaId = value),
                    validator: (value) => value == null ? 'Kategori keluarga harus dipilih' : null,
                  );
                } else if (state is KategoriKeluargaErrorState) {
                  return Text('Error: ${state.message}');
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _save,
                child: Text(widget.keluarga == null ? 'Simpan' : 'Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
