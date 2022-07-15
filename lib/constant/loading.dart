import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: const Color(0xFF0E3311).withOpacity(0.5),
      ),
      //color: Colors.transparent,
      child: Center(
          child: SpinKitDoubleBounce(
        color: Colors.blue[500],
        size: 50.0,
      )),
    );
  }
}
