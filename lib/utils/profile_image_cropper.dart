import 'dart:io';
import 'dart:typed_data';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';

class CropperScreen extends StatefulWidget {
  final String imagePath;
  const CropperScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<CropperScreen> createState() => _CropperScreenState();
}

class _CropperScreenState extends State<CropperScreen> {
  final GlobalKey _cropperKey = GlobalKey(debugLabel: 'cropperKey');
  Uint8List? _imageToCrop;
  late Uint8List? _croppedImage;
  final OverlayType _overlayType = OverlayType.circle;
  int _rotationTurns = 0;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    readFileAsBytes(widget.imagePath);
  }

  Future<void> readFileAsBytes(String filePath) async {
    File file = File(filePath);
    Uint8List uint8list = await file.readAsBytes();
    setState(() {
      _imageToCrop = uint8list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                Container(
                    child: _imageToCrop != null
                        ? Cropper(
                            cropperKey: _cropperKey,
                            overlayType: _overlayType,
                            rotationTurns: _rotationTurns,
                            image: Image.memory(_imageToCrop!),
                            onScaleStart: (details) {
                              // todo: define started action.
                            },
                            onScaleUpdate: (details) {
                              // todo: define updated action.
                            },
                            onScaleEnd: (details) {
                              // todo: define ended action.
                            },
                          )
                        : const SizedBox()
                )
              ]),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                children: [
                  ElevatedButton(
                    child: const Text('Crop image'),
                    onPressed: () async {
                      final imageBytes = await Cropper.crop(
                        cropperKey: _cropperKey,
                      );
          
                      if (imageBytes != null) {
                        setState(() {
                          _croppedImage = imageBytes;
                        });
                      }
                      if (mounted) Navigator.pop(context, _croppedImage);
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _rotationTurns--);
                    },
                    icon: const Icon(Icons.rotate_left),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _rotationTurns++);
                    },
                    icon: const Icon(Icons.rotate_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
