import 'package:c_delivery/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'theme_data.dart';
import 'forgot_pw_page.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  String _errorMessage = '';

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'Utilizator negasit!';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Parola incorecta!';
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            //Coloana principala care este un vector de widgeturi si contine tot ecranul
            children: [
              const SizedBox(
                //formeaza un mic spatiu pe orizontala intre widgeturi
                height: 50,
              ),
              Image.asset('UnitLogo.png'),
              const SizedBox(
                height: 25,
              ),
              Text('cDelivery',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 25,
                  )),
              const SizedBox(
                height: 5,
              ),
              Text('Bine ai revenit!',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 15,
                  )),
              Padding(
                //se creaza o margine interioara astfel incat field-ul sa dea impresia
                padding: const EdgeInsets.all(15.0),
                //unei margini si sa nu ocupe toata latimea coloanei(ecranului)
                child: TextField(
                  controller: _emailcontroller,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextField(
                  controller: _passwordcontroller,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Text(
                        'Parola uitata?',
                        style: TextStyle(
                          color: MyTheme.textColor(context),
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const ForgotPwPage();
                            }));
                      },
                    ),
                  ],
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
                  onTap: signIn,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      color: MyTheme.buttonColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ));
                },
                child: Text('Creaza un cont nou',
                    style: TextStyle(
                      color: MyTheme.textColor(context),
                      fontSize: 15,
                    )),
              ),
              const SizedBox(height: 30),
              //scrolleaza field-ul astfel incat sa treaca deasupra tastaturii.
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom))
            ],
          ),
        ),
      ),
    );
  }
}
