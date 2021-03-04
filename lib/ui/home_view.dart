import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/net/api_methods.dart';
import 'package:my_crypto_wallet/net/flutterfire.dart';
import 'package:my_crypto_wallet/ui/add_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double _bitcoin = 0.0;
  double _ethereum = 0.0;
  double _tether = 0.0;

  @override
  void initState() {
    super.initState();
    updateValues();
  }

  updateValues() async {
    _bitcoin = await getPrice('bitcoin');
    print('price for bitcoin:$_bitcoin');
    _ethereum = await getPrice('ethereum');
    _tether = await getPrice('tether');
    setState(() {});
  }

  getValue(String id, double amount) {
    if (id == "bitcoin") {
      return (_bitcoin * amount).toStringAsFixed(2);
    } else if (id == "ethereum") {
      return (_ethereum * amount).toStringAsFixed(2);
    } else {
      return (_tether * amount).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('My Crypto Portfolio'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('Coins')
                .snapshots(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Scrollbar(
                child: ListView(
                  children: snapshot.data.docs.map((document) {
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blue[900],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "Coin: ${document.id}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                              "Price: ${getValue(document.id, document.data()['Amount'])}EUR",
                              style: TextStyle(color: Colors.white)),
                          IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await FirestoreService().removeCoin(document.id);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

// TODO:
// incorporate more advance business logic state management
// work on styling
