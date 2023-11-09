import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:chatapp/Screens/HomeScreen.dart';
import 'package:chatapp/api/api.dart';
import 'package:chatapp/helpers/dialogs.dart';
import 'package:chatapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      developer.log('SignInWithGoogle: $e');
    }
    dialogs.showSnackbar(context, 'Something went wrong check your Connection');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Me Chat'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              right: _isAnimate ? mq.width * .25 : -mq.width * -5,
              width: mq.width * .5,
              duration: Duration(seconds: 2),
              child: Image.asset('images/chat.png')),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .07,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), elevation: 1),
                  onPressed: () {
                    _signInWithGoogle().then((value) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    });
                  },
                  icon: Image.asset(
                    "images/google.png",
                    width: 40,
                  ),
                  label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        children: [
                          TextSpan(text: "Login With "),
                          TextSpan(
                              text: "Google",
                              style: TextStyle(fontWeight: FontWeight.w800)),
                        ]),
                  ))),
        ],
      ),
    );
  }
}
