import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String uid = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String emailAddress = '';
  String complex = '';

  MyUser({required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.emailAddress,
  });

  MyUser.uid({required this.uid});

  MyUser.late();

  factory MyUser.fromMap(Map<String, dynamic> user) {
    return MyUser(
        uid: user['uid'],
        firstName: user['First Name'],
        lastName: user['Last Name'],
        phoneNumber: user['Phone Number'],
        emailAddress: user['Email Address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'First Name': firstName,
      'Last Name': lastName,
      'Phone Number': phoneNumber,
      'Email Address':emailAddress,
    };
  }

  void fromMap(Map<String, dynamic> user) {
    uid = user['uid'];
    firstName = user['First Name'];
    lastName = user['Last Name'];
    phoneNumber = user['Phone Number'];
  }

  Future<void> getUserData() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('employees')
        .where('Uid', isEqualTo: uid)
        .get();
    final userData = userSnapshot.docs.first.data();
    lastName = userData['Nume'];
    firstName = userData['Prenume'];
    emailAddress = userData['Email'];
    phoneNumber = userData['Phone'];
    complex = userData['Complex'];
  }
}
