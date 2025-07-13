import 'package:emas_app/data/repository/kategoriKeluargaRepo.dart';
import 'package:emas_app/data/repository/keluargaRepository.dart';
import 'package:emas_app/data/repository/lokasiRepository.dart';
import 'package:emas_app/data/repository/pengeluaranRepository.dart';
import 'package:emas_app/data/repository/warisanRepository.dart';
import 'package:emas_app/presentation/aset/AsetHome.dart';
import 'package:emas_app/presentation/aset/bloc/aset_bloc.dart';
import 'package:emas_app/presentation/auth/register_screen.dart';
import 'package:emas_app/presentation/keluarga/bloc/kategori_keluarga_bloc.dart';
import 'package:emas_app/presentation/keluarga/bloc/keluarga_bloc.dart';
import 'package:emas_app/presentation/keluarga/keluargaHome.dart';
import 'package:emas_app/presentation/lokasi/bloc/lokasi_bloc.dart';
import 'package:emas_app/presentation/lokasi/lokasiHome.dart';
import 'package:emas_app/presentation/pages/bloc/dashboard_bloc.dart';
import 'package:emas_app/presentation/pages/dashboard_screen.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:emas_app/presentation/pengeluaran/pengeluaran_page.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_bloc.dart';
import 'package:emas_app/presentation/warisan/warisan_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/data/repository/authRepository.dart';
import 'package:emas_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:emas_app/presentation/auth/login_screen.dart';
import 'package:emas_app/presentation/pages/kategori_aset_screen.dart';
import 'package:emas_app/presentation/pages/kategori_keluarga_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthRepository())),
        BlocProvider<LokasiBloc>(create: (_) => LokasiBloc(LokasiRepository())),
        BlocProvider<KategoriKeluargaBloc>(create: (_) => KategoriKeluargaBloc(KategoriKeluargaRepository())),
        BlocProvider<KeluargaBloc>(create: (_) => KeluargaBloc(KeluargaRepository())),
        BlocProvider<AsetBloc>( create: (_) => AsetBloc(),),
        BlocProvider<PengeluaranBloc>(create: (_) => PengeluaranBloc(PengeluaranRepository())),
        BlocProvider<WarisanBloc>(create: (_) => WarisanBloc(WarisanRepository())),
        BlocProvider<DashboardBloc>(create: (_) => DashboardBloc()),
      ],
      child: MaterialApp(
        title: 'Aplikasi Emas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.amber),
        initialRoute: '/login',
        routes: {
          '/login': (_) => LoginScreen(),
          '/register': (_) => RegisterScreen(),
          '/dashboard': (_) => DashboardScreen(),
          '/kategori-aset': (_) => KategoriAsetScreen(),
          '/kategori-keluarga': (_) => KategoriKeluargaScreen(),
          '/lokasi': (_) => LokasiHomePage(),
          '/keluarga': (_) => KeluargaHomePage(),
          '/aset': (_) => AsetHomePage(),
          '/pengeluaran': (context) => HomePengeluaranPage(),
          '/warisan': (_) => WarisanHomePage(),
        },
      ),
    );
  }
}
