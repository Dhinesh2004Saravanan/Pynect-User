import 'package:agencyconnect/main.dart';
import 'package:agencyconnect/travelagencies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'homepage.dart';


class Register extends StatefulWidget {
   Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name=TextEditingController();

  TextEditingController phone=TextEditingController();

  TextEditingController mail=TextEditingController();

  TextEditingController password=TextEditingController();

  bool visible=true;
 late ProgressDialog dialog;
var messaging;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  requestNotificationPermission() async{

      messaging=await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        sound: true
      );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.only(top: 90),
                  alignment: Alignment.center,


                  child:  CircleAvatar(backgroundImage: AssetImage(
                    "assets/imagesdownload.png",),radius: 80,),
                ),



               SizedBox(height: 30,),
               Container(
                 margin: EdgeInsets.only(left: 20,right: 20),
                 child: Card(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20)
                   ),
                   child: Container(
                     padding: EdgeInsets.only(right: 20,left: 20,bottom: 20),
                     width: double.infinity,
                     child: Column(
                       children: [
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text("REGISTER",style: GoogleFonts.aBeeZee(fontSize: 30),)),
                         SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: name,
                            decoration: InputDecoration(


                              border: OutlineInputBorder(),
                              hintText: "ENTER YOUR NAME",
                              labelText: "NAME"
                              ,prefixIcon: Icon(Icons.supervised_user_circle_outlined)
                            ),

                          ),
                        ),
                         SizedBox(height: 30,),

                         Container(

                           child: TextFormField(
                            controller: phone,
                             decoration: InputDecoration(
                                 border: OutlineInputBorder(),
                                 hintText: "ENTER YOUR PHONE NUMBER",
                                 labelText: "PHONE",
                               prefixIcon: Icon(Icons.phone_android_outlined)

                             ),

                           ),
                         ),
                         SizedBox(height: 30,),Container(
                           child: TextFormField(
                             controller: mail,
                             decoration: InputDecoration(

                                 border: OutlineInputBorder(),
                                 hintText: "ENTER YOUR EMAIL ID",
                                 labelText: "E-MAIL",
                               prefixIcon: Icon(Icons.mail_lock)

                             ),

                           ),
                         ),
                         SizedBox(height: 30,),

                         Container(
                           child: TextFormField(

                             obscureText: visible,
                             obscuringCharacter: '*',
                             controller: password,
                             decoration: InputDecoration(
                                 border: OutlineInputBorder(),
                                 hintText: "ENTER YOUR PASSWORD",
                                 labelText: "PASSWORD",
                               prefixIcon: Icon(Icons.password),
                               suffixIcon:IconButton(onPressed: (){


                                 setState(() {

                                   if(visible)
                                     {
                                       visible=false;
                                     }
                                   else
                                     {
                                       visible=true;
                                     }


                                 });

                               },icon: Icon(Icons.remove_red_eye),)

                             ),

                           ),
                         ),
                         SizedBox(height: 20,),
                         ElevatedButton(onPressed: (){
                           print("Clicked re");
                           dialog=ProgressDialog(context,type: ProgressDialogType.normal);
                           dialog.style(

                             message: "PLEASE WAIT WHILE WE PROCESS..",


                           );

                           dialog.show();
                           print("Hi");
                           register(mail.text,password.text);


                         }, child: Text("SUBMIT"))



                       ],
                     ),
                   ),
                 ),
               ),














               //
               // Container(
               //
               //   margin: EdgeInsets.only(top: 130,left: 40),
               //
               //   child:  Text("REGISTER",style: GoogleFonts.aBeeZee(
               //       fontSize: 30,
               //       fontWeight: FontWeight.bold,
               //       color: Colors.white
               //   ),),
               // ),
               //
               //
               //  SizedBox(height: 50,),
               //  Card(
               //    child:Container(
               //      child: Column(
               //        children: [
               //
               //
               //
               //        ],
               //      ),
               //    ),
               //  )

              ],
            ),
          ),
        ),
      ),

    );
  }

  Future<void> register(String email,String password) async
  {
    print("function called for register");

    try
    {
      User user=(await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user!;


      if(user!=null)
        {
          print("USER OBJECT FOR REGISTER CREATED SUCCESSFULLY");


          await FirebaseFirestore.instance.collection("USER DETAILS").doc(user.uid).set(
            {
              "name":name.text,
              "email":email,
              "userid":user.uid
            }


          ).then((value) {

            dialog.hide();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TravelList()));

          });
        }


    }
    on FirebaseAuthException catch(e)
    {
      print(e);
    }


  }


}
