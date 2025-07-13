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

  final List<String> _titles = ['Dashboard', 'Aset & Warisan', 'Keluarga'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Muat Ulang Data',
            onPressed: () {
              context.read<DashboardBloc>().add(LoadDashboardData());
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Keluar',
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
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DashboardLoaded) {
                    final kategoriCount = state.kategoriCount;
                    final totalHarta = state.totalHarta;
                    final jumlahKeluarga = state.jumlahKeluarga;

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ringkasan Aset", style: Theme.of(context).textTheme.titleLarge),
                          SizedBox(height: 10),
                          ...kategoriCount.entries.map((entry) => Card(
                                child: ListTile(
                                  leading: Icon(Icons.category),
                                  title: Text("Kategori: ${entry.key}"),
                                  subtitle: Text("Jumlah Aset: ${entry.value}"),
                                ),
                              )),
                          SizedBox(height: 10),
                          Card(
                            color: Colors.amber[50],
                            child: ListTile(
                              leading: Icon(Icons.attach_money, color: Colors.green),
                              title: Text("Total Harta"),
                              subtitle: Text("Rp ${totalHarta.toString()}"),
                            ),
                          ),
                          SizedBox(height: 10),
                          Card(
                            color: Colors.lightBlue[50],
                            child: ListTile(
                              leading: Icon(Icons.people, color: Colors.blue),
                              title: Text("Total Anggota Keluarga"),
                              subtitle: Text("$jumlahKeluarga orang"),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is DashboardError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text("Belum ada data"));
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
              child: Text(
                'Menu Fitur',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(title: Text('Kelola Aset'), onTap: () => _navigateTo('/aset')),
            ListTile(title: Text('Kategori Aset'), onTap: () => _navigateTo('/kategori-aset')),
            ListTile(title: Text('Pengeluaran'), onTap: () => _navigateTo('/pengeluaran')),
            ListTile(title: Text('Lokasi'), onTap: () => _navigateTo('/lokasi')),
            ListTile(title: Text('Anggota Keluarga'), onTap: () => _navigateTo('/keluarga')),
            ListTile(title: Text('Kategori Keluarga'), onTap: () => _navigateTo('/kategori-keluarga')),
            ListTile(title: Text('Warisan'), onTap: () => _navigateTo('/warisan')),
            ListTile(title: Text('Total Aset'), onTap: () => _navigateTo('/total-aset')),
            ListTile(title: Text('Total Harta'), onTap: () => _navigateTo('/total-harta')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Aset'),
          BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: 'Keluarga'),
        ],
      ),
    );
  }
}
