import 'package:emas_app/data/model/request/asetRequest.dart';
import 'package:emas_app/data/repository/asetRepository.dart';
import 'package:emas_app/presentation/aset/bloc/aset_bloc.dart';
import 'package:emas_app/presentation/aset/bloc/aset_event.dart';
import 'package:emas_app/presentation/aset/bloc/aset_state.dart';
import 'package:emas_app/presentation/aset/kamera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HalamanFormAset extends StatefulWidget {
  final Map<String, dynamic>? existingData;

  const HalamanFormAset({Key? key, this.existingData}) : super(key: key);

  @override
  _HalamanFormAsetState createState() => _HalamanFormAsetState();
}

class _HalamanFormAsetState extends State<HalamanFormAset> {
  final _formKey = GlobalKey<FormState>();
  String? nama;
  double? berat;
  double? harga;
  int? kategoriId;
  int? lokasiId;
  File? foto;
  String? fotoUrl; // URL gambar dari server, bukan File lokal

  @override
void initState() {
  super.initState();
  context.read<AsetBloc>().add(FetchKategoriAset());

  if (widget.existingData != null) {
    nama = widget.existingData!['nama'];
    berat = double.tryParse(widget.existingData!['berat'].toString());
    harga = double.tryParse(widget.existingData!['harga'].toString());
    kategoriId = widget.existingData!['kategori_aset_id'];
    lokasiId = widget.existingData!['lokasi_id'];

    // Ini path dari server, jadi tidak bisa langsung pakai File
    if (widget.existingData!['foto'] != null &&
        widget.existingData!['foto'].toString().isNotEmpty) {
      fotoUrl = "http://192.168.0.185:3000${widget.existingData!['foto']}";
    }
  }
}


  void _ambilDariKamera() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KameraPage(
          onPictureTaken: (File takenPhoto) {
            setState(() {
              foto = takenPhoto;
            });
          },
        ),
      ),
    );
  }

  void _ambilDariGaleri() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        foto = File(picked.path);
      });
    }
  }

  void _simpan() async {
  if (_formKey.currentState!.validate()) {
    if (foto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto wajib diisi')),
      );
      return;
    }

    _formKey.currentState!.save();

    final asetRequest = AsetRequest(
      nama: nama!,
      kategoriAsetId: kategoriId!,
      lokasiId: lokasiId!,
      berat: berat!,
      harga: harga!,
      foto: '' // backend akan isi ini
    );

    final repo = AsetRepository();
    final success = await repo.createWithImage(asetRequest, foto!);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aset berhasil disimpan')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan aset')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Aset')),
      body: BlocConsumer<AsetBloc, AsetState>(
        listener: (context, state) {
          if (state is AsetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Aset berhasil disimpan')),
            );
            Navigator.pop(context);
          } else if (state is AsetFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AsetLoading || state is AsetSubmitting) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is AsetLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: nama,
                      decoration: InputDecoration(labelText: 'Nama Aset'),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      onSaved: (v) => nama = v,
                    ),
                    TextFormField(
                      initialValue: berat?.toString(),
                      decoration: InputDecoration(labelText: 'Berat (kg)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      onSaved: (v) => berat = double.tryParse(v!),
                    ),
                    TextFormField(
                      initialValue: harga?.toString(),
                      decoration: InputDecoration(labelText: 'Harga (Rp)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      onSaved: (v) => harga = double.tryParse(v!),
                    ),
                    DropdownButtonFormField(
                      value: kategoriId,
                      decoration: InputDecoration(labelText: 'Kategori Aset'),
                      items: state.kategori
                          .map<DropdownMenuItem<int>>(
                            (item) => DropdownMenuItem<int>(
                              value: item['kategori_aset_id'],
                              child: Text(item['name'] ?? 'Tanpa Nama'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => kategoriId = val),
                      validator: (v) => v == null ? 'Pilih kategori' : null,
                    ),
                    DropdownButtonFormField(
                      value: lokasiId,
                      decoration: InputDecoration(labelText: 'Lokasi Aset'),
                      items: state.lokasi
                          .map<DropdownMenuItem<int>>(
                            (lokasi) => DropdownMenuItem<int>(
                              value: lokasi.lokasiId,
                              child: Text(lokasi.nama ?? 'Tanpa Nama'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => lokasiId = val),
                      validator: (v) => v == null ? 'Pilih lokasi' : null,
                    ),
                    const SizedBox(height: 12),
                    if (foto != null)
                      Image.file(foto!, height: 150)
                    else if (fotoUrl != null)
                      Image.network(fotoUrl!, height: 150, errorBuilder: (_, __, ___) {
                        return Text("Gagal memuat gambar dari server");
                      })
                    else
                      Text('Belum ada foto'),

                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: _ambilDariKamera,
                          icon: Icon(Icons.camera_alt),
                          label: Text("Kamera"),
                        ),
                        TextButton.icon(
                          onPressed: _ambilDariGaleri,
                          icon: Icon(Icons.photo_library),
                          label: Text("Galeri"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _simpan,
                      child: Text('Simpan'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: Text('Gagal memuat data kategori/lokasi.'));
        },
      ),
    );
  }
}