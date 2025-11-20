import 'package:attendance_project/preferences/preferences_handler.dart';
import 'package:attendance_project/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TakeAttendenceScreen extends StatefulWidget {
  const TakeAttendenceScreen({super.key});

  @override
  State<TakeAttendenceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<TakeAttendenceScreen> {
  bool isloadingout = false;
  bool isLoadingIn = false;

  GoogleMapController? mapsController;
  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  LatLng _currentPosition = const LatLng(-6.2000, 108.816666);
  String _currentAddress = "Alamat tidak ditemukan";

  Marker? _marker;

  // ===== STATUS CHECK-IN / CHECK-OUT =====
  String checkInStatus = "Belum Check In";

  Color statusColor = Colors.red;
  bool hasCheckedIn = false;
  bool hasCheckedOut = false;
  String checkInTime = "";
  String checkOutTime = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadAttendanceStatus();
  }

  // ===== LOAD STATUS DARI SHAREDPREFERENCES (Digabung) =====
  Future<void> _loadAttendanceStatus() async {
    final savedIn = await PreferenceHandler.getCheckInStatus();
    final savedInTime = await PreferenceHandler.getCheckInTime();
    final savedOut = await PreferenceHandler.getCheckOutStatus();
    final savedOutTime = await PreferenceHandler.getCheckOutTime();

    if (savedIn == "checked") {
      setState(() {
        hasCheckedIn = true;
        checkInTime = savedInTime ?? "—";

        hasCheckedOut = savedOut == "checked";
        checkOutTime = savedOutTime ?? "—";
        checkOutTime = "—";

        // Tentukan status dan warna berdasarkan status Check In dan Check Out
        if (hasCheckedOut) {
          checkInStatus = "Sudah Check Out";
          statusColor = Colors.red;
        } else {
          checkInStatus = "Sudah Check In";
          statusColor = Colors.green;
        }
      });
    }
  }

  // ===== GET CURRENT LOCATION =====
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
      position.latitude,
      position.longitude,
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
    });

    mapsController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 16),
      ),
    );
  }

  String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "Sunday";
    }
  }

  DateTime get today => DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D91),
        elevation: 0,
        title: const Text(
          "Riwayat Kehadiran",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== GOOGLE MAP =====
            SizedBox(
              height: 300,
              child: GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 14,
                ),
                markers: _marker != null ? {_marker!} : {},
                onMapCreated: (ctrl) => mapsController = ctrl,
              ),
            ),

            const SizedBox(height: 10),

            // ===== STATUS =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    checkInStatus,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // ===== ALAMAT =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Alamat: ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Expanded(
                    child: Text(
                      _currentAddress,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ===== CARD JAM =====
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // DATE BOX
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
                            getDayName(today.weekday),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${today.day}",
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

                    // JAM CHECK IN/OUT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Check In"),
                          const SizedBox(height: 4),
                          Text(
                            hasCheckedIn ? checkInTime : "—",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text("Check Out"),
                          const SizedBox(height: 4),
                          Text(
                            hasCheckedOut ? checkOutTime : "—",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CAMERA BUTTON
                    Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () async {
                            pickedImage = await picker.pickImage(
                              source: ImageSource.camera,
                            );
                            setState(() {});
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
            ),

            const SizedBox(height: 20),

            // ===== BUTTON CHECK IN =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasCheckedIn ? null : _handleCheckIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3D91),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoadingIn
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Check In",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ),

            // ===== BUTTON CHECK OUT =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: !hasCheckedIn || hasCheckedOut
                      ? null
                      : _handleCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3D91),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isloadingout
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Check out",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ===== HANDLE CHECK IN =====
  Future<void> _handleCheckIn() async {
    setState(() => isLoadingIn = true);

    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String attendanceDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      String timeNow = DateFormat("HH:mm").format(DateTime.now());

      // CALL API
      final response = await TrainingAPI.checkIn(
        attendanceDate: attendanceDate,
        CheckInTime: timeNow,
        checkInLat: pos.latitude,
        checkInLng: pos.longitude,
        checkInAddress: _currentAddress,
        status: "masuk",
      );

      // ————— SIMPAN STATUS (API SUKSES) —————
      await PreferenceHandler.saveCheckInStatus("checked");
      await PreferenceHandler.saveCheckInTime(timeNow);

      setState(() {
        hasCheckedIn = true;
        checkInStatus = "Sudah Check In";
        statusColor = Colors.green;
        checkInTime = timeNow;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Check-in berhasil")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal Check-in: $e")));
    }

    setState(() => isLoadingIn = false);
  }

  // ===== HANDLE CHECK OUT =====
  Future<void> _handleCheckout() async {
    if (!hasCheckedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap Check In terlebih dahulu")),
      );
      return;
    }

    setState(() => isloadingout = true);

    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String attendanceDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      String timeNow = DateFormat("HH:mm").format(DateTime.now());

      // CALL API
      final response = await TrainingAPI.CheckOut(
        attendanceDate: attendanceDate,
        CheckoutTime: timeNow,
        checkoutLat: pos.latitude,
        checkoutLng: pos.longitude,
        checkoutAddress: _currentAddress,
        status: "keluar",
      );

      // ————— SIMPAN STATUS (API SUKSES) —————
      await PreferenceHandler.saveCheckOutStatus("checked");
      await PreferenceHandler.saveCheckOutTime(timeNow);

      setState(() {
        hasCheckedOut = true;
        checkInStatus = "Sudah Check Out";
        statusColor = Colors.red;
        checkOutTime = timeNow;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Check-out berhasil")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal Check-out: $e")));
    }

    setState(() => isloadingout = false);
  }
}
