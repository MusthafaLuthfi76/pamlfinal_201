import 'package:emas_app/presentation/lokasi/bloc/lokasi_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import 'package:emas_app/data/model/response/lokasiResponse.dart';
import 'package:emas_app/data/model/request/lokasiRequest.dart';

class LokasiFormPage extends StatefulWidget {
  final Lokasi? lokasi;

  const LokasiFormPage({Key? key, this.lokasi}) : super(key: key);

  @override
  _LokasiFormPageState createState() => _LokasiFormPageState();
}

class _LokasiFormPageState extends State<LokasiFormPage> {
  final _namaController = TextEditingController();
  final _searchController = TextEditingController();
  double? _latitude;
  double? _longitude;
  String _locationName = '';

  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(-6.200000, 106.816666);

  @override
  void initState() {
    super.initState();

    if (widget.lokasi != null) {
      _namaController.text = widget.lokasi!.nama ?? '';
      _latitude = widget.lokasi!.latitude;
      _longitude = widget.lokasi!.longitude;

      if (_latitude != null && _longitude != null) {
        _initialPosition = LatLng(_latitude!, _longitude!);
        _searchLocation(_initialPosition);
      }
    }
  }

  // Menambahkan method untuk mendapatkan nama lokasi dari koordinat
  Future<void> _searchLocation(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _locationName =
              "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
        });
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  // Menambahkan method untuk mencari lokasi berdasarkan nama
  Future<void> _searchByName(String name) async {
    try {
      List<Location> locations = await locationFromAddress(name);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final latLng = LatLng(loc.latitude, loc.longitude);
        mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
        setState(() {
          _latitude = latLng.latitude;
          _longitude = latLng.longitude;
        });
        _searchLocation(latLng);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lokasi tidak ditemukan")),
        );
      }
    } catch (e) {
      print("Error searching by name: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mencari lokasi")),
      );
    }
  }

  // Event onTap untuk memilih lokasi di peta
  void _onTap(LatLng position) {
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
    _searchLocation(position);
  }

  // Validasi dan simpan lokasi
  void _save() {
    if (_namaController.text.isEmpty || _latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Isi semua field dan pilih lokasi di peta")),
      );
      return;
    }

    final lokasiRequest = LokasiRequest(
      nama: _namaController.text,
      latitude: _latitude!,
      longitude: _longitude!,
    );

    final lokasiBloc = context.read<LokasiBloc>();

    if (widget.lokasi == null) {
      lokasiBloc.add(CreateLokasiEvent(lokasiRequest)); // Gunakan event CreateLokasiEvent
    } else {
      lokasiBloc.add(UpdateLokasiEvent(widget.lokasi!.lokasiId!, lokasiRequest)); // Update lokasi yang sudah ada
    }

    Navigator.pop(context); // Kembali setelah simpan
  }

  @override
  Widget build(BuildContext context) {
    final marker = (_latitude != null && _longitude != null)
        ? Marker(
            markerId: MarkerId('selected_location'),
            position: LatLng(_latitude!, _longitude!),
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lokasi == null ? "Tambah Lokasi" : "Edit Lokasi"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Lokasi'),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Cari lokasi (misal: Monas Jakarta)',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: Icon(Icons.search),
                  label: Text('Cari'),
                  onPressed: () => _searchByName(_searchController.text),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                onTap: _onTap,
                markers: marker != null ? {marker} : {},
              ),
            ),
            SizedBox(height: 12),
            Text(
              _locationName.isEmpty
                  ? "Pilih lokasi di peta atau cari lokasi"
                  : "Lokasi: $_locationName",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text(widget.lokasi == null ? 'Simpan Lokasi' : 'Update Lokasi'),
            ),
          ],
        ),
      ),
    );
  }
}
