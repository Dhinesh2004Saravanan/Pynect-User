import 'package:agencyconnect/ordercab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';



class TravelList extends StatefulWidget {
  const TravelList({super.key});

  @override
  State<TravelList> createState() => _TravelListState();
}

class _TravelListState extends State<TravelList> {
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
            
      ),

      home: Travel(),
    );
  }
}



class Travel extends StatefulWidget {
  const Travel({super.key});

  @override
  State<Travel> createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(title: Text("HOME PAGE"),centerTitle: true,),

      body: SafeArea(

        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("ADMIN PROFILE").snapshots(),

          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if(snapshot.hasData)
            {


              return ListView.builder(itemBuilder: (context,index){
                final DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
                print("documentsnapshot is $documentSnapshot");
                return GestureDetector(
                  onTap: (){
                    print("image url is ${documentSnapshot["images"]}");
                    var ans=documentSnapshot["images"];

                    showModalBottomSheet(context: context, builder: (BuildContext context){
                      return Container(

                        child: Column(
                          children: [
                            ListTile(title: Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text(documentSnapshot["company_name"],style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 20),)),subtitle: Text("\nCAB AGENCY \n\nOpens At 9.00 AM to 6.00 PM"),),




                          SizedBox(height: 10,),
                            Container(
                              alignment: Alignment.topLeft,
                              child: RichText(text: TextSpan(
                                  text: " PHONE NUMBER :",
                                  style: GoogleFonts.aBeeZee(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: "${documentSnapshot["phone_number"]}",
                                      style: GoogleFonts.aBeeZee(
                                        color: Colors.red,

                                      ),recognizer: TapGestureRecognizer()
                                        ..onTap=(){
                                          print("Clicked");

                                          callnumber(documentSnapshot["phone_number"]);

                                        }
                                    )
                                  ]
                              )),
                            ),











                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(FontAwesomeIcons.noteSticky),
                                ),
                                SizedBox(width: 15,),
                                Expanded(child: Padding(

                                    padding: EdgeInsets.all(10),
                                    child: Text("${documentSnapshot["description"]}" ,style: GoogleFonts.aBeeZee(fontSize: 17),)))
                              ],
                            ), SizedBox(height: 10,),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(FontAwesomeIcons.locationPin),
                                ),
                                SizedBox(width: 15,),
                                Expanded(child: Padding(

                                    padding: EdgeInsets.all(10),
                                    child: Text("${documentSnapshot["address"]}" ,style: GoogleFonts.aBeeZee(fontSize: 17),)))
                              ],
                            ),




                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context,index){

                                  print("ans ${ans[index]}");
                                  return Container(
                                      width: 200,height: 200,
                                      padding: EdgeInsets.all(10),

                                    child: GestureDetector(
                                        onTap: (){
                                          print("Clicked");
                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>ShowImage(url: ans[index])));


                                        },

                                        child: Image.network(ans[index])),
                                  );

                                },itemCount: ans.length,scrollDirection: Axis.horizontal,),
                            ),

                            SizedBox(height: 30,),


                            Container(

                                child: ElevatedButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));


                                }, child: Text("VIEW CAB"),style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(

                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)
                                    )
                                  )


                                ),),),
                            SizedBox(height: 20,)

                          ],
                        ),
                      );
                    });
                  },

                  child: Card(
                    child: Container(
                      child: Row(
                        children: [
                          Image.network(documentSnapshot["images"][0],width: 130,height: 130),
                          SizedBox(width: 10,),
                          Expanded(child: ListTile(

                            title: Text(documentSnapshot["company_name"],style: GoogleFonts.aBeeZee(fontSize: 20,fontWeight: FontWeight.bold),),
                            subtitle: Text("\nContact : ${documentSnapshot["phone_number"]}",style: GoogleFonts.aBeeZee(color: Colors.red),),

                          ))

                        ],
                      ),
                    ),
                  ),
                );

              },itemCount: snapshot.data!.docs.length,);
            }
            return CircularProgressIndicator();
          },

        ),
      ),

    );
  }

  callnumber(String phone) async{
    await FlutterPhoneDirectCaller.callNumber(phone);
  }

}


class ShowImage extends StatelessWidget {

  late final String url;
  ShowImage({Key? key,required this.url}):super(key: key);

  @override
  Widget build(BuildContext context) {
    print(url);
    return Image.network(url);
  }
}

