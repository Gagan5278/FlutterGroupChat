import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widget/auth_widget_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isOperationInProgress = false;
  UserCredential _authResult;
  void _authOrSignup(String email, String userName, String password, File image,
      bool isLogin, BuildContext cntx) async {
    setState(() {
      _isOperationInProgress = true;
    });
    try {
      if (isLogin) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        //1.
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //2.
        final refPath = FirebaseStorage.instance
            .ref()
            .child('ProfileImage')
            .child(_authResult.user.uid + '.jpg');
        await refPath.putFile(image).onComplete;
        //3.
        final imgUrl = await refPath.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(_authResult.user.uid)
            .set({'user_name': userName, 'image_url': imgUrl});
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isOperationInProgress = false;
      });
      String message = "Something went wrong while logging into the app.";
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(cntx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(cntx).accentColor.withAlpha(100),
      ));
    } catch (error) {
      setState(() {
        _isOperationInProgress = false;
      });
      Scaffold.of(cntx).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Theme.of(cntx).accentColor.withAlpha(100),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthFormWidget(_authOrSignup, _isOperationInProgress),
    );
  }
}
