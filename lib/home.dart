import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/sign_in.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  final databaseReference = Firestore.instance;

  var weightController = TextEditingController();

  Widget _listTile(String dt, String weight){
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Weight: $weight",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.brown
                ),
              ),
              SizedBox(height: 5,),
              Text("DateTime: $dt",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey
                ),

              ),
            ],
          ),
          Expanded(
            flex: 8,
            child: Container()
          ),
          Container(
            child: GestureDetector(
              child: Icon(Icons.delete_outline, color: Colors.red,),
              onTap: ()async{
                 await Firestore.instance.collection('Weights').document('$dt').delete();
                Fluttertoast.showToast(
                    msg: "Record Deleted: $weight",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.of(context).pop();

              },
            ),
          )

        ],
      )
    );

  }

  Widget _viewRecords(){
    return  DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 1.0,
      builder: (BuildContext context, myscrollController) {
        return Container(
          color: Colors.tealAccent[200],
          child: ListView.builder(
            controller: myscrollController,
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(
                    'Dish $index',
                    style: TextStyle(color: Colors.black54),
                  ));
            },
          ),
        );
      },
    );
  }
  Widget _inputWeight(){
    return TextField(
      controller: weightController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Weight:',
          hintStyle: TextStyle( fontSize: 15, color: Colors.grey),
          contentPadding: EdgeInsets.all(15),
          focusedBorder: new OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              )
          )
      ),
    );
  }

  Future createRecord(var weight, DateTime dateTime) async {
      await databaseReference.collection("Weights")
        .document(dateTime.toIso8601String())
        .setData({
          'weight': '$weight',
          'datetime' : dateTime.toIso8601String()
    }).then((value) {
        Fluttertoast.showToast(
            msg: "Record Added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }).catchError((error){
        Fluttertoast.showToast(
            msg: "$error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });
  }


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
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Create Record'),
                  onPressed: () {
                    setState(() {
                      weightController.text = "";
                    });
                    showModalBottomSheet<void>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,

                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(25, 5, 25, 195),
                          color: Colors.brown[100],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('Add Weight',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 2,
                                      color: Colors.brown
                                  ),
                                ),
                                SizedBox(height: 10,),
                                _inputWeight(),
                                SizedBox(height: 4,),
                                ElevatedButton(
                                    child: const Text('Add Weight'),
                                    onPressed: () async {
                                      await createRecord(weightController.text,DateTime.now());
                                      Navigator.of(context).pop();
                                    }
                                ),

                              ],

                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  child: Text('View Records'),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,

                      context: context,
                      builder: ( context) => DraggableScrollableSheet(
                        initialChildSize: 0.8,
                        minChildSize: 0.2,
                        maxChildSize: 0.9,
                        builder: (BuildContext context, myscrollController) {
                          return Container(
                            decoration: new BoxDecoration(
                              color: Colors.brown[200],
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0),
                              ),
                            ),
                            child:  StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection('Weights').snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError)
                                  return new Text('Error: ${snapshot.error}');
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return new Text('Loading...');
                                  default:
                                    return new ListView(
                                      physics: BouncingScrollPhysics(),
                                      children: snapshot.data!.documents.map((DocumentSnapshot document) {
                                        return _listTile(document['datetime'], document['weight']);
                                      }).toList(),
                                    );
                                }
                              },
                            )
                          );
                        },
                      )
                    );
                  },
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  child: Text('       Logout     '),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Fluttertoast.showToast(
                        msg: "Signed Out Succeddfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        SignInAnon()), (Route<dynamic> route) => false);
                  },
                ),
              ],
            )
          )
      ),
    );
  }
}
