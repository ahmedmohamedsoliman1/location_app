import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     initialRoute: MapScreen.routeName,
     routes: {
       MapScreen.routeName : (context) => MapScreen()
     },
   );
  }
}

class MapScreen extends StatefulWidget {

  static const String routeName = "map";

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  //
  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final GoogleMapController? _controller ;

  StreamSubscription? subscription ;

  Location liveLocation = Location();

  late Marker marker ;

  late Circle circle ;

  late Polyline polyline ;

  MarkerId markerId = const MarkerId("me");
  Set<Marker> markers =  {};
  Set<Circle> circles = {};
  Set<Polyline> polyLines = {};

  @override
  void initState() {
    marker = Marker(markerId: MarkerId("me") ,
    position: LatLng(37.43296265331129, -122.08832357078792),
    zIndex: 2 ,
      flat: true ,
      draggable: false
    );
    circle = Circle(circleId: CircleId("circle") ,
    center: LatLng(37.43296265331129, -122.08832357078792),
    zIndex: 1 ,
      radius: 2
    );
    polyline = Polyline(polylineId: PolylineId("poly"),
    zIndex: 1 ,
    color: Colors.red ,
    width: 1 ,
    jointType: JointType.round);

    markers.add(marker);
    circles.add(circle);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold (
     body: GoogleMap(
       markers: markers,
       circles: circles,
       polylines: polyLines,
       mapType: MapType.normal,
       initialCameraPosition: MapScreen._kGooglePlex,
       onMapCreated: (GoogleMapController controller) {
         _controller = controller;
       },
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         getCurrentLocation();
       },
       child: const Icon(Icons.directions_boat),
     ),
   );
  }

  Future <Uint8List> getMarker ()async{
    ByteData byteData = await rootBundle.load("assets/images/car2.png");
    return byteData.buffer.asUint8List();
  }

  getCurrentLocation ()async{
 try {
   Uint8List imageData = await getMarker();
   var location = await liveLocation.getLocation();
   if (subscription != null){
     subscription!.cancel() ;
   }else {
     subscription = liveLocation.onLocationChanged.listen((newLocation) {
       LatLng newLatLong = LatLng(newLocation.latitude!, newLocation.longitude!);
       _controller!.animateCamera(
         CameraUpdate.newCameraPosition(
           CameraPosition(target: newLatLong , zoom: 18),
         ),
       );
       updateLocation(imageData, newLocation);
     });
      setState(() {
      });
   }
   updateLocation(imageData, location);
  }catch (e){
   rethrow ;
 }
  }

  updateLocation (Uint8List imageData , LocationData locationData){
   LatLng latLng = LatLng(locationData.latitude!, locationData.longitude!);
   marker = Marker(
   markerId: MarkerId("me") ,
   position: latLng,
   flat: true ,
   draggable: false ,
   icon: BitmapDescriptor.fromBytes(imageData) ,
   zIndex: 2 ,
   rotation: locationData.heading!.toDouble(),
       anchor: Offset(0.0, 0.2),);

   circle = Circle(
   circleId: CircleId("circle") ,
   zIndex: 1 ,
   radius: 2 ,
   fillColor: Colors.blue ,
   strokeWidth: 0,
   strokeColor: Colors.transparent,
   center: latLng);

   setState(() {
     markers.add(marker);
     circles.add(circle);
   });
  }
}

/// AIzaSyCvS8iisJvvwPHOeMJgL5hcmn_h4WPYVVU
