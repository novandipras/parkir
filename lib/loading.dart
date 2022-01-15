import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class Loading extends StatelessWidget {
  Loading({this.width,this.height,this.radius,this.wpadding,this.hpadding});

  double width, height,radius,hpadding,wpadding;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(padding: EdgeInsets.symmetric(vertical: wpadding,horizontal: hpadding),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
            baseColor: Color(0xFFBDBDBD),
            highlightColor: Color(0xFFD6D6D6),
            child: Container(
                margin: EdgeInsets.only(bottom: 12),
                height: height,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: Color(0xFFBDBDBD))),
          );
        });
  }
}