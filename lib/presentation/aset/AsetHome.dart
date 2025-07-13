import 'package:emas_app/data/model/response/asetResponse.dart';
import 'package:emas_app/presentation/aset/AsetDetail.dart';
import 'package:emas_app/presentation/aset/AsetForm.dart';
import 'package:emas_app/presentation/aset/bloc/aset_bloc.dart';
import 'package:emas_app/presentation/aset/bloc/aset_event.dart';
import 'package:emas_app/presentation/aset/bloc/aset_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AsetHomePage extends StatefulWidget {
  const AsetHomePage({super.key});

  @override
  State<AsetHomePage> createState() => _AsetHomePageState();
}

class _AsetHomePageState extends State<AsetHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AsetBloc>().add(FetchAllAset());
  }

  void _showDeleteDialog(BuildContext context, int asetId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hapus Aset"),
        content: Text("Apakah Anda yakin ingin menghapus aset ini?"),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Hapus"),
            onPressed: () {
              Navigator.pop(context);
              context.read<AsetBloc>().add(DeleteAset(asetId));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAsetCard(Aset aset) {
  final fotoUrl = (aset.foto != null && aset.foto!.isNotEmpty)
      ? (aset.foto!.startsWith("http")
          ? aset.foto!
          : "http://192.168.0.185:3000${aset.foto!}")
      : null;

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      leading: fotoUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                fotoUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
              ),
            )
          : Icon(Icons.image, size: 60, color: Colors.grey),
      title: Text(aset.nama ?? 'Tanpa Nama'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Berat: ${aset.berat} gram'),
          Text('Harga: Rp${aset.harga?.toStringAsFixed(0) ?? "0"}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.visibility, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailAsetPage(aset: aset),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AsetBloc>(),
                    child: HalamanFormAset(existingData: aset.toMap()),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteDialog(context, aset.assetId!);
            },
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kelola Aset')),
      body: BlocConsumer<AsetBloc, AsetState>(
        listener: (context, state) {
          if (state is AsetSuccess || state is AsetDeleted || state is AsetUpdated) {
            context.read<AsetBloc>().add(FetchAllAset());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Operasi berhasil")),
            );
          }
        },
        builder: (context, state) {
          if (state is AsetLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AsetListLoaded) {
            final asetList = state.aset.map((e) => Aset.fromMap(e)).toList();
            if (asetList.isEmpty) {
              return Center(child: Text("Belum ada aset."));
            }
            return ListView.builder(
              itemCount: asetList.length,
              itemBuilder: (context, index) {
                return _buildAsetCard(asetList[index]);
              },
            );
          } else if (state is AsetFailure) {
            return Center(child: Text("Gagal memuat aset: ${state.message}"));
          }
          return Center(child: Text("Tidak ada data."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AsetBloc>(),
                child: HalamanFormAset(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
