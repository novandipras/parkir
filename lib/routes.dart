import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'detail/detail.dart';
import 'home/home_app.dart';

class Routes {
  Routes() {
    final FluroRouter router = FluroRouter();
    routesInit(router);
    runApp(MaterialApp(
      title: 'Parkir Database',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeApp(),
      onGenerateRoute: router.generator,
    ));
  }

  void routesInit(FluroRouter router) {
    router.define('/home', transitionType: TransitionType.fadeIn, handler: homeHandler);
    router.define('/detail/:data', transitionType: TransitionType.fadeIn, handler: detailHandler);
  }

  Handler homeHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return HomeApp();
  });
  Handler detailHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return DetailApp(id: int.parse(params['data'][0]));
  });
}
