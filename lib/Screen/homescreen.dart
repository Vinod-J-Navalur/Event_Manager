import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/Screen/multihost.dart';
import 'package:event_organizer/Screen/posts.dart';
import 'package:event_organizer/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Posts> postsList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final postsRef = FirebaseDatabase.instance.ref().child("User");
  late DatabaseReference databaseReference;
  FirebaseStorage storage = FirebaseStorage.instance;
  User? user;
  bool isloggedin = false;
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  int _currentIndex = 0;

  _onTap() async {
    if (_currentIndex == 4) {
      await _auth.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const loginscreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              _children[_currentIndex])); // this has changed
    }
  }

  //Widget List for Switching Between Different Pages
  final List<Widget> _children = [
    const HomeScreen(),
    const user_profile(),
    const upload_Details(),
  ];

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const loginscreen()));
      }
    });
  }

  //To get Current User Details
  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  //For My reference to check the values retrived from DB
  // void printFirebase() {
  //   postsRef.once().then((snapshot) {
  //     print(snapshot.snapshot.value);
  //   });
  // }

  //Redirects to the page of user posted items
  void userItems() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return loginscreen();
    }));
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();

    final postRef = FirebaseDatabase.instance.ref().child("user");

    postsRef.once().then((snapshot) {
      //TO get all Document ids of all the items in the collection
      dynamic keys = snapshot.snapshot.value;
      dynamic KEYS = keys.keys;

      //To fetch all the data from the Firebase Realtime DB
      dynamic DATA = snapshot.snapshot.value;

      postsList.clear();
      //print("Before");

      //Stores the fetched Data from the Snapshot using Keys into the list referencing the Usermodel Post.dart
      for (dynamic individualKey in KEYS) {
        //print("inside");
        Posts posts = Posts(
            DATA[individualKey]['date'],
            DATA[individualKey]['discription'],
            DATA[individualKey]['image'],
            DATA[individualKey]['location'],
            DATA[individualKey]['party_name'],
            DATA[individualKey]['time'],
            DATA[individualKey]['uid']);

        postsList.add(posts);
      }
      //print("After");

      setState(() {
        print('Length : ${postsList.length}');
        print("Set State");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: GridView.count(
        primary: true,
        crossAxisCount: 2,
        childAspectRatio: 0.80,
        children: List.generate(postsList.length, (index) {
          return PostUI(
              index,
              postsList[index].date,
              postsList[index].discription,
              postsList[index].image,
              postsList[index].location,
              postsList[index].party_name,
              postsList[index].time,
              postsList[index].uid);
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_outlined),
              label: "Add Event"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Lists"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _onTap();
        },
      ),
    );
  }

  Widget PostUI(int index, String date, String discription, String image,
      String location, String party_name, String time, String uid) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => loginscreen(),
              settings: RouteSettings(
                arguments: postsList[index],
              ),
            ),
          );
        },
        child: Card(
          elevation: 10.0,
          margin: EdgeInsets.all(10.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        party_name,
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                    height: 130.0,
                    width: 120.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ]),
          ),
        ));
  }
}
