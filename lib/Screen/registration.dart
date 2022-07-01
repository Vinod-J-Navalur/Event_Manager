import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/homescreen.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formkey = GlobalKey<FormState>();

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
          return ("First Namecannot be empty");
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
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final addharid = TextFormField(
      autofocus: false,
      controller: addharidEditingcontroller,
      keyboardType: TextInputType.name,
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
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Addhar Name",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
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
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Addhar Name",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
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
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Second Name",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
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
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.mail,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
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
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
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
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromARGB(255, 123, 182, 230),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
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
        appBar: AppBar(
          title: Text("EVENTS"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 123, 182, 230),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => loginscreen()));
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
              child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 75,
                        backgroundImage: AssetImage("assets/h.jpg"),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      firstNamefield,
                      SizedBox(
                        height: 20,
                      ),
                      secondNamefield,
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
        ));
  }

  void signUp(String email, String password) async {
    try {
      if (_formkey.currentState!.validate()) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()});
      }
    } catch (e) {
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
    userModel.secondName = secondNameEditingcontroller.text;

    await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Registered Successfull");

    Navigator.pop(context);
  }
}
