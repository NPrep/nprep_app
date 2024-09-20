import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/Service/TokenExpairy.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/Nphase2/Controller/ExaplepaymentInAppPurchase.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/q_bank/AllQuiz_qbank/sucesspop.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:http/http.dart' as http;
import '../src/Coupon and Buy plan/subsciption_plan.dart';
const String _kSilverSubscriptionId = '1_Year';
const String _kGoldSubscriptionId = '6_Month';
const List<String> _kProductIds = <String>[

  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class SubscriptionController extends GetxController{

  var subsLoader = false.obs;
  var subscriptionData;
  var planLoader = false.obs;
  var planData;
  var nocoupan="".obs;
  var coupansuccess="".obs;
  var planname ="".obs;
  var plannameAmt ="".obs;

Razorpay _razorpay;
UpdatePlanDetail(plannames,plannameAmts){
   planname.value =plannames;
   plannameAmt.value =plannameAmts;
   update();
}
//InAppPurchase
  InAppPurchase _inAppPurchase = InAppPurchase.instance;
   StreamSubscription<List<PurchaseDetails>> _streamSubscription;
  List<ProductDetails> productscheck = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _notFoundIds = <String>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;
  var discountedPrice = 0.0;

  void openCheckout(amt,orderid) async {
    print("check");
    var rezorpayKey = Environment.rezorpayKey;
    print("rezorpayKey...."+rezorpayKey.toString());
  var email=  sprefs.getString("email");
    var mobile= sprefs.getString("mobile");
    var options = {
      'key': rezorpayKey.toString(),
      'amount': amt,
      'name': 'nprep',
      "order_id": orderid.toString(),
      'description': 'Payment',
      'prefill': {'contact': '$mobile',
        'email': '$email'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {

      Logger().e(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId,);
    // Fluttertoast.showToast(msg: "signature: " + response.signature,);
    // Fluttertoast.showToast(msg: "orderId: " + response.orderId,);
    print("paymentId sucess....."+response.paymentId.toString());
    print("signature sucess....."+response.signature.toString());
    print("orderId sucess....."+response.orderId.toString());

    var payment_sucessUrl= "${apiUrls().payment_sucess_api}${url_razorpay_id}";

    var parameterplaceorder={
      'transaction_id':  response.paymentId.toString(),
      'order_id': response.orderId.toString(),
      'signature_id':response.signature.toString()
    };
    print("payment_sucessUrl....."+payment_sucessUrl.toString());
    print("parameterplaceorder....."+parameterplaceorder.toString());
    UpdatePaymentData(payment_sucessUrl, parameterplaceorder);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "PaymentError: " +  response.message,
    );
    GetDilogssss(false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,);

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {

    super.onClose();
  }
  callinit_fun_inapppur(plan_inapp_id) async {

    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _streamSubscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchase(purchaseDetailsList);
    },
        onDone: () {
      _streamSubscription.cancel();
      log("purchaseList onDone> cancel");
    }, onError: (Object error) {
      // handle error here.
      log("purchaseList onError> onError");
      toastMsg("Error", false);
    });

    initStoreInfo(plan_inapp_id);
  }
    Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }
  _listenToPurchase(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pending")));
      }
      else if (purchaseDetails.status == PurchaseStatus.error) {
        log("inapppurchase error "+PurchaseStatus.error.name);
        GetDilogssss(false);
        // ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Error>> ${PurchaseStatus.error.name}")));
      }
      else if (purchaseDetails.status == PurchaseStatus.purchased ||purchaseDetails.status == PurchaseStatus.restored) {
        var payment_in_app_purchaseUrl = apiUrls().payment_in_app_purchase_api+generate_PurchaseData_id;
        var body ={
          "purchase_id":purchaseDetails.purchaseID.toString(),
          "payment_status":"purchased",
          "localVerificationData":purchaseDetails.verificationData.localVerificationData.toString(),
        };

        await InAppPurchasePaymentData(payment_in_app_purchaseUrl,body);
        var packageName = "";
        var productId = "";
        var token = "";
        jsonDecode(purchaseDetails.verificationData.localVerificationData).forEach((k,v){
          log("localVerificationData-----Key>>>>>>"+k.toString());
          log("localVerificationData-----Value>>>>>>"+v.toString());
          if(k == "productId"){
            productId = v;

          }
          if(k == "purchaseToken"){
            token = v;

          }
          if(k == "packageName"){
            packageName=v;
          }
        });
        var resp = await http.post(Uri.parse("https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{$packageName}/purchases/products/{$productId}/tokens/{$token}:acknowledge"));
        var datass = jsonEncode(resp.body);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    });
  }
  void showPendingUI() {

   _purchasePending = true;
    update();
  }


  buy(){
    final PurchaseParam param = PurchaseParam(productDetails: productscheck[0]);
    _inAppPurchase.buyNonConsumable(purchaseParam: param);
    productscheck.forEach((element) {
      print("title hit>> "+element.title.toString());
      log("title hit>> "+element.title.toString());
      log("currencyCode hit>> "+element.currencyCode.toString());
      log("currencySymbol hit>> "+element.currencySymbol.toString());
      log("description hit>> "+element.description.toString());
      log("price hit>> "+element.price.toString());
      log("id hit>> "+element.id.toString());
      log("rawPrice hit>> "+element.rawPrice.toString());
      // if(element.id.toString() =="1_Year"){
      //   PurchaseParam purchaseParam;
      //   purchaseParam = PurchaseParam(
      //     productDetails:element,
      //   );
      //   _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      // }
    });


  }



  Future<void> initStoreInfo(plan_inapp_id) async {
    var _variant = {"${plan_inapp_id}"};
    final bool isAvailable = await _inAppPurchase.isAvailable();
    log("_inAppPurchase isAvailable "+isAvailable.toString());
    if (!isAvailable) {
      log("_inAppPurchase>>> 1");
        _isAvailable = isAvailable;
        productscheck = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];

        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
        update();
      return;
    }
    log("_inAppPurchase>>> 2");
    if (Platform.isIOS) {
      log("_inAppPurchase>>> 3");
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
    log("_inAppPurchase>>> 4");
    ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_variant);

    if (productDetailResponse.error != null) {
      log("_inAppPurchase>>> 5");
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        productscheck = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;

      return;
    }
    log("_inAppPurchase>>> 6");
    if (productDetailResponse.productDetails.isEmpty) {
      log("_inAppPurchase>>> 7");
        _queryProductError = null;
        _isAvailable = isAvailable;
        productscheck = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;

      return;
    }
    log("_inAppPurchase>>> 8");
    // final List<String> consumables = await ConsumableStore.load();
    productDetailResponse.productDetails.forEach((element) {
      log("productDetailResponse productDetails>> "+element.id);
      log("productDetailResponse productDetails>> "+element.price);
      log("productDetailResponse productDetails>> "+element.description);
      log("productDetailResponse productDetails>> "+element.title);
      log("productDetailResponse productDetails>> "+element.rawPrice.toString());
    });

log("productDetailResponse notFoundIDs>> "+productDetailResponse.notFoundIDs.toString());
      _isAvailable = isAvailable;
      productscheck = productDetailResponse.productDetails;

      _notFoundIds = productDetailResponse.notFoundIDs;
      // _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    log("_inAppPurchase>>> 9");
  }

  @override
  void onClose() {
    super.onClose();
  }

  GetDilogssss(bool paymentstatus){
     Get.dialog(
         Container(
           color: Colors.red,
           child: SafeArea(

             left: false,
             right: false,
             bottom: false,
             child: Scaffold(

               appBar: PreferredSize(
                 preferredSize: Size.fromHeight(0.0),
                 child: AppBar(
                  foregroundColor: Colors.red,
                   backgroundColor: Colors.red,

                   // iconTheme: IconThemeData(color: Colors.white),
                 ),
               ),
               body: Container(
                   // height:280,
                   color: paymentstatus==true?Colors.green:Colors.red,
                   // decoration: BoxDecoration(
                   //     borderRadius: BorderRadius.all(Radius.circular(50))
                   // ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [

                       Stack(
                         clipBehavior: Clip.none,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 10,right: 10),
                             child: Card(
                               elevation: 0.8,
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   SizedBox(height: 50,),
                                   sizebox_height_25,
                                   Container(
                                     // color: primary,
                                     // height: 45,
                                     alignment: Alignment.center,
                                     child: Text(paymentstatus==true?"Payment Successfull":"Payment Failed",
                                       style: TextStyle(color: Colors.black87,
                                           fontSize: 19.0,fontWeight: FontWeight.w800,letterSpacing: 0.5),),
                                   ),
                                   sizebox_height_15,
                                   Container(
                                     // color: primary,
                                     // height: 45,
                                     alignment: Alignment.center,
                                     child: paymentstatus==true?Text("Your payment of \u{20B9}${plannameAmt} is successfull.",
                                       style: TextStyle(color: Colors.black54,
                                           fontSize: 14.0,fontWeight: FontWeight.w300,letterSpacing: 0.2),):Text("Your payment of \u{20B9}${plannameAmt} is failed.",
                                       style: TextStyle(color: Colors.black54,
                                           fontSize: 14.0,fontWeight: FontWeight.w300,letterSpacing: 0.2),),
                                   ),
                                   sizebox_height_15,
                                   Divider(
                                     thickness: 1,
                                     height: 30,
                                     color: grey,
                                     indent: 0,
                                     endIndent: 0,
                                   ),
                                   sizebox_height_25,
                                   Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Container(
                                         // color: primary,
                                         // height: 45,
                                         padding: EdgeInsets.only(left: 15),
                                         alignment: Alignment.centerLeft,
                                         child: Text("\u{20B9}${plannameAmt}",
                                           style: TextStyle(color: Colors.black54,
                                               fontSize: 28.0,fontWeight: FontWeight.w900,letterSpacing: 0.2),),
                                       ),
                                       sizebox_height_15,
                                       Container(
                                         // color: primary,
                                         // height: 45,
                                         padding: EdgeInsets.only(left: 15),
                                         alignment: Alignment.centerLeft,
                                         child: Text("Product Name ",
                                           style: TextStyle(color: Colors.black,
                                               fontSize: 16.0,fontWeight: FontWeight.w700,letterSpacing: 0.5),),
                                       ),
                                       sizebox_height_10,
                                       Container(
                                         // color: Colors.red,
                                         width: 350,
                                         padding: EdgeInsets.only(left: 15),
                                         alignment: Alignment.centerLeft,
                                         child: Text("${planname}",
                                           style: TextStyle(color: Colors.black54,
                                               fontSize: 18.0,fontWeight: FontWeight.bold,letterSpacing: 0.2),),
                                       ),
                                     ],
                                   ),
                                   sizebox_height_25,
                                   GestureDetector(
                                     onTap: (){
                                       Get.back();
                                       Get.off(SubscriptionPlan());
                                     },
                                     child: Container(
                                       margin: EdgeInsets.symmetric(
                                           vertical: 10, horizontal: 20),
                                       height: 40,
                                       decoration: BoxDecoration(
                                         color: white,
                                         border: Border.all(color: primary),
                                         borderRadius: BorderRadius.all(
                                           Radius.circular(8),
                                         ),
                                       ),
                                       child: Center(
                                           child: Text(
                                             "Explore plans",
                                             textAlign: TextAlign.center,
                                             style: TextStyle(
                                                 color: Color(0xff64C4DA),
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.w500),
                                           )),
                                     ),
                                   ),
                                   GestureDetector(
                                     onTap: (){
                                       Get.back();
                                     },
                                     child: Container(
                                       margin: EdgeInsets.symmetric(
                                           vertical: 10, horizontal: 20),
                                       height: 40,
                                       decoration: BoxDecoration(
                                         color: Color(0xff64C4DA).withOpacity(0.9),
                                         border: Border.all(color: primary),
                                         borderRadius: BorderRadius.all(
                                           Radius.circular(8),
                                         ),
                                       ),
                                       child: Center(
                                           child: Text(
                                              "R E T R Y",
                                             textAlign: TextAlign.center,
                                             style: TextStyle(
                                                 color: white,
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.w500),
                                           )),
                                     ),
                                   ),

                                   sizebox_height_25,
                                 ],
                               ),
                             ),
                           ),
                          Positioned(
                            top: -50,
                            right: 10,
                            left: 10,
                            child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: paymentstatus==true?Colors.green:Colors.red,width: 4)
                            ),
                            child: Icon(paymentstatus==true?Icons.check:Icons.clear,size: 35,color: paymentstatus==true?Colors.green:Colors.red,),
                          ),)
                         ],
                       ),
                       // sizebox_height_10,
                       // Image.asset(
                       //   "assets/nprep2_images/paymentsucces.gif",
                       //   // scale: 2,
                       //   height: 120.0,
                       //   width: 250.0,
                       // ),
                       // sizebox_height_10,
                       //
                       // Container(
                       //   alignment: Alignment.center,
                       //   // width: ,
                       //   margin: EdgeInsets.all( 10),
                       //   child: Text("${sucessmsg.toString()}",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54,
                       //       fontSize: 16.0,fontWeight: FontWeight.bold,letterSpacing: 0.8),),
                       // ),
                       // sizebox_height_10,
                       // GestureDetector(
                       //   onTap: (){
                       //     Get.back();
                       //   },
                       //   child: Container(
                       //     decoration: BoxDecoration(
                       //       borderRadius: BorderRadius.circular(10),
                       //       color: primary,
                       //     ),
                       //     width: 80,height: 40,
                       //     alignment: Alignment.center,
                       //     child: Text("Done",style: TextStyle(color: Colors.white,
                       //         fontSize: 16.0,fontWeight: FontWeight.w700,letterSpacing: 0.2),),
                       //   ),
                       // ),
                       // sizebox_height_10,
                       //------------//
                       // Container(
                       //   color: primary,
                       //   height: 45,
                       //   alignment: Alignment.center,
                       //   child: Text("Payment Successfull",
                       //     style: TextStyle(color: Colors.white,
                       //         fontSize: 19.0,fontWeight: FontWeight.w800,letterSpacing: 0.5),),
                       // ),

                       // Container(
                       //     // alignment: Alignment.center,
                       //     margin: EdgeInsets.only(top: 10),
                       //
                       //     child: Image.asset("assets/images/LOGO.png", height:60,)
                       //
                       // ),
                       //-----------//
                     ],
                   )

               ),
             ),
           ),
         )
     );
  }

  PlanHistoryData(url)async{
    planLoader(true);
    try{
      var result = await apiCallingHelper().getAPICall(url, true);
      if(result != null){
        if(result.statusCode == 200){
          planData =jsonDecode(result.body);
          Logger_D("planData ........${planData}");
          planLoader(false);
          update();
          refresh();
        }
        else if(result.statusCode == 404){
          planData =jsonDecode(result.body);
          Logger_D("planData ........${planData}");
          planLoader(false);
          update();
          refresh();
        }
        else if(result.statusCode == 401){
          TokenExpairy().tokenExpairy();
          planLoader(false);
        }
        else if(result.statusCode == 500){

          planLoader(false);
        }
        else{
          planLoader(false);
          update();
          refresh();
        }
        update();
        refresh();
      }
    }
    catch (e){
      Logger().e("catch error ........${e}");
      subsLoader(false);
      update();
    }
  }

  SubscriptionsData(url)async{
    subsLoader(true);
    try{
      var result = await apiCallingHelper().getAPICall(url, true);
      if(result != null){
        if(result.statusCode == 200){
          subscriptionData =jsonDecode(result.body);
          Logger_D("subscriptionData ........${subscriptionData}");
          subsLoader(false);
          update();
          refresh();
        }
        else if(result.statusCode == 404){

          subsLoader(false);
        }
        else if(result.statusCode == 401){

          subsLoader(false);
        }
        else{
          subsLoader(false);
        }
        update();
        refresh();
      }
    }
    catch (e){
      Logger().e("catch error ........${e}");
      subsLoader(false);
      update();
    }
  }



  var verifyLoader = false.obs;
  var verify_data;

  VerifyCouponData(url)async{
    verifyLoader(true);
    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        verify_data =jsonDecode(result.body);
        print("verify_statusCode...."+result.statusCode.toString());
        if(result.statusCode == 200){
          verify_data =jsonDecode(result.body);
          print("verify_data....."+verify_data.toString());
          discountedPrice = verify_data['data']['discounted_price'];

          verifyLoader(false);
          nocoupan.value = "";
          coupansuccess.value ="";
          toastMsg(verify_data['message'].toString(), false);
          update();
          refresh();
        }else  if(result.statusCode == 401){
          verifyLoader(false);
          nocoupan.value = "";
          discountedPrice = 0.0;
          update();
          refresh();
        }
        else  if(result.statusCode == 400){

          // toastMsg(verify_data['message'].toString(), true);
          nocoupan.value = "";
          discountedPrice = 0.0;
          verifyLoader(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 404){

          // toastMsg(verify_data['message'].toString(), true);
          nocoupan.value = verify_data['message'].toString();
          discountedPrice = 0.0;
          verifyLoader(false);

          update();
          refresh();
        }
        else  if(result.statusCode == 500){
          verifyLoader(false);
          discountedPrice = 0.0;
          nocoupan.value = "";

          update();
          refresh();
        }
        else  if(result.statusCode == 226){
          toastMsg(verify_data['message'].toString(), true);
          discountedPrice = 0.0;
          verifyLoader(false);
          nocoupan.value = "";

          update();
          refresh();
        }
      } else {
        verifyLoader(false);
        discountedPrice = 0.0;
        update();
        refresh();
      }

    }
    catch (e){
      discountedPrice = 0.0;
      Logger().e("catch error ........${e}");
      verifyLoader(false);
      update();
    }
  }

  var buyplanLoader = false.obs;
  var buyplanData;
  var generate_PurchaseData;
  var rezorpay_orderId;
  var rezorpay_ammount;
  var url_razorpay_id;
  var generate_PurchaseData_id;

  BuyPlanData(url, parameter)async{
    buyplanLoader(true);
    update();
    try{
      var result = await apiCallingHelper().multipartAPICall(url, parameter, true);
      if(result != null){
        if(result.statusCode == 200){
          buyplanData =jsonDecode(result.body);
          Logger_D("buyplanData ........${buyplanData}");
          rezorpay_orderId = buyplanData['data']['razorpay_order_id'];
          rezorpay_ammount = buyplanData['data']['razorpay_amount'];
          var voucher_no = buyplanData['data']['voucher_no'];
          url_razorpay_id = buyplanData['data']['id'];

          openCheckout(rezorpay_ammount,rezorpay_orderId);
          print("voucher_no..."+voucher_no.toString());
          print("rezorpay_orderId..."+rezorpay_orderId.toString());
          print("rezorpay_ammount..."+rezorpay_ammount.toString());
          buyplanLoader(false);
          update();
          refresh();
        }
        else if(result.statusCode == 404){

          buyplanLoader(false);
        }
        else if(result.statusCode == 401){

          buyplanLoader(false);
        }
        else{
          buyplanLoader(false);
        }
        update();
        refresh();
      }
    }
    catch (e){
      Logger().e("catch error ........${e}");
      buyplanLoader(false);
      update();
    }
  }
  generate_In_App_PurchaseData(url, parameter)async{
    buyplanLoader(true);
    update();
    try{
      var result = await apiCallingHelper().multipartAPICall(url, parameter, true);
      if(result != null){
        if(result.statusCode == 200){
          generate_PurchaseData =jsonDecode(result.body);
          Logger_D("generate_In_App_PurchaseData ........${generate_PurchaseData.toString()}");
          // rezorpay_orderId = generate_PurchaseData['data']['razorpay_order_id'];
          // rezorpay_ammount = generate_PurchaseData['data']['razorpay_amount'];
          // var voucher_no = buyplanData['data']['voucher_no'];
          generate_PurchaseData_id = generate_PurchaseData['data']['id'];
          print("rezorpay_orderId..."+generate_PurchaseData_id.toString());
          print("rezorpay_ammount..."+rezorpay_ammount.toString());
          buyplanLoader(false);
          update();
          refresh();
        }
        else if(result.statusCode == 404){

          buyplanLoader(false);
        }
        else if(result.statusCode == 401){

          buyplanLoader(false);
        }
        else{
          buyplanLoader(false);
        }
        update();
        refresh();
      }
    }
    catch (e){
      Logger().e("catch error ........${e}");
      buyplanLoader(false);
      update();
    }
  }



  var updateLoader = false.obs;
  UpdatePaymentData(url, parameter)async{
    updateLoader(true);
    try{
      var result = await apiCallingHelper().multipartAPICall(url, parameter, true);
      if(result != null){
        if(result.statusCode == 200){
          // PaymentDialogSuccess();

          var sucessdata = jsonDecode(result.body);
          print("sucessdata....."+sucessdata.toString());
          var sucessmsg =sucessdata['message'];
          Get.offAll(BottomBar(bottomindex: 0,));
          GetDilogssss(true);

          updateLoader(false);
          update();
          refresh();
        }
        else if(result.statusCode == 404){

          updateLoader(false);
        }
        else if(result.statusCode == 401){

          updateLoader(false);
        }
        else{
          updateLoader(false);
        }
        update();
        refresh();
      }
    }
    catch (e){
      Logger().e("catch error ........${e}");
      buyplanLoader(false);
      update();
    }
  }
  InAppPurchasePaymentData(url, parameter)async{
    updateLoader(true);
    try{
      var result = await apiCallingHelper().multipartAPICall(url, parameter, true);
      if(result != null){
        if(result.statusCode == 200){
          // PaymentDialogSuccess();

          var sucessdata = jsonDecode(result.body);
          print("sucessdata....."+sucessdata.toString());
          var sucessmsg =sucessdata['message'];
          Get.offAll(BottomBar(bottomindex: 0,));
          GetDilogssss(true);

          updateLoader(false);
          update();
          refresh();
        }
        else if(result.statusCode == 404){

          updateLoader(false);
        }
        else if(result.statusCode == 401){

          updateLoader(false);
        }
        else{
          updateLoader(false);
        }
        update();
        refresh();
      }
    }
    catch (e){
      Logger().e("catch error ........${e}");
      buyplanLoader(false);
      update();
    }
  }

}