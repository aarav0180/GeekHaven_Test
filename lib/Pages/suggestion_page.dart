import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geekhaven/Pages/marker_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final MapController _mapController = MapController();
  List<MarkData> _markerData = [];
  List<Marker> _markers = [];
  LatLng? selectedPosition;
  LatLng? myLocation;
  LatLng? draggedPosition;
  bool isDragged = false;
  TextEditingController searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool isSearching = false;


  //get Current location
  Future<Position> myPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Test if locations services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error("Location permission denied");
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition();

  }

  //show current Location
  void showcurrentLocation()async {
    try {
      Position position = await myPosition();
      LatLng currentLatlng = LatLng(position.latitude, position.longitude);
      _mapController.move(currentLatlng, 15.0);
      setState(() {
        myLocation = currentLatlng;
      });
    }catch(e){
      print(e);
    }
  }

  // add marker on map
  void addMarker(LatLng position, String title, String description){
    setState(() {
      final markerData = MarkData(position: position, title: title, description: description);
      _markerData.add(markerData);
      _markers.add(
        Marker(
            point: position,
            height: 80,
            width: 80,
            child: GestureDetector(
              onTap: (){} ,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text(title, style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  const Icon(
                    Icons.location_on_sharp,
                    color: Colors.red,
                    size: 43,
                  )
                ],
              ),
            )
        )
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialZoom: 13.0,
                initialCenter:const LatLng(25.430, 81.772),
                onTap: (tapPosition, Latlng){

                }
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                )
              ],
            )
          ],
        ),
      );
  }
}
