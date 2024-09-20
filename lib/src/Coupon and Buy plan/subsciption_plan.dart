import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Controller/SubscriptionController.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/buy_plan.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/plan_detail.dart';
import 'package:n_prep/utils/colors.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/bottom_bar.dart';
// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'Nprep App Purchase';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = '1_Year';
const String _kGoldSubscriptionId = '6_Month';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class SubscriptionPlan extends StatefulWidget {
   bool pagenav;
   SubscriptionPlan({Key key,this.pagenav});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

class _SubscriptionPlanState extends State<SubscriptionPlan> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//    StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = <String>[];
//   List<ProductDetails> _products = <ProductDetails>[];
//   List<PurchaseDetails> _purchases = <PurchaseDetails>[];
//   List<String> _consumables = <String>[];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String _queryProductError;
//   @override
//   void initState() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
//           _listenToPurchaseUpdated(purchaseDetailsList);
//         }, onDone: () {
//           _subscription.cancel();
//         }, onError: (Object error) {
//           // handle error here.
//         });
//     initStoreInfo();
//     super.initState();
//   }
//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = <ProductDetails>[];
//         _purchases = <PurchaseDetails>[];
//         _notFoundIds = <String>[];
//         _consumables = <String>[];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }
//
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//       _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     }
//
//     final ProductDetailsResponse productDetailResponse =
//     await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//
//       setState(() {
//         _queryProductError = productDetailResponse.error.message;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = <PurchaseDetails>[];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = <String>[];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }
//
//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = <PurchaseDetails>[];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = <String>[];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }
//
//     // final List<String> consumables = await ConsumableStore.load();
//
//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       // _consumables = consumables;
//       _purchasePending = false;
//       _loading = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//       _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       iosPlatformAddition.setDelegate(null);
//     }
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> stack = <Widget>[];
//     if (_queryProductError == null) {
//       stack.add(
//         ListView(
//           children: <Widget>[
//             _buildConnectionCheckTile(),
//             _buildProductList(),
//             _buildConsumableBox(),
//             _buildRestoreButton(),
//           ],
//         ),
//       );
//     } else {
//       stack.add(Center(
//         child: Text(_queryProductError),
//       ));
//     }
//     if (_purchasePending) {
//       stack.add(
//         // TODO(goderbauer): Make this const when that's available on stable.
//         // ignore: prefer_const_constructors
//         Stack(
//           children: const <Widget>[
//             Opacity(
//               opacity: 0.3,
//               child: ModalBarrier(dismissible: false, color: Colors.grey),
//             ),
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('IAP Example'),
//         ),
//         body: Stack(
//           children: stack,
//         ),
//       ),
//     );
//   }
//
//   Card _buildConnectionCheckTile() {
//     if (_loading) {
//       return const Card(child: ListTile(title: Text('Trying to connect...')));
//     }
//     final Widget storeHeader = ListTile(
//       leading: Icon(_isAvailable ? Icons.check : Icons.block,
//           color: _isAvailable
//               ? Colors.green
//               : ThemeData.light().colorScheme.error),
//       title:
//       Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
//     );
//     final List<Widget> children = <Widget>[storeHeader];
//
//     if (!_isAvailable) {
//       children.addAll(<Widget>[
//         const Divider(),
//         ListTile(
//           title: Text('Not connected',
//               style: TextStyle(color: ThemeData.light().colorScheme.error)),
//           subtitle: const Text(
//               'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//         ),
//       ]);
//     }
//     return Card(child: Column(children: children));
//   }
//
//   Card _buildProductList() {
//     if (_loading) {
//       return const Card(
//           child: ListTile(
//               leading: CircularProgressIndicator(),
//               title: Text('Fetching products...')));
//     }
//     if (!_isAvailable) {
//       return const Card();
//     }
//     const ListTile productHeader = ListTile(title: Text('Products for Sale'));
//     final List<ListTile> productList = <ListTile>[];
//     if (_notFoundIds.isNotEmpty) {
//       productList.add(ListTile(
//           title: Text('[${_notFoundIds.join(", ")}] not found',
//               style: TextStyle(color: ThemeData.light().colorScheme.error)),
//           subtitle: const Text(
//               'This app needs special configuration to run. Please see example/README.md for instructions.')));
//     }
//
//     // This loading previous purchases code is just a demo. Please do not use this as it is.
//     // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//     // We recommend that you use your own server to verify the purchase data.
//     final Map<String, PurchaseDetails> purchases =
//     Map<String, PurchaseDetails>.fromEntries(
//         _purchases.map((PurchaseDetails purchase) {
//           if (purchase.pendingCompletePurchase) {
//             _inAppPurchase.completePurchase(purchase);
//           }
//           return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//         }));
//     productList.addAll(_products.map(
//           (ProductDetails productDetails) {
//         final PurchaseDetails previousPurchase = purchases[productDetails.id];
//         log("productDetails ID>> "+productDetails.id.toString());
//         log("productDetails title>> "+productDetails.title.toString());
//         log("productDetails>> "+productDetails.description.toString());
//         log("productDetails>> "+productDetails.price.toString());
//         log("productDetails>> "+productDetails.rawPrice.toString());
//         log("productDetails>> "+productDetails.currencyCode.toString());
//         return ListTile(
//           title: Text(
//             productDetails.title,
//           ),
//           subtitle: Text(
//             productDetails.description,
//           ),
//           trailing: previousPurchase != null && Platform.isIOS
//               ? IconButton(
//               onPressed: () => confirmPriceChange(context),
//               icon: const Icon(Icons.upgrade))
//               : TextButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.green[800],
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () {
//                PurchaseParam purchaseParam;
//
//               if (Platform.isAndroid) {
//                 // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
//                 // verify the latest status of you your subscription by using server side receipt validation
//                 // and update the UI accordingly. The subscription purchase status shown
//                 // inside the app may not be accurate.
//                 final GooglePlayPurchaseDetails oldSubscription = _getOldSubscription(productDetails, purchases);
//
//                 purchaseParam = GooglePlayPurchaseParam(
//                     productDetails: productDetails,
//                     changeSubscriptionParam: (oldSubscription != null)
//                         ? ChangeSubscriptionParam(
//                       oldPurchaseDetails: oldSubscription,
//                       prorationMode:
//                       ProrationMode.immediateWithTimeProration,
//                     )
//                         : null);
//               }
//               else {
//                 purchaseParam = PurchaseParam(
//                   productDetails: productDetails,
//                 );
//               }
//
//               if (productDetails.id == _kConsumableId) {
//                 _inAppPurchase.buyConsumable(
//                     purchaseParam: purchaseParam,
//                     autoConsume: _kAutoConsume);
//               }
//               else {
//                 _inAppPurchase.buyNonConsumable(
//                     purchaseParam: purchaseParam);
//               }
//             },
//             child: Text(productDetails.price),
//           ),
//         );
//       },
//     ));
//
//     return Card(
//         child: Column(
//             children: <Widget>[productHeader, const Divider()] + productList));
//   }
//
//   Card _buildConsumableBox() {
//     if (_loading) {
//       return const Card(
//           child: ListTile(
//               leading: CircularProgressIndicator(),
//               title: Text('Fetching consumables...')));
//     }
//     if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
//       return const Card();
//     }
//     const ListTile consumableHeader =
//     ListTile(title: Text('Purchased consumables'));
//     final List<Widget> tokens = _consumables.map((String id) {
//       return GridTile(
//         child: IconButton(
//           icon: const Icon(
//             Icons.stars,
//             size: 42.0,
//             color: Colors.orange,
//           ),
//           splashColor: Colors.yellowAccent,
//           onPressed: () => consume(id),
//         ),
//       );
//     }).toList();
//     return Card(
//         child: Column(children: <Widget>[
//           consumableHeader,
//           const Divider(),
//           GridView.count(
//             crossAxisCount: 5,
//             shrinkWrap: true,
//             padding: const EdgeInsets.all(16.0),
//             children: tokens,
//           )
//         ]));
//   }
//
//   Widget _buildRestoreButton() {
//     if (_loading) {
//       return Container();
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           TextButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.push(context,MaterialPageRoute(builder: (context) =>PlanScreen(
//                                                               plan_price: double
//                                                                   .parse("1199.00")
//                                                                   .toStringAsFixed(
//                                                                   0),
//                                                               plan_name: "Plan 6",
//                                                               plan_id: "5",
//                                                               plan_mrp: "1200.00",
//                                                               plan_duration: "1",
//                                                               plan_description: "For Last Mile !",
//                                                               plan_period: "1",
//                                                             )));
//              _inAppPurchase.restorePurchases();
//                                                             },
//             child: const Text('Restore purchases'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> consume(String id) async {
//     // await ConsumableStore.consume(id);
//     // final List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       // _consumables = consumables;
//     });
//   }
//
//   void showPendingUI() {
//     setState(() {
//       _purchasePending = true;
//     });
//   }
//
//   Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     if (purchaseDetails.productID == _kConsumableId) {
//       // await ConsumableStore.save(purchaseDetails.purchaseID);
//       // final List<String> consumables = await ConsumableStore.load();
//       setState(() {
//         _purchasePending = false;
//         // _consumables = consumables;
//       });
//     }
//     else {
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//       });
//     }
//   }
//
//   void handleError(IAPError error) {
//     setState(() {
//       _purchasePending = false;
//     });
//   }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//     return Future<bool>.value(true);
//   }
//
//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//   }
//
//   Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
//     for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         showPendingUI();
//       }
//       else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           handleError(purchaseDetails.error);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           final bool valid = await _verifyPurchase(purchaseDetails);
//           if (valid) {
//             unawaited(deliverProduct(purchaseDetails));
//           } else {
//             _handleInvalidPurchase(purchaseDetails);
//             return;
//           }
//         }
//         if (Platform.isAndroid) {
//           if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//             final InAppPurchaseAndroidPlatformAddition androidAddition =
//             _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//             await androidAddition.consumePurchase(purchaseDetails);
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     }
//   }
//
//   Future<void> confirmPriceChange(BuildContext context) async {
//     // Price changes for Android are not handled by the application, but are
//     // instead handled by the Play Store. See
//     // https://developer.android.com/google/play/billing/price-changes for more
//     // information on price changes on Android.
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
//       _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
//     }
//   }
//
//   GooglePlayPurchaseDetails _getOldSubscription(ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//     // This is just to demonstrate a subscription upgrade or downgrade.
//     // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
//     // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
//     // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
//     // Please remember to replace the logic of finding the old subscription Id as per your app.
//     // The old subscription is only required on Android since Apple handles this internally
//     // by using the subscription group feature in iTunesConnect.
//     GooglePlayPurchaseDetails oldSubscription;
//     if (productDetails.id == _kSilverSubscriptionId &&
//         purchases[_kGoldSubscriptionId] != null) {
//       oldSubscription =purchases[_kGoldSubscriptionId] as GooglePlayPurchaseDetails;
//     } else if (productDetails.id == _kGoldSubscriptionId &&purchases[_kSilverSubscriptionId] != null) {
//       oldSubscription =
//       purchases[_kSilverSubscriptionId] as GooglePlayPurchaseDetails;
//     }
//     return oldSubscription;
//   }
// }
//
// /// Example implementation of the
// /// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
// ///
// /// The payment queue delegate can be implementated to provide information
// /// needed to complete transactions.
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }

  SubscriptionController subscriptionController = Get.put(
      SubscriptionController());
  var subscriptions_apiUrl;

  // Razorpay _razorpay;
  var selectedIndex;

  @override
  void initState() {
    super.initState();
    var settingUrl ="${apiUrls().setting_api}";
    settingController.SettingData(settingUrl);
    subscriptions_apiUrl = apiUrls().subscriptions_api;
    print("subscriptions_apiUrl....." + subscriptions_apiUrl.toString());
    subscriptionController.SubscriptionsData(subscriptions_apiUrl);
    log('SubscriptionsData==>'+subscriptionController.subscriptionData.toString());
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  SettingController settingController =Get.put(SettingController());
  String mainString = "gold";
  @override
  Widget build(BuildContext context) {
    var mediaquary=MediaQuery.of(context);
    var scale = mediaquary.textScaleFactor.clamp(1.10, 1.20);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight:widget.pagenav==true?0:AppBar().preferredSize.height,
          automaticallyImplyLeading: false,
          // centerTitle: center,
          elevation: 0,

          title: widget.pagenav==true?Container(): Row(
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.offAll(BottomBar(bottomindex: 0,));

                },
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),

              Container(
                width: MediaQuery.of(context).size.width-60,
                child: Text("Subscription Plans",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: 17.0,fontWeight: FontWeight.w400)),
              ),
            ],
          ),

        ),
        body: WillPopScope(

          onWillPop: () async {
            Get.offAll(BottomBar(bottomindex: 0,));
            return true;

          },
          child: GetBuilder<SubscriptionController>  (
              builder: (subscriptionController) {
                if (subscriptionController.subsLoader.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return RefreshIndicator(
                  displacement: 65,
                  backgroundColor: Colors.white,
                  color: primary,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await Future.delayed(Duration(milliseconds: 1500));
                    subscriptions_apiUrl = apiUrls().subscriptions_api;
                    subscriptionController.SubscriptionsData(
                        subscriptions_apiUrl);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MediaQuery(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: versionColor,
                            padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                            alignment: Alignment.center,
                            child: Text("Choose a plan according \n to your preference.",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500),),
                          ),
                          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                        ),
                        SizedBox(height: 10,),
                        ListView.builder(
                          itemCount: subscriptionController.subscriptionData['data'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var subscription_datas = subscriptionController.subscriptionData['data'][index];
                            print("subscription_data....." + subscription_datas.toString());
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 8.2,
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 18,vertical: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                MediaQuery(
                                                  child: Text(
                                                    " ${subscription_datas['name'].toString()}" == "null"? ""
                                                        :
                                                    "${subscription_datas['name'].toString()}",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: 'PublicSans',
                                                        color: black54),
                                                  ),
                                                  data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                                ),
                                                SizedBox(width: 5,),
                                                subscription_datas['name']==null?Container():subscription_datas['name'].contains("GOLD") ? Image.asset("assets/nprep2_images/gold.gif",height: 25,):Container(),
                                              ],
                                            ),
                                            SizedBox(height: 12,),
                                            Container(
                                              // color: Colors.red,
                                              // padding: EdgeInsets.only(left: 15.0),
                                              width: MediaQuery.of(context).size.width-200,
                                              child: MediaQuery(
                                                child: Html(
                                                  data:subscription_datas['description'],

                                                  style: {
                                                    "table": Style( ),
                                                    // some other granular customizations are also possible
                                                    "tr": Style(
                                                      border: Border(
                                                        bottom: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                        top: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                        right: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                        left: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                      ),
                                                    ),
                                                    "p": Style(
                                                      fontSize: FontSize.xxSmall,

                                                    ),
                                                    "th": Style(
                                                      padding: EdgeInsets.all(6),
                                                      backgroundColor: Colors.black,
                                                    ),
                                                    "td": Style(
                                                      padding: EdgeInsets.all(2),
                                                      alignment: Alignment.topLeft,
                                                    ),
                                                    "pr": Style(
                                                      // fontSize: 12,
                                                        fontSize:FontSize.small ,
                                                        fontWeight: FontWeight.w400,
                                                        fontFamily: 'PublicSans',
                                                        color: black54),
                                                  },
                                                  customRenders: {
                                                    tableMatcher(): tableRender(),
                                                  },
                                                  // style: TextStyle(
                                                  //     fontSize: 12,
                                                  //
                                                  //     fontWeight: FontWeight.w400,
                                                  //     fontFamily: 'Helvetica',
                                                  //     color: black54),
                                                ),
                                                data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                MediaQuery(
                                                  child: Text(
                                                    '\u20B9 ',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight
                                                            .w700,
                                                        fontFamily: 'PublicSans',
                                                        color: black54
                                                    ),
                                                  ),
                                                  data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                                ),
                                                MediaQuery(
                                                  child: Text(
                                                    " ${subscription_datas['price']==null?"":
                                                    double.parse(subscription_datas['price'].toString())
                                                        .toStringAsFixed(0)}" =="null"? ""
                                                        :"${subscription_datas['price']==null?"":double.parse(
                                                        subscription_datas['price']
                                                            .toString())
                                                        .toStringAsFixed(0)}",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight
                                                            .w700,
                                                        fontFamily: 'PublicSans',
                                                        color: black54),
                                                  ),
                                                  data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            GestureDetector(
                                              onTap: () async {
                                                var settingUrl ="${apiUrls().setting_api}";
                                                await settingController.SettingData(settingUrl);
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                                    PlandetailScreen(
                                                      plan_name: subscription_datas['name'].toString(),
                                                      plan_description:subscription_datas['description'].toString(),
                                                      plan_price: subscription_datas['price'].toString(),
                                                      plan_index: index,
                                                    )));
                                              },
                                              child: MediaQuery(
                                                child: Container(
                                                  // width: 120,
                                                  // height: 40,
                                                  decoration: BoxDecoration(
                                                      color: primary,
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          18)),
                                                  child:Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 8),
                                                      child: Text(
                                                        subscriptionController
                                                            .buyplanLoader.value ==
                                                            false
                                                            ||
                                                            selectedIndex != index
                                                            ? 'Buy Now'
                                                            : "Loading..",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .w700,
                                                            fontFamily: 'PublicSans',
                                                            fontSize: 18,
                                                            color: white),
                                                      )

                                                  ),
                                                ),
                                                data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            );
    //                   return subscription_datas['subscriptions'].length==0 ?
    //                   ListTile(title: Text(subscription_datas['subscription_category'].toString().capitalize,style: TextStyle(
    //                       fontSize: 20,
    //                       fontWeight: FontWeight
    //                           .w700,
    //                       fontFamily: 'Helvetica',
    //                       color: black54),),
    //                     )
    //                       : ExpansionTile(
    //                     title: Text(subscription_datas['subscription_category'].toString().capitalize,style: TextStyle(
    //                         fontSize: 20,
    //                         fontWeight: FontWeight
    //                             .w700,
    //                         fontFamily: 'Helvetica',
    //                         color: black54),),
    //                     children: [
    //                       ListView.builder(
    // itemCount: subscription_datas['subscriptions'].length,
    // shrinkWrap: true,
    // physics: NeverScrollableScrollPhysics(),
    // itemBuilder: (BuildContext context, int index) {
    // var subscription_data = subscription_datas['subscriptions'][index];
    // print("subscription_data....." + subscription_data.toString());
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Stack(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.only(top: 2.5),
    //         child: Card(
    //           elevation: 8.2,
    //           child: Container(
    //               margin: EdgeInsets.symmetric(
    //                   horizontal: 18,vertical: 20),
    //
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment
    //                         .start,
    //                     // mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       Row(
    //                         children: [
    //                           Text(
    //                             " ${subscription_data['plan_title']
    //                                 .toString()}" ==
    //                                 "null"
    //                                 ? ""
    //                                 :
    //                             "${subscription_data['plan_title']
    //                                 .toString()}",
    //                             style: TextStyle(
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight
    //                                     .w700,
    //                                 fontFamily: 'Helvetica',
    //                                 color: black54),
    //                           ),
    //                           SizedBox(width: 5,),
    //                           subscription_data['plan_title'].contains("GOLD") ? Image.asset("assets/nprep2_images/gold.gif",height: 25,):Container(),
    //                         ],
    //                       ),
    //                       SizedBox(height: 12,),
    //                       Container(
    //                         // color: Colors.red,
    //                         padding: EdgeInsets.only(left: 15.0),
    //                         width: MediaQuery.of(context).size.width-200,
    //                         child: Text(
    //
    //                           " ${subscription_data['description']
    //                               .toString()}" ==
    //                               "null"
    //                               ? ""
    //                               :
    //                           "${subscription_data['description']
    //                               .toString()}",
    //
    //                           style: TextStyle(
    //                               fontSize: 12,
    //
    //                               fontWeight: FontWeight.w400,
    //                               fontFamily: 'Helvetica',
    //                               color: black54),
    //                         ),
    //                       ),
    //                       SizedBox(height: 12,),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment
    //                             .start,
    //                         children: [
    //                           Text(
    //                             '${subscription_data['period_duration']
    //                                 .toString() == "null"
    //                                 ? ""
    //                                 : subscription_data['period_duration']
    //                                 .toString()}'
    //                                 ' ${int.parse(
    //                                 subscription_data['plan_duration']
    //                                     .toString()) == 1
    //                                 ? "Month Validity"
    //                                 : "Year Validity"}',
    //                             style: TextStyle(
    //                                 fontSize: 15,
    //                                 fontStyle: FontStyle.italic,
    //                                 fontWeight: FontWeight
    //                                     .w700,
    //                                 fontFamily: 'Helvetica',
    //                                 color: Colors.black38),
    //                           ),
    //                         ],
    //                       )
    //                     ],
    //                   ),
    //                   Column(
    //                     children: [
    //                       Row(
    //                         crossAxisAlignment: CrossAxisAlignment
    //                             .start,
    //                         // mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             '\u20B9 ',
    //                             style: TextStyle(
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight
    //                                     .w700,
    //                                 fontFamily: 'Helvetica',
    //                                 color: black54
    //                             ),
    //                           ),
    //                           Text(
    //                             " ${double.parse(
    //                                 subscription_data['plan_price']
    //                                     .toString())
    //                                 .toStringAsFixed(0)}" ==
    //                                 "null"
    //                                 ? ""
    //                                 :
    //                             "${double.parse(
    //                                 subscription_data['plan_price']
    //                                     .toString())
    //                                 .toStringAsFixed(0)}",
    //                             style: TextStyle(
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight
    //                                     .w700,
    //                                 fontFamily: 'Helvetica',
    //                                 color: black54),
    //                           )
    //                         ],
    //                       ),
    //                       SizedBox(height: 5,),
    //                       GestureDetector(
    //                         onTap: () {
    //                           Navigator.push(context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       PlanScreen(
    //                                         plan_price: double
    //                                             .parse(
    //                                             subscription_data['plan_price']
    //                                                 .toString())
    //                                             .toStringAsFixed(
    //                                             0),
    //                                         plan_name: subscription_data['plan_title']
    //                                             .toString(),
    //                                         plan_id: subscription_data['id']
    //                                             .toString(),
    //                                         plan_mrp: subscription_data['mrp_price']
    //                                             .toString(),
    //                                         plan_duration: subscription_data['period_duration']
    //                                             .toString(),
    //                                         plan_description: subscription_data['description']
    //                                             .toString(),
    //                                         plan_period: subscription_data['plan_duration'].toString(),
    //                                         plan_inapp_id: subscription_data['package_id'].toString(),
    //
    //                                       )));
    //
    //                         },
    //                         child: Container(
    //                           // width: 120,
    //                           // height: 40,
    //                           decoration: BoxDecoration(
    //                               color: primary,
    //                               borderRadius: BorderRadius
    //                                   .circular(
    //                                   18)),
    //                           child:Padding(
    //                               padding: EdgeInsets.symmetric(
    //                                   horizontal: 16,
    //                                   vertical: 8),
    //                               child: Text(
    //                                 subscriptionController
    //                                     .buyplanLoader.value ==
    //                                     false
    //                                     ||
    //                                     selectedIndex != index
    //                                     ? 'Buy Now'
    //                                     : "Loading..",
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight
    //                                         .w700,
    //                                     fontFamily: 'Helvetica',
    //                                     fontSize: 18,
    //                                     color: white),
    //                               )
    //
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               )),
    //         ),
    //       ),
    //
    //       subscription_data['is_recomended']==1? Image.asset("assets/nprep2_images/recmmended.png",height: 40,):Container(),
    //     ],
    //   ),
    // );
    // }),
    //                     ],
    //                   );
                          },
                        ),


                        SizedBox(height: 15,),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Have any query? ",
                            style:  TextStyles.loginB1Style,
                            children: [
                              TextSpan(
                                text: 'Whatsapp us ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // GetDilogssss("sucessmsg");
                                    var phoneNumber =settingController.settingData['data']['general_settings']['phone'].toString();
                                    openWhatsApp(phoneNumber);
                                  },
                              ),
                              TextSpan(
                                text: 'for assistance. ',
                                style: TextStyles.loginB1Style,

                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                      ],
                    ),
                  ),
                );
              }
          ),
        )
    );
  }

  void openWhatsApp(String phoneNumber) async {
    print(" oo $phoneNumber");
    String url = "https://wa.me/$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
