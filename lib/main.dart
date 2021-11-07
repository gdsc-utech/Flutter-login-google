import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

/*
Initializing Firebase
normally main looks like the following
void main() => runApp(MyApp());
 */
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

/*
In Flutter generally you have 2 types of states
Stateless and Stateful to keep things simple
Stateless is used when you do not want to save data from the user
while Stateful is the opposite
 */
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

/*
This is a basic example of how a basic Stateless page would be made
a Scaffold is returned because that is a library that returns a basic
page layout if you were to return lets say a Container you would only see
a black screen while in this case a raw Scaffold would return a white page
with a appbar.
 */
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign up", style: TextStyle(
          fontSize: 25,
        ),),
        // bottom: PreferredSize(
        //     child: Text( _user == null ? "No User" : _user!.then((value)
        //     => value!.email).toString(),
        //     style: TextStyle(color: Colors.white, fontSize: 15)),
        //     preferredSize: Size(3.0, 3.0)),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.ice_skating),
        //     onPressed: (){
        //       FirebaseRequest().logout();
        //     },
        //   )
        // ],
      ),
      body: Align(
        child: SizedBox(
          width: 200,
        height: 50,
        child:TextButton(
          onPressed: (){
            /*
            This function will be called once the button is pressed
            once pressed and executed the results of the signInWithGoogle
             */
            FirebaseRequest().signInWithGoogle().
            then((result){
              if(result != null) {
                /*
                as it is shown as long as the result is not null
                the login page will be called
                 */
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoggedInPage()));
              }
            });
          },
          child: Text("Sgin up with google",
            style: TextStyle(color: Colors.white),),
          style: TextButton.styleFrom(
            backgroundColor: Colors.redAccent
          ),
        ),
    )
      ),
    );
  }
}


class LoggedInPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Welcome"),
        bottom: PreferredSize(
          child: Text(FirebaseRequest().auth.currentUser!.email.toString(),
          style: TextStyle(color: Colors.white),),
          preferredSize: Size(2.0, 2.0),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              FirebaseRequest().logout();
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}


/*
class that handles the firebase functions
as you can see most things are done already by firebase
so all we would need to do is simply call the functions
 */
class FirebaseRequest{
//SIGN WITH GOOGLE
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuth get auth => _auth;

  /*
  the code below return the current user signed in
   */
  Future<User?> signInWithGoogle() async {
    try{
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      return _auth.currentUser;
    }on FirebaseAuthException catch (e){
      throw e;
    }
  }


  Future <void> logout() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

}



