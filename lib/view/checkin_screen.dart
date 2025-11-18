import 'package:attendance_project/widget/card_date.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class DashboardScreenAttendence extends StatefulWidget {
  const DashboardScreenAttendence({super.key});

  @override
  State<DashboardScreenAttendence> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<DashboardScreenAttendence> {
  GoogleMapController? mapController;
  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();
  GoogleMapController? mapsController;

  LatLng _currentPosition = LatLng(-6.2000, 108.816666);
  String _currentAddress = "Alamat tidak ditemukan";
  Marker? _marker;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================= APP BAR =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D91),
        elevation: 0,
        title: const Text(
          "Riwayat Kehadiran",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundColor: Colors.yellow.shade600,
              child: const Icon(Icons.person, color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      // ========================= BODY =========================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------- GOOGLE MAP ----------------------
            Column(
              children: [
                SizedBox(
                  height: 400,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 14,
                    ),
                  ),
                ),
                Text(_currentAddress),
                ElevatedButton(
                  onPressed: () {
                    _getCurrentLocation();
                  },
                  child: Text("Refresh Location"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _marker = Marker(
        markerId: const MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: "Lokasi Anda",
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}, ${place.postalCode}";

      mapsController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });

    // ---------------------- STATUS ----------------------
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Text(
            "Status: ",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Text(
            "Belum Check In",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );

    const SizedBox(height: 5);

    // ---------------------- ALAMAT ----------------------
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 16),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: const [
    //       Text(
    //         "Alamat: ",
    //         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    //       ),
    //       Expanded(
    //         child: Text(
    //           "Jl. Pangeran Diponegoro No 5, Kec. Medan Petisah, Kota Medan, Sumatra Utara",
    //           style: TextStyle(fontSize: 13),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    SizedBox(height: 18);

    // ========================= CARD JAM =========================
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // BOX HARI
            Container(
              height: 70,
              width: 75,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getDayName(today.weekday), // hari real-time
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    today.day.toString(), // tanggal real-time
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // JAM CHECK IN & OUT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Check In"),
                  SizedBox(height: 4),
                  Text(
                    "07 : 50 : 00",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text("Check Out"),
                  SizedBox(height: 4),
                  Text(
                    "17 : 50 : 00",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

            // BUTTON FOTO
            Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    print("Ambil foto ditekan!");
                    ImagePicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.camera_alt, size: 22),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Ambil Foto",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    const SizedBox(height: 20);

    // ========================= BUTTON CHECK IN =========================
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3D91),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // TODO: Integrasi API CHECK IN
              },
              child: const Text(
                "Check In",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // TODO: Integrasi API CHECK IN
              },
              child: Text(
                "Check Out",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );

    SizedBox(height: 30);
  }
}
