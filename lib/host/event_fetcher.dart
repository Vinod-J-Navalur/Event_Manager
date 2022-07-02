import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/hoted_events.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/Screen/multihost.dart';
import 'package:event_organizer/model/usermodel.dart';
import 'package:event_organizer/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_organizer/model/ui_helper.dart';
import 'package:event_organizer/model/datetime_utils.dart';
import 'package:event_organizer/constant/text_style.dart';
import 'package:event_organizer/Screen/event_detail_page.dart';

import '../host/Event.dart';

class Event_Fetcher extends StatefulWidget {
  @override
  State<Event_Fetcher> createState() => _Event_FetcherState();
}

class _Event_FetcherState extends State<Event_Fetcher> {
  List<Evnt> event = [];
  final Stream<QuerySnapshot> party =
      FirebaseFirestore.instance.collection('party').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
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

              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  Evnt eve = Evnt(
                      party_name: data.docs[index]['party_name'],
                      image: data.docs[index]['image'],
                      location: data.docs[index]['location'],
                      discription: data.docs[index]['discription'],
                      date: data.docs[index]['date'],
                      time: data.docs[index]['time'],
                      price: 0);
                  event.add(eve);
                  return InkWell(
                      child: Card(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              width: 80,
                              height: 100,
                              child: Image.network(
                                data.docs[index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            UIHelper.horizontalSpace(8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    DateTimeUtils.getFullDate(
                                        DateTime.parse("2001-12-12")),
                                    style: monthStyle),
                                UIHelper.verticalSpace(8),
                                Text("${data.docs[index]['party_name']}",
                                    style: titleStyle),
                                UIHelper.verticalSpace(8),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on,
                                        size: 16,
                                        color: Theme.of(context).primaryColor),
                                    UIHelper.horizontalSpace(4),
                                    Text("${data.docs[index]['location']}",
                                        style: subtitleStyle),
                                  ],
                                ),
                              ],
                            ),
                          ])),
                      onTap: () {
                        print(event[index].party_name.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailPage(event[index])));
                      });
                },
              );
            }),
      ),
    );
  }
}

class Fetchs extends StatefulWidget {
  Evnt eve;
  Fetchs(this.eve, {Key? key}) : super(key: key);

  @override
  State<Fetchs> createState() => _FetchState();
}

class _FetchState extends State<Fetchs> {
  late Evnt eve;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(eve.party_name.toString()),
    );
  }
}
