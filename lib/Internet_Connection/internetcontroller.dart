import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/utils/colors.dart';

class ConnectivityController extends GetxController {
  final _connectionType = MConnectivityResult.none.obs;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription _streamSubscription;

  MConnectivityResult get connectionType => _connectionType.value;

  set connectionType(value) {
    _connectionType.value = value;
    log("_connectionType: "+_connectionType.value.toString());
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getConnectivityType();
    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  Future<void> getConnectivityType() async {
     ConnectivityResult connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return _updateState(connectivityResult);
  }

  _updateState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType = MConnectivityResult.wifi;
        Get.snackbar("Wifi", "Connected with wifi",
    icon: Icon(
    Icons.circle,
    color: Colors.green,
    ),backgroundColor: Colors.white.withOpacity(0.5) );

        update();
        break;
      case ConnectivityResult.mobile:
        connectionType = MConnectivityResult.mobile;
        Get.snackbar("Mobile Data", "Connected with mobile data", 
            icon: Icon(
          Icons.circle,
          color: Colors.green,
        ),backgroundColor: Colors.white.withOpacity(0.5) );

        update();
        break;
      case ConnectivityResult.none:
        connectionType = MConnectivityResult.none;
        Get.snackbar("No Internet", "Connected with No Internet Available",
            icon: Icon(
              Icons.circle,
              color: Colors.red,
            ),backgroundColor: Colors.white.withOpacity(0.5) );

        update();
        break;
      default:
        print('Failed to get connection type');
        break;
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}

enum MConnectivityResult { none, wifi, mobile }
