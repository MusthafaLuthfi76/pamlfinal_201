import 'package:emas_app/data/repository/asetRepository.dart';
import 'package:emas_app/data/repository/keluargaRepository.dart';
import 'package:emas_app/presentation/pages/bloc/dashboard_bloc.dart';
import 'package:emas_app/presentation/pages/bloc/dashboard_event.dart';
import 'package:emas_app/presentation/pages/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final Color goldColor = const Color(0xFFFFD700);
  final List<String> _titles = ['Dashboard', 'Aset & Warisan', 'Keluarga'];
  final List<Color> cardColors = [
    Color(0xFFFFF8E1),
    Color(0xFFE3F2FD),
    Color(0xFFE8F5E9),
    Color(0xFFFFEBEE),
    Color(0xFFF3E5F5),
    Color(0xFFFFF3E0),
    Color(0xFFE0F2F1),
  ];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardData());
  }

  Future<void> _navigateAndRefresh(String routeName) async {
    final result = await Navigator.pushNamed(context, routeName);
    if (result == true) {
      context.read<DashboardBloc>().add(LoadDashboardData());
    }
  }

  void _onTap(int index) async {
    if (index == 0) {
      setState(() => _currentIndex = 0);
      context.read<DashboardBloc>().add(LoadDashboardData());
    } else if (index == 1) {
      await _navigateAndRefresh('/aset');
    } else if (index == 2) {
      await _navigateAndRefresh('/keluarga');
    }
  }

  void _navigateTo(String route) async {
    await _navigateAndRefresh(route);
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: (iconColor ?? Colors.grey).withOpacity(0.2),
            child: Icon(icon, color: iconColor ?? Colors.black),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ],
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
        toolbarHeight: 80,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DashboardBloc>().add(LoadDashboardData()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: _currentIndex == 0
          ? RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(LoadDashboardData());
              },
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardLoaded) {
                    final kategoriCount = state.kategoriCount;
                    final totalHarta = state.totalHarta;
                    final jumlahKeluarga = state.jumlahKeluarga;

                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 3 / 2,
                            ),
                            itemCount: kategoriCount.length,
                            itemBuilder: (context, index) {
                              final kategori = kategoriCount.keys.elementAt(index);
                              final jumlah = kategoriCount[kategori]!;
                              final totalHarga = state.totalAsetPerKategori[kategori] ?? 0.0;
                              final bgColor = cardColors[index % cardColors.length];

                              return Container(
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(kategori, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text("Jumlah: $jumlah", style: TextStyle(color: Colors.grey[800])),
                                    Text("Nilai: Rp ${totalHarga.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[800])),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildSummaryCard(
                            icon: Icons.attach_money,
                            title: "Total Harta",
                            subtitle: "Rp ${totalHarta.toStringAsFixed(0)}",
                            backgroundColor: Colors.green[50],
                            iconColor: Colors.green,
                          ),
                          _buildSummaryCard(
                            icon: Icons.people,
                            title: "Total Anggota Keluarga",
                            subtitle: "$jumlahKeluarga orang",
                            backgroundColor: Colors.blue[50],
                            iconColor: Colors.blue,
                          ),
                        ],
                      ),
                    );
                  } else if (state is DashboardError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("Belum ada data"));
                },
              ),
            )
          : const SizedBox.shrink(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: const Text('Menu Fitur', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: const Text('Kelola Aset'), onTap: () => _navigateTo('/aset')),
            ListTile(title: const Text('Kategori Aset'), onTap: () => _navigateTo('/kategori-aset')),
            ListTile(title: const Text('Pengeluaran'), onTap: () => _navigateTo('/pengeluaran')),
            ListTile(title: const Text('Lokasi'), onTap: () => _navigateTo('/lokasi')),
            ListTile(title: const Text('Anggota Keluarga'), onTap: () => _navigateTo('/keluarga')),
            ListTile(title: const Text('Kategori Keluarga'), onTap: () => _navigateTo('/kategori-keluarga')),
            ListTile(title: const Text('Warisan'), onTap: () => _navigateTo('/warisan')),
          ],
        ),
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
