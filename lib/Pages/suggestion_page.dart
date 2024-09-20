import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geekhaven/Pages/marker_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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
              onTap: () => _showMarker(markerData) ,
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

  // show marker dialog

  void showMarker(BuildContext context, LatLng position){
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add Marker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(label: Text("Title")),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(label: Text("Description")),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
            TextButton(onPressed: (){
              addMarker(position, titleController.text, descController.text);
              Navigator.pop(context);
            }, child: Text("Cancel")),
          ],

        ),
    );
  }

  // show marker data when clicked
  //can add more things

  void _showMarker(MarkData markerData){
    showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text(markerData.title),
          content: Text(markerData.description),
          actions: [
            IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close))
          ],
        ));
  }

  //search function
  Future<void> searchPlaces(String query) async {
    if(query.isEmpty){
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';

    final responce = await http.get(Uri.parse(url));
    final data = json.decode(responce.body);

    if(data.isNotEmpty){
      setState(() {
        _searchResults = data;
      });
    }else{
      setState(() {
        _searchResults = [];
      });
    }
  }

  // move to any specific place
  void _movetoLocation(double Lat, double Lon){
    LatLng location = LatLng(Lat, Lon);
    _mapController.move(location, 15.0);
    setState(() {
      selectedPosition = location;
      _searchResults = [];
      isSearching = false;
      searchController.clear();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener((){
      searchPlaces(searchController.text);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.background,),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialZoom: 13.0,
                initialCenter:const LatLng(25.430, 81.772),
                onTap: (tapPosition, Latlng){
                  selectedPosition = Latlng;
                  draggedPosition = selectedPosition;

                }
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),

                MarkerLayer(markers: _markers),
                if(isDragged && draggedPosition != null)
                  MarkerLayer(
                      markers: [Marker(
                          point: draggedPosition!,
                          width: 80,
                          height: 80,
                          child: Icon(Icons.location_on_sharp, color: Colors.black45, size: 43,),
                      ),],
                  ),
                if(myLocation != null)
                  MarkerLayer(
                    markers: [Marker(
                      point: myLocation!,
                      width: 80,
                      height: 80,
                      child: Icon(Icons.location_on_sharp, color: Colors.blue, size: 43,),
                    ),],
                  ),
              ],
            ),
          // Search widget
          Positioned(
              top: 40,
              left: 15,
              right: 15,
              child: Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search Location",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: isSearching ? IconButton(onPressed: (){
                          searchController.clear();
                          setState(() {
                            isSearching = false;
                            _searchResults = [];
                          });
                        }, icon: Icon(Icons.clear)): null
                      ),

                      onTap: (){
                        setState(() {
                          isSearching = true;
                        });
                      },
                    ),
                  ),

                  if(isSearching && _searchResults.isNotEmpty)
                    Container(
                      color: Colors.white,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResults.length,
                          itemBuilder: (ctx, index) {
                            final place = _searchResults[index];
                            return ListTile(
                              title: Text(place['display_name']),
                              onTap: (){
                                final lat = double.parse(place['lat']);
                                final lon = double.parse(place['lon']);
                                _movetoLocation(lat, lon);
                              },
                            );
                          }),
                    ),
                ],
              ),
          ),

          // add location button
          isDragged == false ? Positioned(
              bottom: 20,
              left: 20,
              child: FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.black,
                  onPressed: (){
                    setState(() {
                      isDragged = true;
                    });
                  },
                  child: Icon(Icons.add_location_alt_outlined),
                  )
          ) : Positioned(
                bottom: 20,
                left: 20,
                child: FloatingActionButton(
                    backgroundColor: Colors.deepOrangeAccent,
                    foregroundColor: Colors.black,
                    onPressed: (){
                      setState(() {
                        isDragged = true;
                      });
                    },
                    child: Icon(Icons.wrong_location),
                    )
                ),
          Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    onPressed: showcurrentLocation,
                    child: Icon(Icons.location_searching_rounded),
                  ),
                  if(isDragged)
                  Padding(padding: EdgeInsets.only(top: 20),
                    child: FloatingActionButton(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      onPressed:() {
                        if(draggedPosition!=null){
                          showMarker(context, draggedPosition!);
                        }

                        setState(() {
                          isDragged = false;
                          draggedPosition = null;
                        });
                      },
                      child: Icon(Icons.check),
                    )
                  ),

                ],
              )
          ),
          ],
        ),
      );
  }
}
