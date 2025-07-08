import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Dashboard Utama")),
    Center(child: Text("Aset")),
    Center(child: Text("Keluarga")),
  ];

  final List<String> _titles = ['Dashboard', 'Aset & Warisan', 'Keluarga'];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: _pages[_currentIndex],
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
            ListTile(
              title: Text('Kelola Aset'),
              onTap: () => _navigateTo('/aset'),
            ),
            ListTile(
              title: Text('Kategori Aset'),
              onTap: () => _navigateTo('/kategori-aset'),
            ),
            ListTile(
              title: Text('Pengeluaran'),
              onTap: () => _navigateTo('/pengeluaran'),
            ),
            ListTile(
              title: Text('Lokasi'),
              onTap: () => _navigateTo('/lokasi'),
            ),
            ListTile(
              title: Text('Anggota Keluarga'),
              onTap: () => _navigateTo('/keluarga'),
            ),
            ListTile(
              title: Text('Kategori Keluarga'),
              onTap: () => _navigateTo('/kategori-keluarga'),
            ),
            ListTile(
              title: Text('Warisan'),
              onTap: () => _navigateTo('/warisan'),
            ),
            ListTile(
              title: Text('Total Aset'),
              onTap: () => _navigateTo('/total-aset'),
            ),
            ListTile(
              title: Text('Total Harta'),
              onTap: () => _navigateTo('/total-harta'),
            ),
            ListTile(
              title: Text('Jumlah Keluarga'),
              onTap: () => _navigateTo('/total-keluarga'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Aset',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Keluarga',
          ),
        ],
      ),
    );
  }
}
