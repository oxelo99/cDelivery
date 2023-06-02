import 'package:flutter/material.dart';
import 'theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPwPage extends StatefulWidget {
  const ForgotPwPage({Key? key}) : super(key: key);

  @override
  State<ForgotPwPage> createState() => _ForgotPwPageState();
}

class _ForgotPwPageState extends State<ForgotPwPage> {
  final _emailcontroller = TextEditingController();
  String _errorMessage = '';

  Future resetPW() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailcontroller.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                  'Un link de resetare a parolei a fost trimis. Verifica inboxul!'),
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'Utilizator negasit!';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          _errorMessage = 'Adresa de mail este invalida!';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Resetare Parola'),
        ), //,

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Introdu adresa de email, si iti vom trimite un link de resetare a parolei',
                style: TextStyle(
                  color: MyTheme.textColor(context),
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              //se creaza o margine interioara astfel incat field-ul sa dea impresia
              padding: const EdgeInsets.all(15.0),
              //unei margini si sa nu ocupe toata latimea coloanei(ecranului)
              child: TextField(
                controller: _emailcontroller,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                style: TextStyle(color: MyTheme.textColor(context)),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              //furnizeaza utilizatorului posibilele erori pe care le
              _errorMessage, //putea produce la completarea informatiilor
              style: TextStyle(color: MyTheme.textColor(context)),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: resetPW,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    color: MyTheme.buttonColor(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                      child: Text(
                        'Resetare Parola',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
