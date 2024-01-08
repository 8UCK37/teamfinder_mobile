import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner_with_effect/qr_scanner_with_effect.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:teamfinder_mobile/controller/network_controller.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profilehome.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/utils/crypto.dart';
import 'package:teamfinder_mobile/utils/router_animation.dart';
import 'package:scan/scan.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool isComplete = false;

  String? imagePath;

  void onQrScannerViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      controller.pauseCamera();

      await Future<void>.delayed(const Duration(milliseconds: 300));

      String? myQrCode =
          result?.code != null && result!.code.toString().isNotEmpty
              ? result?.code.toString()
              : '';
      if (myQrCode != null && myQrCode.isNotEmpty) {
        //debugPrint(myQrCode);
        manageQRData(myQrCode);
      }
    });
  }

  void manageQRData(String myQrCode) async {
    controller?.stopCamera();
    setState(() {
      isComplete = true;
      //debugPrint(myQrCode);
      //navigator(myQrCode);
      checkIfUserExists(myQrCode);
    });
  }

  void navigator(dynamic decoded) {
    //debugPrint(decoded.toString());
    try {
      final userService = Provider.of<ProviderService>(context, listen: false);
      if (userService.user['id'] != decoded['id']) {
        controller?.stopCamera();
        controller!.dispose();
        AnimatedRouter.slideToPageLeftReplace(
            context,
            FriendProfileHome(
              friendId: decoded['id'],
              friendName: decoded['name'],
              friendProfileImage: decoded['profilePicture'],
            ));
      } else {
        infoAlert();
      }
    } catch (error) {
      debugPrint("caught: ${error.toString()}");
      errorAlert("Something went wrong!!");
    }
  }

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
    super.reassemble();
  }

  @override
  void dispose() {
    controller?.dispose();
    controller?.stopCamera();
    super.dispose();
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    debugPrint('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }

    // Check the file extension to determine the image type
    // ignore: unused_local_variable
    String fileExtension = pickedImage.path.split('.').last.toLowerCase();
    //debugPrint('CurrentfileType: $fileExtension');
    controller?.stopCamera();

    String result = await Scan.parse(pickedImage.path) ?? 'error';
    //debugPrint('scanned: $result');
    if (result != 'error') {
      debugPrint(result);

      checkIfUserExists(result);
    } else {
      // ignore: use_build_context_synchronously
      errorAlert("There is something wrong witht the QR!!");
    }
  }

  void checkIfUserExists(String myQrCode) async {
    try {
      dynamic decoded = jsonDecode(CryptoBro.decrypt(myQrCode));
      NetworkController networkController = NetworkController();
      if (await networkController.noInternet()) {
        debugPrint("checkIfUserExists() no_internet");
        errorAlert("No interner");
        return;
      } else {
        debugPrint("checkIfUserExists() called");
      }
      if (decoded['id'] == null || decoded['id'].length != 28) {
        errorAlert("There is something wrong witht the QR!!");
        return;
      }
      Dio dio = Dio();
      final user = FirebaseAuth.instance.currentUser;

      final idToken = await user!.getIdToken();
      Options options = Options(
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );

      var response = await dio.post(
        'http://${dotenv.env['server_url']}/checkIfUserExists',
        data: {'userId': decoded['id']},
        options: options,
      );
      if (response.statusCode == 200) {
        debugPrint("user exists");
        navigator(decoded);
      } else if (response.statusCode == 404) {
        debugPrint("user doesn't exists");
        // ignore: use_build_context_synchronously
        errorAlert("Apparently the user doesn't exiat");
      }
    } catch (error) {
      errorAlert("the qr is invalid");
    }
  }

  void errorAlert(String error) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      showConfirmBtn: true,
      confirmBtnText: "New Scan",
      onConfirmBtnTap: () {
        setState(() {
          isComplete = false;
        });
        controller?.resumeCamera();
        Navigator.of(context).pop();
      },
      showCancelBtn: true,
      cancelBtnText: "Go Back!",
      onCancelBtnTap: () {
        controller?.stopCamera();
        controller?.dispose();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      text: error,
    );
  }

  void warningAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      showConfirmBtn: true,
      confirmBtnText: "New Scan",
      onConfirmBtnTap: () {
        setState(() {
          isComplete = false;
        });
        controller?.resumeCamera();
        Navigator.of(context).pop();
      },
      showCancelBtn: true,
      cancelBtnText: "Go Back!",
      onCancelBtnTap: () {
        controller?.stopCamera();
        controller?.dispose();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      text: 'Does the image even contain a QR?!',
    );
  }

  void infoAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      showConfirmBtn: true,
      confirmBtnText: "Honto?",
      onConfirmBtnTap: () {
        setState(() {
          isComplete = false;
        });
        controller?.resumeCamera();
        Navigator.of(context).pop();
      },
      showCancelBtn: true,
      cancelBtnText: "Go Back!",
      onCancelBtnTap: () {
        controller?.stopCamera();
        controller?.dispose();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      text: 'This is you own profile !!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        floatingActionButton: GestureDetector(
          onTap: () {
            pickImage();
          },
          child: const Material(
            elevation: 20,
            shape: CircleBorder(),
            child: ClipOval(
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 25,
                child: Icon(
                  Icons.photo_library,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return QrScannerWithEffect(
            isScanComplete: isComplete,
            qrKey: qrKey,
            onQrScannerViewCreated: onQrScannerViewCreated,
            qrOverlayBorderColor: Colors.redAccent,
            cutOutSize: (MediaQuery.of(context).size.width < 300 ||
                    MediaQuery.of(context).size.height < 400)
                ? 250.0
                : 300.0,
            onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
            effectGradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1],
              colors: [
                Colors.redAccent,
                Colors.redAccent,
              ],
            ),
          );
        }),
      ),
    );
  }
}
