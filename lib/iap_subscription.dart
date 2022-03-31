
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class SubscriptionPurchases extends ChangeNotifier {
  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  late StreamSubscription _conectionSubscription;

  String _platformVersion = 'Unknown';
  List<IAPItem> items = [];
  List<PurchasedItem> purchases = [];
  List<IAPItem> iapurchases = [];

  int totalCount = 0;
  bool isPurchased = false;

  final List<String> _productLists = Platform.isAndroid
  ? [
  'android.test.purchased',
  'android.test.canceled',
  'dev_eventcreator'
  ]
      : ['basic01'];

  SubscriptionPurchases() {
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await FlutterInappPurchase.instance.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');


    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
          print('connected: $connected');
        });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {

          if(totalCount == 0)
            {
              //do call an api
              print('purchase-updated: $productItem');
              ++totalCount;
              isPurchased = true;
              notifyListeners();

            }
        });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
          print('purchase-error: $purchaseError');
        });
  }

  void requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId!);
  }

  Future getProduct() async {
    List<IAPItem> items =
    await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this.items.add(item);
    }
      this.items = items;
      this.purchases = [];

      notifyListeners();
  }

  void endConnection() async
  {
    print("---------- End Connection Button Pressed");
    await FlutterInappPurchase.instance.endConnection;
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription.cancel();
      // _purchaseUpdatedSubscription = null;
    }
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription.cancel();
      // _purchaseErrorSubscription = null;
    }

    _conectionSubscription.cancel();

    items = [];
      purchases = [];
      totalCount = 0;

  }

  Future getPurchases() async {
    List<PurchasedItem>? items =
    await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      print('${item.toString()}');
      purchases.add(item);
    }

      items = [];
      purchases = items;
      notifyListeners();
  }

  Future getPurchaseHistory() async {
    List<IAPItem>? items =
    await FlutterInappPurchase.instance.getSubscriptions(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      iapurchases.add(item);
    }

      // items = [];
    iapurchases = items;
      notifyListeners();
  }
}