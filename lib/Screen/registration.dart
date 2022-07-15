import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/homescreen.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formkey = GlobalKey<FormState>();

  bool loading = false;

  final _auth = FirebaseAuth.instance;
  final firstNameEditingcontroller = new TextEditingController();
  final secondNameEditingcontroller = new TextEditingController();
  final addharidEditingcontroller = new TextEditingController();
  final emailEditingcontroller = new TextEditingController();
  final passwordEditingcontroller = new TextEditingController();
  final confirmPasswordEditingcontroller = new TextEditingController();
  final mobilenoEditingcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firstNamefield = TextFormField(
      autofocus: false,
      controller: firstNameEditingcontroller,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');

        if (value!.isEmpty) {
          return ("First Name cannot be empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter name (Min 3 Char)");
        }
      },
      onSaved: (value) {
        firstNameEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.pinkAccent[00],
        //filled: true,
        labelText: "Name",
        prefixIcon: Icon(
          Icons.account_circle,
          color: Colors.deepPurple,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "First Name",
        hintStyle:
            TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final addharid = TextFormField(
      autofocus: false,
      controller: addharidEditingcontroller,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = RegExp(r'^.{10,}$');

        if (value!.isEmpty) {
          return ("First Namecannot be empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Please 10 Digit of addar");
        }
      },
      onSaved: (value) {
        firstNameEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.pinkAccent[00],
        //filled: true,
        labelText: 'AADHAR Number',
        prefixIcon: Icon(
          Icons.document_scanner,
          color: Colors.deepPurple,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Addhar No",
        hintStyle:
            TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final mobile = TextFormField(
      autofocus: false,
      controller: mobilenoEditingcontroller,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{10,}$');

        if (value!.isEmpty) {
          return ("First Namecannot be empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Please 10 Digit of mobile no");
        }
      },
      onSaved: (value) {
        firstNameEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.pinkAccent[00],
        //filled: true,
        labelText: 'Phone Number',
        prefixIcon: Icon(
          Icons.phone_android,
          color: Colors.deepPurple,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Mobile No",
        hintStyle:
            TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final secondNamefield = TextFormField(
      autofocus: false,
      controller: secondNameEditingcontroller,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Second Name cannot be empty");
        }
      },
      onSaved: (value) {
        secondNameEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.pinkAccent[00],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Colors.deepPurple,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Second Name",
        hintStyle:
            TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final emailfield = TextFormField(
      autofocus: false,
      controller: emailEditingcontroller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a Valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.pinkAccent[00],
        //filled: true,
        labelText: 'Email Id',
        prefixIcon: Icon(
          Icons.alternate_email,
          color: Colors.deepPurple,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Email",
        hintStyle:
            TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final passwordfield = TextFormField(
      autofocus: false,
      controller: passwordEditingcontroller,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Password(Min 6 Char)");
        }
      },
      onSaved: (value) {
        passwordEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        fillColor: Colors.pinkAccent[00],
        //filled: true,
        labelText: 'Password',
        prefixIcon: Icon(
          Icons.password,
          color: Colors.deepPurple,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Password",
        hintStyle:
            TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final confirmpasswordfield = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingcontroller,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingcontroller.text !=
            passwordEditingcontroller.text) {
          return "Password Don't Match";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        confirmPasswordEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        fillColor: Colors.pinkAccent[00],
        //filled: true,
        labelText: "Confirm Password",
        prefixIcon: Icon(
          Icons.password_outlined,
          color: Colors.deepPurple,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Confirm Password",
        hintStyle:
            TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.purpleAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          await Future.delayed(const Duration(seconds: 2), () {});
          signUp(emailEditingcontroller.text, passwordEditingcontroller.text);
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Center(
            child: SingleChildScrollView(
                child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: 'logo',
                          child: Image.asset(
                            'assets/party.png',
                            //width: 200,
                            height: 250,
                          ),
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        firstNamefield,
                        SizedBox(
                          height: 20,
                        ),
                        emailfield,
                        SizedBox(
                          height: 20,
                        ),
                        mobile,
                        SizedBox(
                          height: 20,
                        ),
                        addharid,
                        SizedBox(
                          height: 20,
                        ),
                        passwordfield,
                        SizedBox(
                          height: 20,
                        ),
                        confirmpasswordfield,
                        SizedBox(
                          height: 25,
                        ),
                        signupButton
                      ],
                    )),
              ),
            )),
          ),
        ));
  }

  void signUp(String email, String password) async {
    try {
      if (_formkey.currentState!.validate()) {
        setState(() {
          loading = true;
        });
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()});
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "Already present");
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.addhar = addharidEditingcontroller.text;
    userModel.mobileno = mobilenoEditingcontroller.text;
    userModel.firstName = firstNameEditingcontroller.text;
    userModel.secondName = "dummy";
    userModel.party_name = [''];

    await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Registered Successfully");
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
    });
  }
}
