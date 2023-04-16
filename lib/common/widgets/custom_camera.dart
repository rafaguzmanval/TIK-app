import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tree_timer_app/common/widgets/custom_floating_buttons_bottom.dart';
import 'package:tree_timer_app/constants/utils.dart';

class CustomCamera extends StatefulWidget {

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  Function onSaved;


  CustomCamera({
    super.key,
    required this.onSaved,
  });

  @override
  State<CustomCamera> createState() => CustomCameraState();
}

class CustomCameraState extends State<CustomCamera> {

  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      widget._cameras = cameras;
      widget._cameraController = CameraController(
        // By default, use back camera
        widget._cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      widget._cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    widget._cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: 
                widget._cameraController != null && widget._cameraController!.value.isInitialized
                ? imageFile == null
                  ? CameraPreview(widget._cameraController!)
                  : Image.file(File(imageFile!.path))
                : Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    heroTag: UniqueKey(),
                    child: Icon(Icons.arrow_left),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  imageFile == null ? FloatingActionButton(
                    heroTag: UniqueKey(),
                    child: Icon(Icons.camera_alt),
                    onPressed: () async {
                      if (widget._cameraController != null && widget._cameraController!.value.isInitialized) {
                        final XFile? imgTmp = await widget._cameraController!.takePicture();
                        setState((){
                          imageFile = imgTmp;
                        });
                      }
                    },
                  ) : SizedBox(),
                  imageFile != null ? CustomFloatingButtonsBottom(parentWidget: widget, onSaved: widget.onSaved, onDeleted: (){setState(() {imageFile = null;});}, icon1: Icon(Icons.clear), icon2: Icon(Icons.check), isEditing: true) : SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
