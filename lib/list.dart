import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/product.dart';

class ShopList extends StatefulWidget {
  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  List<Product> items = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    getdoc();
  }

  void getdoc() async {
    await firebaseFirestore
        .collection('shoppinglist')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                Product product = Product(doc["quantity"], doc["item_name"]);
                setState(() {
                  items.add(product);
                });
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: items.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Container(
                      padding: EdgeInsets.only(left: 25, top: 10, bottom: 10),
                      height: 50,
                      child: Row(children: [
                        Text(
                          items[index].itemName + " :",
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(items[index].quantity)
                      ]),
                    ),
                    Divider(
                      color: Colors.grey,
                    )
                  ]);
                })
            : Center(
                child: Text("Add items to your shopping list"),
              ),
      ),
    );
  }
}
