import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop/list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = '1';
  TextEditingController itemNameController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference shoppinglist = firebaseFirestore.collection('shoppinglist');
    
Future<void> addUser(String value,String name){
      // Call the user's CollectionReference to add a new user
      return shoppinglist
          .add({
            'item_name': name,
            'quantity': value, 
          })
          .catchError((error) => print("Failed to add doc: $error"));
    }
    return Scaffold(
      body: Container(
          child: Column(children: [
        SizedBox(
          height: 100,
        ),
        Row(children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            width: 100,
            child: TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "item Name",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 18,
            style: TextStyle(color: Colors.deepPurple),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(width: 20),
          RaisedButton(
            color: Colors.black,
            onPressed: () {
              String name = itemNameController.text.trim();
              addUser(dropdownValue, name);
            },
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
          )
        ]),
        SizedBox(
          height: 40,
        ),
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShopList(),
              ));
            },
            child: Center(
              child: Text(
                "Retrieve",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ), 
            ))
      ])),
    );
  }
}
