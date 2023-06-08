import 'package:c_delivery/memo_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'colina_app.dart';
import 'login_page.dart';
import 'Classes/user_class.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  Future<MyUser> _getUserData(String uid) async {
    await Firebase.initializeApp();
    MyUser currentUser = MyUser.uid(uid: uid);
    await currentUser.getUserData();
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return FutureBuilder<MyUser>(
            future: _getUserData(snapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (userSnapshot.hasData) {
                if(userSnapshot.data!.complex=='Colina') {
                  return Colina(
                  currentUser: userSnapshot.data!,
                );
                }else{
                  return Memo(currentUser: userSnapshot.data!);
                }
              } else {
                return const MaterialApp(
                  home: AlertDialog(
                    content: Text(
                        'Eroare la incarcarea datelor utilizatorului'),

                  ),
                );
              }
            },
          );
        } else {
          return const MyLogin();
        }
      },
    );
  }
}
