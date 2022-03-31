import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:iap_resusable_code/home_screen.dart';
import 'package:iap_resusable_code/iap_subscription.dart';
import 'package:provider/provider.dart';

//ref
//https://medium.com/flutter-community/in-app-purchases-with-flutter-a-comprehensive-step-by-step-tutorial-b96065d79a21
//https://medium.com/flutter-community/flutter-in-app-purchases-non-consumables-68cfbd9ea72

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SubscriptionPurchases>(
          create: (context) => SubscriptionPurchases(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Flutter In-app Purchase'),
            ),
            body: HomeScreen()),
      ),
    );
  }
}

