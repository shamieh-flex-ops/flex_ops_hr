import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanyLocationMap extends StatefulWidget {
  final LatLng companyLocation;
  final Function(LatLng) onLocationDetermined;

  const CompanyLocationMap({
    super.key,
    required this.companyLocation,
    required this.onLocationDetermined,
  });

  @override
  State<CompanyLocationMap> createState() => _CompanyLocationMapState();
}

class _CompanyLocationMapState extends State<CompanyLocationMap> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLocationDetermined(widget.companyLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h, // responsive height
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r), // responsive radius
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.companyLocation,
            zoom: 16, // Zoom level
          ),
          markers: {
            Marker(
              markerId: const MarkerId("company_location"),
              position: widget.companyLocation,
              infoWindow: const InfoWindow(title: "Company Location"),
            ),
          },
          onMapCreated: (controller) => mapController = controller,
          zoomControlsEnabled: false,
          myLocationEnabled: false,
          compassEnabled: true,
        ),
      ),
    );
  }
}
