import 'package:flutter/material.dart';
import 'package:iap_resusable_code/iap_subscription.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late SubscriptionPurchases subscriptionPurchases;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subscriptionPurchases = context.read<SubscriptionPurchases>();

    initSubs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscriptionPurchases.endConnection();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Consumer<SubscriptionPurchases>(
            builder: (BuildContext context, value, Widget? child) {
              debugPrint('purchaseslength ${value.purchases.length}');
              return Column(
                children: [
                  ListView.builder(itemBuilder: (c,pos) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Name - ${value.items[pos].title??''}'),
                          Text('Product Id - ${value.items[pos].productId??''}'),
                          Text('Price - ${value.items[pos].currency??''} ${value.items[pos].price??''}'),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: value.isPurchased ? Colors.grey : Colors.orange,
                            ),
                            // color: Colors.orange,
                            onPressed: value.isPurchased ? null : () {
                              print("---------- Buy Item Button Pressed");
                              value.requestPurchase(value.items[pos]);
                            },
                            child: Container(
                              height: 20.0,
                              child: Text(
                                value.isPurchased ? 'Purchased Item' : 'Buy Item',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },itemCount: value.items.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),),
                  GestureDetector(
                      onTap: (){
                        value.getPurchaseHistory();
                      },
                      child: Text('Purchase History')),
                  ListView.builder(
                    itemBuilder: (c,pos) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value.iapurchases[pos].toString()),
                          SizedBox(height: 10,)
                        ],
                      ),
                    );
                    },
                    itemCount: value.iapurchases.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void initSubs() async{

    await subscriptionPurchases.initPlatformState();
    await subscriptionPurchases.getProduct();
  }
}
