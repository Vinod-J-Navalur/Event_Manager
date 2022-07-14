import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/homescreen.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/Screen/multihost.dart';
import 'package:event_organizer/model/UserModel.dart';
import 'package:event_organizer/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:event_organizer/Screen/hosted_event_detail.dart';
import '../constant/color.dart';
import '../constant/text_style.dart';
import '../host/Event.dart';
import '../model/datetime_utils.dart';
import '../model/ui_helper.dart';
import '../utils/app_utils.dart';
import 'event_detail_page.dart';

class hosted extends StatefulWidget {
  const hosted({Key? key}) : super(key: key);

  @override
  State<hosted> createState() => _hostedState();
}

class _hostedState extends State<hosted> with TickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController controller;
  late AnimationController opacityController;
  late Animation<double> opacity;

  @override
  final Stream<QuerySnapshot> party =
      FirebaseFirestore.instance.collection('party').snapshots();

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();

  int _currentIndex = 0;

  _onTap() async {
    if (_currentIndex == 4) {
      await _auth.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const loginscreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => _childern[_currentIndex]));
    }
  }

  final List<Widget> _childern = [
    const HomeScreen(),
    const user_profile(),
    const upload_Details(),
    const hosted()
  ];

  String? image;
  String? name;

  void initState() {
    scrollController = ScrollController();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
    opacityController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 1));
    opacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: opacityController,
    ));
    scrollController.addListener(() {
      opacityController.value = offsetToOpacity(
          currentOffset: scrollController.offset,
          maxOffset: scrollController.position.maxScrollExtent / 2);
    });

    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      name = loggedInUser.firstName;

      setState(() {});
      super.initState();
    });
  }

  void dispose() {
    controller.dispose();
    scrollController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Evnt> event1 = [];
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(bottom: 16),
        //padding: const EdgeInsets.all(12),
        //padding: const EdgeInsets.all(12),
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpeg"),
            fit: BoxFit.fitWidth,
          ),
        ),

        child: StreamBuilder<QuerySnapshot>(
            stream: party,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('waiting');
              }
              final data = snapshot.requireData;
              int a = data.size;
              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  image = data.docs[index]['image'];
                  if (user!.uid != data.docs[index]['uid']) {
                    Evnt eve1 = Evnt(
                        party_name: data.docs[index]['party_name'],
                        image: data.docs[index]['image'],
                        location: data.docs[index]['location'],
                        discription: data.docs[index]['discription'],
                        date: data.docs[index]['date'],
                        time: data.docs[index]['time'],
                        price: 0);
                    event1.add(eve1);
                    return Container();
                  }
                  var animation = Tween<double>(begin: 800.0, end: 0.0).animate(
                    CurvedAnimation(
                      parent: controller,
                      curve: Interval((1 / data.docs.length) * index, 1.0,
                          curve: Curves.decelerate),
                    ),
                  );

                  if (user!.uid == data.docs[index]['uid']) {
                    Evnt eve2 = Evnt(
                        party_name: data.docs[index]['party_name'],
                        image: data.docs[index]['image'],
                        location: data.docs[index]['location'],
                        discription: data.docs[index]['discription'],
                        date: data.docs[index]['date'],
                        time: data.docs[index]['time'],
                        price: 0);
                    event1.add(eve2);
                  }

                  return InkWell(
                      child: Card(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                color: imgBG,
                                width: 80,
                                height: 100,
                                child: Image.network(
                                  image.toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            UIHelper.horizontalSpace(8),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UIHelper.verticalSpace(8),
                                  Text(
                                      DateTimeUtils.getFullDate(
                                          DateTime.parse("2001-06-28")),
                                      style: monthStyle),
                                  UIHelper.verticalSpace(8),
                                  Text("${data.docs[index]['party_name']}",
                                      style: titleStyle),
                                  UIHelper.verticalSpace(8),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on,
                                          size: 16,
                                          color:
                                              Theme.of(context).primaryColor),
                                      UIHelper.horizontalSpace(4),
                                      Text(
                                          "${data.docs[index]['location']}"
                                              .toString()
                                              .toUpperCase(),
                                          style: subtitleStyle),
                                    ],
                                  ),
                                ]),
                          ])),
                      onTap: () {
                        print(index);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HostedEventDetailPage(event1[index])));
                      });
                },
              );
            }),
      ),
      bottomNavigationBar: SizedBox(
        height: 65.0,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: "Home",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: "Profile",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline_rounded,
                    color: Colors.deepPurple),
                label: "Add Event",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt, color: Colors.black),
                label: "Lists",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout, color: Colors.black),
                label: "Logout",
                backgroundColor: Colors.black),
          ],
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _onTap();
          },
        ),
      ),
    );
  }
}
