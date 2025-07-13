import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:emas_app/data/model/request/pengeluaranRequest.dart';
import 'package:emas_app/data/model/response/asetResponse.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_event.dart';
import 'package:emas_app/presentation/aset/bloc/aset_bloc.dart';
import 'package:emas_app/presentation/aset/bloc/aset_state.dart';
import 'package:emas_app/presentation/aset/bloc/aset_event.dart';

class FormPengeluaranPage extends StatefulWidget {
  const FormPengeluaranPage({Key? key}) : super(key: key);

  @override
  State<FormPengeluaranPage> createState() => _FormPengeluaranPageState();
}

class _FormPengeluaranPageState extends State<FormPengeluaranPage> {
  int? selectedAssetId;
  double berat = 0;
  double harga = 0;
  String? tanggal;
  String? namaAset; 
  final keteranganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AsetBloc>().add(FetchAllAset());
  }

  void resetForm() {
    setState(() {
      selectedAssetId = null;
      berat = 0;
      harga = 0;
      tanggal = null;
      keteranganController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Form Pengeluaran', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<AsetBloc, AsetState>(
              builder: (context, state) {
                if (state is AsetListLoaded) {
                  final List<Aset> asets = (state.aset as List)
                      .map((e) => Aset.fromMap(e as Map<String, dynamic>))
                      .toList();
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pilih Aset',
                      prefixIcon: Icon(Icons.widgets),
                    ),
                    items: asets.map((Aset aset) {
                      return DropdownMenuItem<int>(
                        value: aset.assetId,
                        child: Text(aset.nama ?? ''),
                      );
                    }).toList(),
                    value: selectedAssetId,
                    onChanged: (value) {
                      final selected = asets.firstWhere((a) => a.assetId == value);
                      setState(() {
                        selectedAssetId = value;
                        berat = selected.berat ?? 0;
                        harga = selected.harga ?? 0;
                        namaAset = selected.nama;
                      });
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 10),
            Text('Berat: $berat gram'),
            Text('Harga: Rp $harga'),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tanggal',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    tanggal = DateFormat('yyyy-MM-dd').format(picked);
                  });
                }
              },
              controller: TextEditingController(text: tanggal),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: keteranganController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Keterangan',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 20),
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
                onPressed: () {
                  if (selectedAssetId != null && tanggal != null) {
                    final data = PengeluaranRequest(
                      assetId: selectedAssetId!,
                      berat: berat,
                      harga: harga.toInt(),
                      tanggal: tanggal!,
                      keterangan: keteranganController.text,
                      namaAset: namaAset,
                    );
                    context.read<PengeluaranBloc>().add(CreatePengeluaran(data));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
