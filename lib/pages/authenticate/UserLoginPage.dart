import 'package:flutter/material.dart';
import 'package:loginui/pages/UiComponentScripts/UiButton.dart';
import 'package:loginui/pages/UiComponentScripts/UiTextField.dart';
import 'package:loginui/services/auth.dart';
import 'package:loginui/services/local_storage_service.dart';
import 'package:loginui/shared/loading.dart';

class UserLoginPage extends StatefulWidget {
  final Function toggleView;

  const UserLoginPage({Key? key, required this.toggleView}) : super(key: key);

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  final passwordController = TextEditingController();
  final mailController = TextEditingController();

  void signUserIn() async {
    print("User is signing in...");
    AuthService.isSignUp = false;
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      dynamic result = await _auth.signInWithEmailAndPassword(email, password);

      if (result is String) {
        setState(() {
          error = result;
          loading = false;
        });
      } else if (result == null) {
        setState(() {
          error = 'Authentication error';
          loading = false;
        });
      }
    }
    print("Signing in is done...");
    LocalStorageService().setData();
  }

  void signUp() {
    widget.toggleView();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 28.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),

                    // Logo and App Name
                    _buildLogoAndAppName(),

                    const SizedBox(height: 25),

                    // Email and Password TextFields
                    _buildTextFields(),

                    const SizedBox(height: 25),

                    // Sign In Button
                    UiButton(
                      buttonName: "Sign in",
                      onTap: signUserIn,
                    ),

                    const SizedBox(height: 20),

                    // Divider and Sign Up Button
                    _buildDividerAndSignUp(),

                    UiButton(
                      buttonName: "Sign up",
                      onTap: signUp,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Text(error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0)),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildLogoAndAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Icon(
          Icons.monitor_heart_sharp,
          color: Colors.green,
          size: 80,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          'Quit Smoking',
          style: TextStyle(
            fontFamily: 'Pacifico',
            color: Colors.green,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        UiTextField(
          controller: mailController,
          hintText: 'Email',
          obscureText: false,
          validator: (val) => val!.isEmpty
              ? 'Email is required'
              : null, // use to check if valid input
          onChanged: (val) {
            setState(() => email = val);
          },
        ),
        const SizedBox(height: 10),
        UiTextField(
          controller: passwordController,
          hintText: 'Password',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDividerAndSignUp() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.green,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'If you are new, join us with your email',
              style: TextStyle(color: Colors.green),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
