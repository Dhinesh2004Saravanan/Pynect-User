import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:info_popup/info_popup.dart';
import 'package:latlong2/latlong.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}




class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}


 List<LatLng> latlng=[LatLng(11.94236,79.7767635),LatLng(11.934110,79.808040)];



  List<Marker> markers=[];

var lat;
var lat2;
var lon2;
var lon;
var userid;
var token;
  List<LatLng> cabdrivers=[];
  List<LatLng> midpoints=[];



  double mindistance=-1;
  var finalan=[];





class _HomePageState extends State<HomePage> {
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    getLocationFromFirebase() ;

    
  //  getLocationRoute();
    getUserlocationPermission();
    getUserLocation();
    getNotificationPermission();
    loadFCM();
    listenFCM();

  }
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }


  getNotificationPermission() async
  {
    NotificationSettings settings;
    settings=await messaging.requestPermission(
        announcement: true,
        alert: true,
        badge: true,carPlay: true,
        sound: true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized)
    {
      print("User has provided the Access for notification");
    }
    else if(settings.authorizationStatus==AuthorizationStatus.denied)
    {
      print("USer has denied the permission");
    }
  }


  var data;
  late LocationPermission permission;
  late bool isServiceEnabled;
  var locate_latitude;
  var locate_longtitude;
  
  
  getLocationFromFirebase() async
  {
    print("firebase called");
    var answer=await FirebaseFirestore.instance.collection("CAB LOCATION").get();
     finalan= answer.docs.map((e) =>e.data()).toList();
      print("answer final is $finalan");
    for(int i=0;i<finalan.length;i++)
      {
        setState(() {
          locate_latitude=finalan[i]["latitude"];
          locate_longtitude=finalan[i]["longtitude"];
          cabdrivers.add(LatLng(locate_longtitude, locate_longtitude));

        });
      }











      print("latitude $locate_latitude,longtitude $locate_longtitude");

  }
  


 Future<void> getUserlocationPermission() async
 {
      isServiceEnabled=await Geolocator.isLocationServiceEnabled();
      if(!isServiceEnabled)
        {
          await Geolocator.requestPermission();
        }
      permission=await Geolocator.checkPermission();
      if(permission==LocationPermission.always)
        {
          print("PERMISSION GRANTED");
        }
      else if(permission==LocationPermission.denied)
        {
          print("PERMISSION DENIED");
          await Geolocator.requestPermission();
        }



  }

   Position? currentposition;

 Future<void> getUserLocation() async{
        print("USer location function called");
        currentposition=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        mindistance=calculateDistance(finalan[0]["latitude"],finalan[0]["longtitude"],currentposition?.latitude,currentposition?.longitude);
        lat=finalan[0]["latitude"];
        lon=finalan[0]["longtitude"];
        userid=finalan[0]["userid"];
        token=finalan[0]["token"];

        print("MINIMUM DISTANCE IS $mindistance");








if(currentposition != null){







   print("Current position latitude is ${currentposition!.latitude},${currentposition!.longitude}");



   await FirebaseFirestore.instance.collection("USERS COORDINATES").doc(FirebaseAuth.instance.currentUser?.uid).set(


       {
     "latitude":currentposition!.latitude,
     "longtitude":currentposition!.longitude,
     "userid":FirebaseAuth.instance.currentUser?.uid,


   }).whenComplete(() {
     print("COMPLETED SUCCESSFULLY FOR USER LOCATION");

   });


}else{
  print(currentposition);
}

   for(int i=0;i<cabdrivers.length;i++)
     {
       markers.add(Marker(point: cabdrivers[i], builder: (context)=>Container(
         child: Icon(Icons.account_box_rounded),
       )));
     }
   print(markers);
   print("print the markers of 0  is ${markers[0]}");






 }







  late AndroidNotificationChannel channel;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();


  getLocationRoute(slat,slon,dlat,dlon) async
  {
    print("function called");
    try
    {


//"https://api.mapbox.com/directions/v5/mapbox/driving/-74.291837%2C40.762911%3B-74.199819%2C40.867373?alternatives=true&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1IjoiZGhpbmVzaDIwMDQiLCJhIjoiY2xudXpiZnJiMGpqOTJucGF2ejltaDZuNiJ9.7_BuYpxL3qBKoLz2m4pATA"
      //List<LatLng> latlng=[LatLng(11.94236,79.7767635),LatLng(11.958791,79.784181)];

      //  var response =await http.get(Uri.parse("https://api.mapbox.com/directions/v5/mapbox/driving/11.94236%2C79.7767635%3B11.934110%2C79.808040?alternatives=true&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1IjoiZGhpbmVzaDIwMDQiLCJhIjoiY2xudXpiZnJiMGpqOTJucGF2ejltaDZuNiJ9.7_BuYpxL3qBKoLz2m4pATA"));
      var response=await http.get(Uri.parse("https://trueway-directions2.p.rapidapi.com/FindDrivingPath?origin=$slat%2C$slon&destination=$dlat%2C$dlon"),headers: {
        'X-RapidAPI-Key': 'f57d0797demsh1cd143822f6247fp185348jsnd47f87ec4638',
        'X-RapidAPI-Host': 'trueway-directions2.p.rapidapi.com'
      },

      );

      //print("response is ${response.body}");



      var answerjson=jsonDecode(response.body);
      print("JSON FORMAT ${answerjson}");

      print("answer is   ${answerjson["route"]["geometry"]["coordinates"]}");

      var final_ans=answerjson["route"]["geometry"]["coordinates"];

      print(final_ans[0]);


      var lat=final_ans[0][0];
      var lon=final_ans[0][1];


      for (int i=0;i<final_ans.length-1;i++)
      {
        var lat=final_ans[i][0];
        var lon=final_ans[i][1];
      setState(() {
        midpoints.add(LatLng(lat, lon));
      });
      }
      print(midpoints[0]);
      print("MIDPOINTS IS $midpoints" );










      // var response=await http.post(Uri.parse("https://api.openrouteservice.org/v2/directions/driving-car"),
      //     headers: {
      //       "Content-Type":"application/json",
      //       "Authorization":"5b3ce3597851110001cf6248a4a4c7faadf6468aaafe21acfdd57c87"
      //     }
      //     ,body: '{"coordinates":[[8.681495,49.41461],[8.686507,49.41943]]}'
      //
      // );
      //
      // print("Response is $response");
      // print("response body is ${response.body}");
      //
      // final mapanswer=jsonDecode(response.body);
      //
      // print("features is ${mapanswer["geometry"]}");




    }
    catch(e)
    {
      print(e);
    }


  }
TextEditingController destination=TextEditingController();

  CustomInfoWindowController _customInfoWindowController=CustomInfoWindowController();

 sendPushNotificationMessage(String token,String destinationplace) async
 {
      try{
         print("CLLFHGGHJHCCFXCFVJHHKJBHJ");

        var response=await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send')
        ,headers:{
            "Content-Type":"application/json",
              "Authorization":"key=AAAA5XmzBi0:APA91bFHgqJwav5MdCrhRaL-jctbfEyiDgbKAQnI-iO9NOi0W3LqG8Z-VYgUHZmrx5c0kgZJvm_idw-K1E348Q44t_nhoWLKFRKpn8oF9WPDZy52IryUAn9wMJRhacQ7q8VIIZduCH1r"
            },body: jsonEncode(

            <String,dynamic>
            {
              'notification':<String,dynamic>
              {
                'body':"You have received an order of picking to $destinationplace",
                'title':"FROM AGENCY"
              },
              'priority':'high',
              'data': <String, dynamic>
              {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to":token

            },


          ),

        );

        print(response.statusCode);

      }
      catch(e)
   {
     print(e);
   }
 }







  void listenFCM() async {


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,

              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }



  void loadFCM() async
  {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
var cuurentplace;

  Future getPlacefromLocation(lat,lon) async{

   try{

     var response=await http.get(Uri.parse("https://trueway-geocoding.p.rapidapi.com/ReverseGeocode?location=$lat%2C$lon&language=en"),headers: {
       'X-RapidAPI-Key': 'f57d0797demsh1cd143822f6247fp185348jsnd47f87ec4638',
       'X-RapidAPI-Host': 'trueway-geocoding.p.rapidapi.com'
     });
     print(response.body);


    setState(() {
      var r=jsonDecode(response.body);
      cuurentplace=r["results"][0]["address"];
    });
return cuurentplace;

   }
   catch (e)
    {
      throw e;
    }

  }







TextEditingController src=TextEditingController();
  String? ans=FirebaseAuth.instance.currentUser?.displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
        appBar: AppBar(
          title: Text("HOME PAGE"),),

        floatingActionButton: FloatingActionButton(onPressed:(){

          getLocationRoute(currentposition!.latitude,currentposition!.longitude,lat,lon);



        } ,child:
          Icon(Icons.get_app)
          ,),

        //lat https://www.google.com/maps/search/?api=1&query=11.94236,79.7767635
        body:SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Card(
                    child: Padding(

                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [

                        TextFormField(
                          controller: src,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "ENTER YOUR SOURCE LOCATION",
                              labelText: "SOURCE PLACE",
                            suffixIcon: IconButton(onPressed: (){
                              print("Clciked");

                             setState(()async {
                               dynamic dd = await getPlacefromLocation(currentposition?.latitude,currentposition?.longitude);
                              if(dd==null)
                                {
                                  print("Location null");
                                }
                              else
                                {
                                  src.text=dd;
                                }


                             });




                            },icon: Icon(FontAwesomeIcons.locationPinLock),)
                          ),
                        ),
                        SizedBox(height: 20,),


                        TextFormField(
                          controller: destination,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            hintText: "ENTER YOUR DESTINATION LOCATION",
                            labelText: "DESTINATION PLACE"
                          ),
                        ),


                        ElevatedButton(onPressed: ()
                        {


                         for(int i=0;i<cabdrivers.length;i++)
                           {
                               setState(()  {
                                 var currentdistance=calculateDistance(currentposition?.latitude, currentposition?.longitude, finalan[i]["latitude"], finalan[i]["longtitude"]);
                                  print("cuurent distance $currentdistance");
                                  print("mindistance is $mindistance");

                                  if(mindistance>currentdistance)
                                 {
                                   mindistance=currentdistance;
                                   lat=finalan[i]["latitude"];
                                   lon=finalan[i]["longtitude"];
                                   userid=finalan[i]["userid"];
                                   token=finalan[i]["token"];


                                 }






                               });
                               lat2=lat;
                               lon2=lon;


                               print("final cab min diistance coordinates ${lat} ${lon} ${userid} ${token}");
                               sendPushNotificationMessage(token, destination.text);

                           }

                         print("LAT2 $lat2,lon2 $lon2");







                        }, child: Text("SUBMIT")),
                        SizedBox(height: 20,),
                        SizedBox(
                          height: 500,
                          child: FlutterMap(
                            options: MapOptions(

                              center: currentposition == null?null: LatLng(currentposition!.latitude, currentposition!.longitude),
                              zoom: 10,
                              maxZoom: 19,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                maxZoom: 19,
                              ),

                              CurrentLocationLayer(
                                followOnLocationUpdate: FollowOnLocationUpdate.always,
                                turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                                style: LocationMarkerStyle(
                                  marker: const DefaultLocationMarker(
                                    child: Icon(
                                      Icons.navigation,
                                      color: Colors.white,
                                    ),
                                  ),
                                  markerSize: const Size(20,20),
                                  markerDirection: MarkerDirection.heading,
                                ),
                              ),








                              (lat2==null && lon2==null)?(MarkerLayer(
                                markers: [
                                  Marker(point: LatLng(0,0), builder: (context)=>Container())
                                ],

                              )):(MarkerLayer(
                                markers: [
                                  Marker(point: LatLng(lat2, lon2), builder: (context)=>Container(
                                    child: GestureDetector(
                                      onTap: (){
                                        print("Clicked the icon");
                                      },
                                      child: Icon(Icons.location_history),
                                    )
                                  )

                                  )
                                ],


                              )),


                              // MarkerLayer(markers: [
                              //   Marker(point: (locate_latitude ==null &&locate_longtitude==null)?(LatLng(0, 0)):(LatLng(locate_latitude, locate_longtitude)), builder:(context)=>Container(
                              //     child: Icon(Icons.account_box),
                              //   ) )
                              // ],),
                              PolylineLayer(
                                polylines:
                                [

                                  // (currentposition!.latitude==null && currentposition!.longitude==null)?
                                  //                                      (Polyline(points: [LatLng(0,0)])):(Polyline(points: [LatLng(currentposition!.latitude,currentposition!.longitude )])),
                                  Polyline(points: midpoints,strokeWidth: 2,color: Colors.black),












                                ],
                              )

                            ],
                          )
                        )



                      ],


                      ),
                    )
                ),
              )
]
    )
    )


    );

 }
}
