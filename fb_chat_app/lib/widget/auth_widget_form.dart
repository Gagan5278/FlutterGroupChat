import 'package:flutter/material.dart';
import '../widget/image_picker.dart';
import 'dart:io';

class AuthFormWidget extends StatefulWidget {
  final void Function(String email, String userName, String password,
      File image, bool isLogin, BuildContext cntx) ft;
  final bool isOperationInProgress;
  AuthFormWidget(this.ft, this.isOperationInProgress);
  @override
  _AuthFormWidgetState createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String _emaildString;
  String _userNameString;
  String _passwordString;
  File _userImage;
  var _isLoginMode = true;

  void _selectImage(File image) {
    _userImage = image;
  }

  @override
  Widget build(BuildContext context) {
    void _saveForm() {
      if (_formKey.currentState.validate() == null) {
        return;
      }
      if (!_isLoginMode && _userImage == null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please select user image'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();

      widget.ft(_emaildString, _userNameString, _passwordString, _userImage,
          _isLoginMode, context);
    }

    return Center(
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (!_isLoginMode) UserImagePicker(_selectImage),
                  TextFormField(
                    key: ValueKey('email'),
                    decoration: InputDecoration(labelText: 'Enter mail id'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter valid emaild';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _emaildString = val;
                    },
                  ),
                  if (!_isLoginMode)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: 'Enter user name'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter valid username';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _userNameString = val;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: 'Enter password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Please enter valid password';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _passwordString = val;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isOperationInProgress)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!widget.isOperationInProgress)
                    RaisedButton(
                        onPressed: () {
                          _saveForm();
                        },
                        child: Text(_isLoginMode
                            ? 'Login'
                            : 'Sign up for a new account')),
                  if (!widget.isOperationInProgress)
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLoginMode = !_isLoginMode;
                          });
                        },
                        child: Text(
                          _isLoginMode
                              ? 'Create an account'
                              : 'I already have an account',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                ],
              )),
        ),
      ),
    );
  }
}
