import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attende/models/user_model.dart';
import 'package:attende/screens/signin.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  // form key
  final _formKey = GlobalKey<FormState>();

// editing controller
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // first name field
    final firstNameField = TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]*")),
        FilteringTextInputFormatter.deny(RegExp(r"^[0-9]"))
      ],
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person_rounded),
          prefixIconColor: Colors.greenAccent,
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          labelText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid First Name(Minimum 3 characters)");
        }
        return null;
      },
      onSaved: (value) => firstNameEditingController.text = value!,
      textInputAction: TextInputAction.next,
    );

// second name field
    final secondNameField = TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]*")),
        FilteringTextInputFormatter.deny(RegExp(r"^[0-9]"))
      ],
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person_rounded),
          prefixIconColor: Colors.red,
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          // hintText: "Enter your email address",
          labelText: "Second Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Second Name cannot be empty");
        }

        return null;
      },
      onSaved: (value) => secondNameEditingController.text = value!,
      textInputAction: TextInputAction.next,
    );

    // email field
    final emailField = TextFormField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          prefixIconColor: Colors.red,
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          // hintText: "Enter your email address",
          labelText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      autofocus: false,
      controller: emailEditingController,
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
      onSaved: (value) => emailEditingController.text = value!,
      textInputAction: TextInputAction.next,
    );

    // password field
    final passwordField = TextFormField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          prefixIconColor: Colors.red,
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          // hintText: "Enter your email address",
          labelText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      autofocus: false,
      obscureText: true,
      controller: passwordEditingController,
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
      onSaved: (value) => passwordEditingController.text = value!,
      textInputAction: TextInputAction.next,
    );

    // confirm password field
    final confirmPasswordField = TextFormField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          prefixIconColor: Colors.red,
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          // hintText: "Enter your email address",
          labelText: "Confirm Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "Password do not match";
        } else {
          return null;
        }
      },
      onSaved: (value) => confirmPasswordEditingController.text = value!,
      textInputAction: TextInputAction.done,
    );

    // sign up button

    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 164, 246, 175),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
                      firstNameField,
                      const SizedBox(height: 20.0),
                      secondNameField,
                      const SizedBox(height: 20.0),
                      emailField,
                      const SizedBox(height: 20.0),
                      passwordField,
                      const SizedBox(height: 20.0),
                      confirmPasswordField,
                      const SizedBox(height: 20.0),
                      signupButton,
                      const SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          const SizedBox(width: 5.0),
                          GestureDetector(
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.purple),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SigninScreen()));
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

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          // Navigator.of(context)
          //     .pushAndRemoveUntil(
          //         MaterialPageRoute(builder: (context) => SigninScreen()),
          //         ((route) => false))
          .catchError((e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error Message"),
                content: Text(e!.message),
                backgroundColor: Color.fromARGB(255, 242, 132, 124),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close))
                ],
              );
            });
        // Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // calling our user model
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;
    // sending rthese values
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success Message"),
            content: const Text("Account created successfully"),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ImageUpload(
                    //               userId: userModel.uid,
                    //             )));
                  },
                  icon: const Icon(Icons.exit_to_app))
            ],
          );
        });
    // Fluttertoast.showToast(msg: "Account created successfully");

    // Navigator.pushAndRemoveUntil(
    //     (context),
    //     MaterialPageRoute(builder: (context) => const BottomNavScreen()),
    //     (route) => false);
  }
}
