import 'package:agencyconnect/homepage.dart';
import 'package:agencyconnect/register.dart';
import 'package:agencyconnect/travelagencies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


Future<void> main() async
{
    await WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    runApp(App());
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser!=null)?(TravelList()):MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.deepOrange,
        primarySwatch: Colors.red
      ),

      home: LoginPage(),

    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  

  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  late ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            child: Container(
              margin: EdgeInsets.all(20),


              alignment: Alignment.center,
              child: Column(
                children: [
                Container(

                  margin: EdgeInsets.only(top: 20),
                  child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("assets/imagesdownload.png"),

                ),),

                  SizedBox(height: 60,),
                  Container(
                    width: double.infinity,

                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)
                        )
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text("LOGIN",style: GoogleFonts.aBeeZee(fontSize: 30,fontWeight: FontWeight.bold),)
                            ,SizedBox(height: 50,),

                            Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "EMAIL ID",
                                  hintText: "ENTER YOUR EMAIL ID"

                                ),

                              ),
                            ),



                            SizedBox(height: 50,),

                            Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: TextFormField(
                                controller: password,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "PASSWORD",
                                    hintText: "ENTER YOUR PASSWORD"


                                ),

                              ),
                            ),



                            SizedBox(height: 50,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20)
                                )
                              ),
                              child: ElevatedButton(onPressed: (){

                                print("clicked");
                                progressDialog=ProgressDialog(context,type: ProgressDialogType.normal);
                                progressDialog.style(
                                  message: "PLEASE WAIT WHILE WE PROCESS OUR DETAILS"
                                );
                                progressDialog.show();
                                login(email.text, password.text);



                              }, child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("SUBMIT")),
                              style: ElevatedButton.styleFrom(

                                  shape: RoundedRectangleBorder(

                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)
                                    )
                                  ),backgroundColor: Colors.red


                              ),
                              ),
                            ),
                            SizedBox(height: 20,),

                            RichText(text: TextSpan(text: "DON'T HAVE AN ACCOUNT ? ",style: GoogleFonts.aBeeZee(
                              color: Colors.black
                            ),children: [

                              TextSpan(text:"SIGN UP",style: GoogleFonts.aBeeZee(
                                color: Colors.red
                              ),recognizer: TapGestureRecognizer()..onTap=(){
                                print("Clicked");

                                Navigator.push(context, MaterialPageRoute(builder:(context)=>Register()));


                              }

                              ),


                            ]),


                            ),
                            SizedBox(height: 40,)






                          ],
                        ),
                      ),
                    ),
                  )



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Future<void> login(String email,String password) async
  {
    try{
      User user= (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null)
        {
          print("User Details Created Login successfully ");
          progressDialog.hide();


          Navigator.push(context, MaterialPageRoute(builder: (context)=>TravelList()));

        }
    }
    on FirebaseAuthException catch(e)
    {
      print(e);
    }
  }












}
