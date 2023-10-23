import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generatelivecaption/utils/device_info.dart';
import 'package:generatelivecaption/utils/string_extension.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:camera/camera.dart';
import 'package:mime/mime.dart';

class GnerateLiveCaptions extends StatefulWidget {
  const GnerateLiveCaptions({Key? key}) : super(key: key);

  @override
  State<GnerateLiveCaptions> createState() => _GnerateLiveCaptionsState();
}

class _GnerateLiveCaptionsState extends State<GnerateLiveCaptions> {
  final storageRef = FirebaseStorage.instance.ref();
  final firestore = FirebaseFirestore.instance;
  late String deviceId;

  String resultText = 'Fetching Response...';
  String currentR = '';
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool takephoto = false;
  bool capturingInProgress = false; // Add this flag
  bool _isLoadingResult = true;
  late Future<void> _initializeControllerFuture = Future.value();
  List colors = [Colors.red, Colors.green, Colors.yellow];
  int colorIndex = 0;

  getDeviceId() async {
    final androidId = await getId();
    if (androidId != null) {
      deviceId = androidId;
    } else {
      deviceId = 'Not Android Device';
    }
  }

  Future parseResponse(var response, File image) async {
    String r = '';
    var predictions = response['predictions'];
    //print('predict' + predictions);
    for (var prediction in predictions) {
      var caption = prediction['caption'];
      //var probability = prediction['probability'];
      String finalCaption = caption.toString().capitalize();
      r = r + '$finalCaption. \n\n';
    }

    if (currentR != r) {
      final imageId = DateTime.now().microsecondsSinceEpoch;

      final imagesRef = storageRef.child('images/$imageId');
      try {
        await imagesRef.putFile(image);
        final imgUrl = await imagesRef.getDownloadURL();
        firestore
            .collection('devices')
            .doc(deviceId)
            .collection('predicts')
            .add({
          'time': imageId,
          'predicts': r,
          'imageUrl': imgUrl,
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    }

    setState(() {
      colorIndex = (colorIndex + 1) % colors.length;
      resultText = r;
      currentR = r;
      _isLoadingResult = false;
    });
  }

  Future<Map<String, dynamic>> fetchResponse(File image) async {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');

    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://max-image-caption-generator1-kaexny6fxa-uc.a.run.app/model/predict'));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      final Map<String, dynamic> responseData = json.decode(response.body);
      await parseResponse(responseData, image);
      return responseData;
    } catch (e) {
      print(e);
      return {};
    }
  }

  void capturePicture() async {
    if (capturingInProgress) {
      return; // If capture is already in progress, skip this call
    }
    if (takephoto) {
      try {
        await _initializeControllerFuture;
        final image = await controller.takePicture();
        if (!mounted) {
          return;
        }
        print(image.path);
        File imgfile = File(image.path);
        fetchResponse(imgfile);
      } catch (e) {
        print(e);
      } finally {
        capturingInProgress = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    takephoto = true;

    getDeviceId();

    detectCameras().then((_) {
      initializeController();
    });
  }

  Future<void> detectCameras() async {
    cameras = await availableCameras();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initializeController() {
    controller = CameraController(cameras.first, ResolutionPreset.medium);
    _initializeControllerFuture = controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      if (takephoto) {
        const interval = Duration(seconds: 5);
        Timer.periodic(interval, (Timer t) => capturePicture());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.004, 1],
                    colors: [
                      Color(0x11232526),
                      Color(0xFF232526),
                    ],
                  ),
                ),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 35),
                        child: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            setState(() {
                              takephoto = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      (controller.value.isInitialized)
                          ? Center(child: buildCameraPreview())
                          : Container()
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget buildCameraPreview() {
    var size = MediaQuery.of(context).size.width / 1.2;
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: size,
              height: size,
              child: CameraPreview(controller),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'prediction is: \n',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 25,
              ),
            ),
            _isLoadingResult
                ? const CircularProgressIndicator()
                : Text(
                    resultText,
                    style: TextStyle(
                      fontSize: 16,
                      color: colors[colorIndex],
                    ),
                    textAlign: TextAlign.center,
                  )
          ],
        )
      ],
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
