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
  int _currentIndex = 1;
  final Color goldColor = const Color(0xFFFFD700);

  @override
  void initState() {
    super.initState();
    context.read<AsetBloc>().add(FetchAllAset());
  }

  void _showDeleteDialog(BuildContext context, int asetId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Aset"),
        content: const Text("Apakah Anda yakin ingin menghapus aset ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
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
      color: Colors.grey[50],
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: fotoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  fotoUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
        title: Text(
          aset.nama ?? 'Tanpa Nama',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Berat: ${aset.berat} gram'),
              Text('Harga: Rp${aset.harga?.toStringAsFixed(0) ?? "0"}'),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.green),
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
              icon: const Icon(Icons.edit, color: Colors.blue),
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
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, aset.assetId!),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (index == 1) {
      // stay in aset
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/keluarga');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Kelola Aset', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: BlocConsumer<AsetBloc, AsetState>(
        listener: (context, state) {
          if (state is AsetSuccess || state is AsetDeleted || state is AsetUpdated) {
            context.read<AsetBloc>().add(FetchAllAset());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Operasi berhasil")),
            );
          }
        },
        builder: (context, state) {
          if (state is AsetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AsetListLoaded) {
            final asetList = state.aset.map((e) => Aset.fromMap(e)).toList();
            if (asetList.isEmpty) {
              return const Center(child: Text("Belum ada aset."));
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
          return const Center(child: Text("Tidak ada data."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AsetBloc>(),
                child: const HalamanFormAset(),
              ),
            ),
          );
        },
        backgroundColor: goldColor,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: goldColor,
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Aset'),
          BottomNavigationBarItem(icon: Icon(Icons.family_restroom_outlined), label: 'Keluarga'),
        ],
      ),
    );
  }
}
