import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUser(String userId, Map<String, dynamic>  userInfoMap){
    return FirebaseFirestore.instance.collection("User").doc(userId).set(userInfoMap);
  }
}

Future<Stream<QuerySnapshot>> getProfile () async {
  return await FirebaseFirestore.instance.collection("User").snapshots();
}