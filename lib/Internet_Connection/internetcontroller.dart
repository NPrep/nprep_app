import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/utils/colors.dart';

import '../main.dart';

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

  _updateState(ConnectivityResult result) async{
    switch (result) {
      case ConnectivityResult.wifi:
        await sprefs.setBool('is_internet', true);
        connectionType = MConnectivityResult.wifi;
        toastMsg("Wifi Connected with wifi", true);
        update();
        break;
      case ConnectivityResult.mobile:
        await sprefs.setBool('is_internet', true);
        connectionType = MConnectivityResult.mobile;
        toastMsg("Mobile Data Connected with mobile data", true);

        update();
        break;
      case ConnectivityResult.none:
        connectionType = MConnectivityResult.none;
        await sprefs.setBool('is_internet', false);
        toastMsg("No Internet Connected with No Internet Available", true);
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
