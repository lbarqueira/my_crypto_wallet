import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Email/Password Registration & Sign-in

class Auth {
// Registration
  Future<bool> register({String email, String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

// Sign-in
  Future<bool> signIn({String email, String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

class FirestoreService {
  Future<bool> addCoin({String documentId, String amount}) async {
    // Transactions are a way to ensure that a write operation
    // only occurs using the latest data available on the server.
    try {
      String uid = FirebaseAuth.instance.currentUser.uid;
      var value = double.parse(amount); // covert String to a double
      // Create a reference to the document the transaction will use
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Coins')
          .doc(documentId);

      FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);
          if (!snapshot.exists) {
            documentReference.set({'Amount': value});
            return true;
          }
          double newAmount = snapshot.data()['Amount'] + value;
          // Perform an update on the document
          transaction.update(documentReference, {'Amount': newAmount});
          return true;
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeCoin(String id) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Coins')
        .doc(id)
        .delete();
    return true;
  }
}
