import 'package:c_delivery/theme_data.dart';
import 'package:c_delivery/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Memo extends StatelessWidget {
  final MyUser currentUser;
  const Memo({required this.currentUser,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      title: 'Memo Unitbv',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cantina Memo', style: TextStyle(color: MyTheme.textColor(context)),),
          actions: [
            IconButton(onPressed: (){FirebaseAuth.instance.signOut();}, icon: const Icon(Icons.logout_sharp))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Bine ai venit, ${currentUser.firstName}!', style: TextStyle(color: MyTheme.textColor(context), fontSize: 20,),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
