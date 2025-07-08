import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/keluarga/bloc/keluarga_bloc.dart';
import 'package:emas_app/data/model/request/keluargaRequest.dart';
import 'package:emas_app/data/model/response/keluargaResponse.dart';
import 'package:emas_app/presentation/keluarga/bloc/kategori_keluarga_bloc.dart';

class KeluargaFormPage extends StatefulWidget {
  final Keluarga? keluarga;

  const KeluargaFormPage({Key? key, this.keluarga}) : super(key: key);

  @override
  _KeluargaFormPageState createState() => _KeluargaFormPageState();
}

class _KeluargaFormPageState extends State<KeluargaFormPage> {
  final _namaController = TextEditingController();
  final _istriController = TextEditingController();
  final _jumlahAnakController = TextEditingController();
  int? _kategoriKeluargaId; // ID untuk kategori keluarga
  String? _status; // Menyimpan status (Menikah/Belum Menikah)
  List<Map<String, dynamic>> _kategoriKeluargaList = []; // Menyimpan kategori keluarga yang didapatkan

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

    // Memanggil FetchKategoriKeluargaEvent untuk mendapatkan kategori keluarga dari API
    context.read<KategoriKeluargaBloc>().add(FetchKategoriKeluargaEvent());
  }

  void _save() {
    // Validasi nama keluarga dan status
    if (_namaController.text.isEmpty || _status == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nama dan status tidak boleh kosong")));
      return;
    }

    // Membuat request untuk menyimpan data keluarga
    final keluargaRequest = KeluargaRequest(
      nama: _namaController.text,
      kategoriKeluargaId: _kategoriKeluargaId,
      status: _status,
      istri: _istriController.text,
      jumlahAnak: int.tryParse(_jumlahAnakController.text) ?? 0, // Menghindari null
    );

    final keluargaBloc = context.read<KeluargaBloc>();

    // Menentukan event apakah create atau update
    if (widget.keluarga == null) {
      keluargaBloc.add(CreateKeluargaEvent(keluargaRequest));
    } else {
      keluargaBloc.add(UpdateKeluargaEvent(widget.keluarga!.keluargaId!, keluargaRequest));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.keluarga == null ? 'Tambah Keluarga' : 'Edit Keluarga')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Keluarga'),
            ),
            SizedBox(height: 10),
            // Dropdown untuk status (Menikah/Belum Menikah)
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(labelText: 'Status'),
              items: [
                DropdownMenuItem(value: 'Menikah', child: Text('Menikah')),
                DropdownMenuItem(value: 'Belum Menikah', child: Text('Belum Menikah')),
              ],
              onChanged: (value) {
                setState(() {
                  _status = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Status harus dipilih';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _istriController,
              decoration: InputDecoration(labelText: 'Istri'),
            ),
            TextField(
              controller: _jumlahAnakController,
              decoration: InputDecoration(labelText: 'Jumlah Anak'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            BlocBuilder<KategoriKeluargaBloc, KategoriKeluargaState>(
              builder: (context, state) {
                if (state is KategoriKeluargaLoadingState) {
                  return CircularProgressIndicator();
                } else if (state is KategoriKeluargaLoadedState) {
                  _kategoriKeluargaList = state.kategoriKeluargaList;
                  return DropdownButtonFormField<int>(
                    value: _kategoriKeluargaId,
                    decoration: InputDecoration(labelText: 'Kategori Keluarga'),
                    items: _kategoriKeluargaList.map((kategori) {
                      return DropdownMenuItem<int>(
                        value: kategori['kategori_keluarga_id'],
                        child: Text(kategori['name'] ?? 'Tidak ada nama'), // Pastikan nama tidak null
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _kategoriKeluargaId = value; // Update id kategori keluarga
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Kategori keluarga harus dipilih';
                      }
                      return null;
                    },
                  );
                } else if (state is KategoriKeluargaErrorState) {
                  return Text('Error: ${state.message}');
                }
                return Container();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text(widget.keluarga == null ? 'Simpan' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
