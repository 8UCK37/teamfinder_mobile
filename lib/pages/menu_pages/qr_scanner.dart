import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner_with_effect/qr_scanner_with_effect.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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
      navigator(myQrCode);
    });
  }

  void navigator(String myQrCode) {
    //debugPrint(decoded.toString());
    try {
      dynamic decoded = jsonDecode(CryptoBro.decrypt(myQrCode));
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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
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
    } catch (error) {
      debugPrint("caught: ${error.toString()}");
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
        text: 'There is something wrong with the QR!',
      );
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
    String fileExtension = pickedImage.path.split('.').last.toLowerCase();
    debugPrint('CurrentfileType: $fileExtension');
    controller?.stopCamera();

    String result = await Scan.parse(pickedImage.path) ?? 'error';
    debugPrint('scanned: $result');
    if (result != 'error') {
      navigator(result);
    } else {
      // ignore: use_build_context_synchronously
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
