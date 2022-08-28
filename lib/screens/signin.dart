// import 'package:firebase_auth/firebase_auth.dart';
import 'package:attende/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attende/screens/signup.dart';
import 'package:flutter/painting.dart';


class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
// showing snack bar for errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // email field
    final emailField = TextFormField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          prefixIconColor: Color.fromARGB(255, 207, 118, 112),
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          labelText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid Email");
        }
        return null;
      },
      onSaved: (value) => emailController.text = value!,
      textInputAction: TextInputAction.next,
    );

// password field
    final passwordField = TextFormField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline_sharp),
          prefixIconColor: Color.fromARGB(255, 224, 133, 127),
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          // hintText: "Enter your password",
          labelText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Password(Minimum 6 characters)");
        }
        return null;
      },
      onSaved: (value) => passwordController.text = value!,
      textInputAction: TextInputAction.done,
    );

    // login button

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: const Text(
          "Log In",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
      ),
    );
    final forgetPassword = GestureDetector(
      child: const Text(
        "Forget Password?",
        style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      ),
      onTap: () {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const ForgetPasswordPage()));
      },
    );
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 164, 246, 175),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 164, 246, 175),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image.asset(
                          "assets/images/a.png",
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Text('Attendance Application' ,style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.green
                      )),
                      const SizedBox(height: 20.0),
                      emailField,
                      const SizedBox(height: 20.0),
                      passwordField,
                      const SizedBox(height: 20.0),
                      loginButton,
                      const SizedBox(height: 20.0),
                      forgetPassword,
                      const SizedBox(height: 20.0),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          const SizedBox(width: 7.0),
                          GestureDetector(
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.green),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen()));
                            },
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  // login function

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Login Successfull"),
                  duration: Duration(seconds: 5),
                )),
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Home()),
                    ((route) => false)),
              })
          .catchError((e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error Message"),
                content: Text(e!.message),
                backgroundColor: Colors.deepPurple,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.exit_to_app))
                ],
              );
            });
      });
    }
  }
}
