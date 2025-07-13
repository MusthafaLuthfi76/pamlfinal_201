// lib/presentation/warisan/warisan_form.dart
import 'package:emas_app/presentation/aset/bloc/aset_bloc.dart';
import 'package:emas_app/presentation/aset/bloc/aset_event.dart';
import 'package:emas_app/presentation/aset/bloc/aset_state.dart';
import 'package:emas_app/presentation/keluarga/bloc/keluarga_bloc.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_bloc.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_event.dart';
import 'package:flutter/material.dart';
import 'package:emas_app/data/model/request/warisanRequest.dart';
import 'package:emas_app/data/repository/warisanRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarisanFormPage extends StatefulWidget {
  final Map<String, dynamic>? editData;

  const WarisanFormPage({this.editData, super.key});

  @override
  State<WarisanFormPage> createState() => _WarisanFormPageState();
}

class _WarisanFormPageState extends State<WarisanFormPage> {
  int? selectedAsetId;
  int? selectedKeluargaId;

  @override
  void initState() {
    super.initState();
    context.read<AsetBloc>().add(LoadAset());
    context.read<KeluargaBloc>().add(FetchKeluargaEvent());
    if (widget.editData != null) {
      selectedAsetId = widget.editData!['asset_id'];
      selectedKeluargaId = widget.editData!['keluarga_id'];
    }
  }

  void _submit() {
    final request = WarisanRequest(assetId: selectedAsetId!, keluargaId: selectedKeluargaId!);
    if (widget.editData != null) {
      context.read<WarisanBloc>().add(UpdateWarisan(widget.editData!['id'], request));
    } else {
      context.read<WarisanBloc>().add(CreateWarisan(request));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Warisan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<AsetBloc, AsetState>(
              builder: (context, state) {
                if (state is AsetDropdownLoaded) {
                  return DropdownButtonFormField<int>(
                    value: selectedAsetId,
                    decoration: InputDecoration(labelText: "Pilih Aset"),
                    items: state.asets.map<DropdownMenuItem<int>>((aset) {
                      return DropdownMenuItem(
                        value: aset.assetId,
                        child: Text("${aset.nama} - ${aset.berat}g - Rp${aset.harga}"),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedAsetId = val),
                  );
                }
                return CircularProgressIndicator();
              },
            ),

            SizedBox(height: 16),
            BlocBuilder<KeluargaBloc, KeluargaState>(
              builder: (context, state) {
                if (state is KeluargaLoadedState) {
                  return DropdownButtonFormField<int>(
                    value: selectedKeluargaId,
                    decoration: InputDecoration(labelText: "Pilih Anggota Keluarga"),
                    items: state.keluargaList.map<DropdownMenuItem<int>>((keluarga) {
                      return DropdownMenuItem(
                        value: keluarga.keluargaId,
                        child: Text(keluarga.nama ?? 'Tanpa Nama'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedKeluargaId = val),
                  );
                }
                return CircularProgressIndicator();
              },
            ),

            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}

