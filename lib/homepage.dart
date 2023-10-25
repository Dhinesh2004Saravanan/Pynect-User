import 'package:agencyconnect/ordercab.dart';
import 'package:agencyconnect/travelagencies.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,



      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: 170,),

            GestureDetector(
              onTap: (){
                print("order your cab");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
              },
              child: Container(
                width: double.infinity,
                child: Card(
                  child:Row(
                    children: [
                      Image.asset("assets/build.png",width: 170,height: 150,
                      ),
                      SizedBox(width: 20,),
                      Expanded(child: Text("ORDER YOUR CAB",style: GoogleFonts.aBeeZee(fontSize: 30),))


                    ],
                  ),
                ),
              ),
            ),


            SizedBox(height: 70,),

            GestureDetector(
              onTap: (){
                print("TRAVEL AGENCIES LIST");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TravelList()));
              },
              child: Container(
                width: double.infinity,
                child: Card(
                  child:Row(
                    children: [
                      Image.asset("assets/build.png",width: 170,height: 150,
                      ),
                      SizedBox(width: 20,),
                      Expanded(child: Text("TRAVEL AGENCY LIST",style: GoogleFonts.aBeeZee(fontSize: 30),))


                    ],
                  ),
                ),
              ),
            )

            
          ],
        ),
      ),
    );
  }
}

