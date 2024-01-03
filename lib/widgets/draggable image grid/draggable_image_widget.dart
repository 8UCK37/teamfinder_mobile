import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:multi_image_picker_view/src/multi_image_picker_controller_wrapper.dart';
import 'package:teamfinder_mobile/widgets/misc/custom_image_editor.dart';

import '../../utils/image_helper.dart';

class CustomDraggableItemWidget extends StatefulWidget {
  const CustomDraggableItemWidget({
    super.key,
    required this.imageFile,
    this.fit = BoxFit.cover,
    this.boxDecoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    this.showCloseButton = true,
    this.closeButtonAlignment = Alignment.topRight,
    this.closeButtonIcon,
    this.closeButtonBoxDecoration = const BoxDecoration(
      color: Color(0x55AAAAAA),
      shape: BoxShape.circle,
    ),
    this.closeButtonMargin = const EdgeInsets.all(4),
    this.closeButtonPadding = const EdgeInsets.all(3),
  });

  final ImageFile imageFile;
  final BoxFit fit;
  final BoxDecoration? boxDecoration;
  final bool showCloseButton;
  final Alignment closeButtonAlignment;
  final Widget? closeButtonIcon;
  final BoxDecoration? closeButtonBoxDecoration;
  final EdgeInsetsGeometry closeButtonMargin;
  final EdgeInsetsGeometry closeButtonPadding;

  @override
  State<CustomDraggableItemWidget> createState() =>
      _CustomDraggableItemWidgetState();
}

class _CustomDraggableItemWidgetState extends State<CustomDraggableItemWidget> {
  late var imageFile = widget.imageFile;

  void editImage(BuildContext context) async {
    String newImagePath = "";
    var editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          image: File(imageFile.path!),
        ),
      ),
    );
    if (editedImage != null) {
      newImagePath =
          await ImageHelper.saveEditedImage(editedImage, widget.imageFile.key);
      setState(() {
        ImageFile newImageFile = ImageFile(widget.imageFile.key,
            name: "post_image${widget.imageFile.key}",
            extension: widget.imageFile.extension,
            bytes: editedImage,
            path: newImagePath);
        imageFile = newImageFile;
        ///if this fails
        ///add 
        ///      void insertImage(ImageFile oldimage,ImageFile newImage) {
        ///             int index=_images.indexOf(oldimage);
        ///               _images[index]=newImage;
        ///           }
        /// in MultiImagePickerController
        MultiImagePickerControllerWrapper.of(context)
            .controller
            .insertImage(widget.imageFile, newImageFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: widget.boxDecoration,
            child: ImageFileView(
              fit: widget.fit,
              imageFile: imageFile,
            ),
          ),
        ),
        if (widget.showCloseButton)
          Positioned.fill(
            child: Align(
              alignment: widget.closeButtonAlignment,
              child: Padding(
                padding: widget.closeButtonMargin,
                child: DraggableItemInkWell(
                  onPressed: () => MultiImagePickerControllerWrapper.of(context)
                      .controller
                      .removeImage(widget.imageFile),
                  child: Container(
                      padding: widget.closeButtonPadding,
                      decoration: widget.closeButtonBoxDecoration,
                      child: widget.closeButtonIcon ??
                          const Icon(Icons.close, size: 18)),
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: widget.closeButtonMargin,
              child: DraggableItemInkWell(
                onPressed: () {
                  debugPrint("to edit");
                  editImage(context);
                },
                child: Container(
                    padding: widget.closeButtonPadding,
                    decoration: widget.closeButtonBoxDecoration,
                    child: widget.closeButtonIcon ??
                        const Icon(Icons.edit, size: 18)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
