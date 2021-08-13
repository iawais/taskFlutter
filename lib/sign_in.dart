import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/home.dart';
import 'package:project/services/auth.dart';


class SignInAnon extends StatefulWidget {

  @override
  _SignInAnonState createState() => _SignInAnonState();
}

class _SignInAnonState extends State<SignInAnon> {

  final AuthService auth  = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.1,
        title: Text("APP BAR"),
      ),
      body: Container(
        color: Colors.brown[100],
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: Center(
          child: RaisedButton(
            child: Text("Sign In Anonymously"),
            onPressed: ()async{
              FirebaseUser? res = await auth.signInAnon();
              if(res == null){
                print('error signing in');
              }
              else {
                print( "Signed In");
                Fluttertoast.showToast(
                    msg: "Signed In with UID: ${res.uid}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    HomePage()), (Route<dynamic> route) => false);
              }
            },
          ),
        )
      ),
    );
  }
}
