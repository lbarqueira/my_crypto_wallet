import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/net/flutterfire.dart';
import 'package:my_crypto_wallet/ui/home_view.dart';
import 'package:email_validator/email_validator.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String _emailField = '';
  String _passwordField = '';
  final _formKey = GlobalKey<FormState>();

  Widget emailInput(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      child: TextFormField(
        validator: (email) =>
            EmailValidator.validate(email) ? null : "Invalid email address",
        onSaved: (email) => _emailField = email,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "something@email.com",
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          labelText: "Email",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget passwordInput(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      child: TextFormField(
        validator: (password) {
          Pattern pattern = '.{6,}'; // Minimum six in length
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(password))
            return 'Invalid password';
          else
            return null;
        },
        onSaved: (password) => _passwordField = password,
        style: TextStyle(color: Colors.white),
        obscureText: true,
        decoration: InputDecoration(
          hintText: "password",
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          labelText: "Password",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 128.0,
              width: 128.0,
              child: Image.asset('images/bitcoin.png'),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  emailInput(context),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  passwordInput(context),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          print(_emailField);
                          print(_passwordField);
                          bool shouldNavigate = await Auth().signIn(
                              email: _emailField, password: _passwordField);
                          if (shouldNavigate) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeView(),
                              ),
                            );
                          }
                        }
                      }, // TODO
                      child: Text("Login"),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          bool shouldNavigate = await Auth().register(
                              email: _emailField, password: _passwordField);
                          if (shouldNavigate) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeView(),
                              ),
                            );
                          }
                        }
                      }, // TODO
                      child: Text("Register"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
