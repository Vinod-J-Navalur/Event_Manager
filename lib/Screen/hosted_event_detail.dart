import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/host/Event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_organizer/constant/color.dart';
import 'package:event_organizer/constant/text_style.dart';
import 'package:event_organizer/host/event_fetcher.dart';

import 'package:event_organizer/model/ui_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'login.dart';

class HostedEventDetailPage extends StatefulWidget {
  final Evnt event;
  HostedEventDetailPage(this.event, {Key? key}) : super(key: key);
  @override
  _HostedEventDetailPageState createState() => _HostedEventDetailPageState();
}

class _HostedEventDetailPageState extends State<HostedEventDetailPage>
    with TickerProviderStateMixin {
  User? user;

  static int ind = 0;
  bool isloggedin = false;

  List<String> parties = [];

  final _auth = FirebaseAuth.instance;

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

  late Evnt event;
  late AnimationController controller;
  late AnimationController bodyScrollAnimationController;
  late ScrollController scrollController;
  late Animation<double> scale;
  late Animation<double> appBarSlide;
  double headerImageSize = 0;
  bool isFavorite = false;

  final Stream<QuerySnapshot> user1 =
      FirebaseFirestore.instance.collection('user').snapshots();

  @override
  void initState() {
    this.checkAuthentification();
    this.getUser();
    event = widget.event;
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    bodyScrollAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >= headerImageSize / 2) {
          if (!bodyScrollAnimationController.isCompleted)
            bodyScrollAnimationController.forward();
        } else {
          if (bodyScrollAnimationController.isCompleted)
            bodyScrollAnimationController.reverse();
        }
      });

    appBarSlide = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: bodyScrollAnimationController,
    ));

    scale = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: controller,
    ));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    bodyScrollAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    headerImageSize = MediaQuery.of(context).size.height / 2.5;
    return ScaleTransition(
      scale: scale,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildHeaderImage(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildEventTitle(),
                          UIHelper.verticalSpace(16),
                          buildEventDate(),
                          UIHelper.verticalSpace(24),
                          buildAboutEvent(),
                          UIHelper.verticalSpace(24),
                          buildOrganizeInfo(),
                          UIHelper.verticalSpace(24),
                          //buildEventLocation(),
                          UIHelper.verticalSpace(124),
                          //...List.generate(10, (index) => ListTile(title: Text("Dummy content"))).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                child: buildPriceInfo(),
                alignment: Alignment.bottomCenter,
              ),
              AnimatedBuilder(
                animation: appBarSlide,
                builder: (context, snapshot) {
                  return Transform.translate(
                    offset: Offset(0.0, -1000 * (1 - appBarSlide.value)),
                    child: Material(
                      elevation: 2,
                      color: Theme.of(context).primaryColor,
                      child: buildHeaderButton(hasTitle: true),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderImage() {
    double maxHeight = MediaQuery.of(context).size.height;
    double minimumScale = 0.8;
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        controller.value += detail.primaryDelta! / maxHeight * 2;
      },
      onVerticalDragEnd: (detail) {
        if (scale.value > minimumScale) {
          controller.reverse();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: headerImageSize,
            child: Hero(
              tag: event.image.toString(),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(32)),
                child: Image.network(
                  event.image.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          buildHeaderButton(),
        ],
      ),
    );
  }

  Widget buildHeaderButton({bool hasTitle = false}) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              margin: const EdgeInsets.all(0),
              child: InkWell(
                onTap: () {
                  if (bodyScrollAnimationController.isCompleted)
                    bodyScrollAnimationController.reverse();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: hasTitle ? Colors.white : Colors.black,
                  ),
                ),
              ),
              color: hasTitle
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
            ),
            if (hasTitle)
              Text(event.party_name.toString(),
                  style: titleStyle.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildEventTitle() {
    return Text(
      event.party_name.toString(),
      style: headerStyle.copyWith(fontSize: 32),
    );
  }

  Widget buildEventDate() {
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("date"),
              Text("date"),
            ],
          ),
        ),
        UIHelper.horizontalSpace(12),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("date"),
            UIHelper.verticalSpace(4),
            const Text("10:00 - 12:00 PM", style: subtitleStyle),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const ShapeDecoration(
              shape: StadiumBorder(), color: primaryLight),
          child: Row(
            children: <Widget>[
              UIHelper.horizontalSpace(8),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAboutEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("About", style: headerStyle),
        UIHelper.verticalSpace(),
        Text(event.discription.toString(), style: subtitleStyle),
        UIHelper.verticalSpace(8),
      ],
    );
  }

  Widget buildOrganizeInfo() {
    return Row(
      children: <Widget>[
        CircleAvatar(child: Icon(Icons.person) //Text(event.uid.toString()),
            ),
        UIHelper.horizontalSpace(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(event.uid.toString(), style: titleStyle),
            UIHelper.verticalSpace(4),
            const Text("Organizer", style: subtitleStyle),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Price", style: subtitleStyle),
              UIHelper.verticalSpace(8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "\₹${event.price}",
                        style: titleStyle.copyWith(
                            color: Theme.of(context).primaryColor)),
                    const TextSpan(
                        text: "/per person",
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              showDialog(context: context, builder: (_) => guestinfo());
            },
            child: Text(
              "Guest List",
              style: titleStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Future uploadFile() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    print("reached");
    String? uid = user!.uid;

    await firebaseFirestore.collection("books").doc(uid).update({
      'party_name': FieldValue.arrayUnion([event.party_name.toString()])
    });
    ind = ind + 1;

    Fluttertoast.showToast(msg: "Event Booked Successfully");
  }

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const loginscreen()));
      }
    });
  }

  Widget guestinfo() {
    List<dynamic> guests = [];
    print("reached");
    return StreamBuilder<QuerySnapshot>(
        stream: user1,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('waiting');
          }
          final data = snapshot.requireData;
          int count = 0;
          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                // print(index.toInt());

                guests = data.docs[index]['party_name'];

                List<String> strs = guests.map((e) => e.toString()).toList();

                print(strs);

                if (strs.contains(event.party_name.toString())) {
                  return SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Card(child: Text('The Guest names: ')),
                          Card(
                            child: Text(
                              data.docs[index]['firstName'].toString(),
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Divider(
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Container();
              });
        });
  }
}
