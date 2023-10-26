import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:camera/camera.dart';
import 'package:mime/mime.dart';
import 'dart:math';

class GnerateLiveCaptions extends StatefulWidget {
  const GnerateLiveCaptions({Key? key}) : super(key: key);

  @override
  State<GnerateLiveCaptions> createState() => _GnerateLiveCaptionsState();
}

class _GnerateLiveCaptionsState extends State<GnerateLiveCaptions> {
  String resultText = 'Fetching Response...';
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool takephoto = false;
  bool capturingInProgress = false; // Add this flag
  bool _isLoadingResult = true;
  late Future<void> _initializeControllerFuture = Future.value();
  List colors = [Colors.red, Colors.green, Colors.yellow];
  int colorIndex = 0;

  void parseResponse(var response) {
    String r = '';
    var predictions = response['predictions'];
    //print('predict' + predictions);
    for (var prediction in predictions) {
      var caption = prediction['caption'];
      var probability = prediction['probability'];
      r = r + '$caption\n\n';
    }
    setState(() {
      colorIndex = (colorIndex + 1) % colors.length;
      resultText = r;
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
      parseResponse(responseData);
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
    // String timesteps = DateTime.now().millisecondsSinceEpoch.toString();
    // final Directory extDir = await getApplicationDocumentsDirectory();
    // final String dirpath = '${extDir.path}/Pictures/flutter_test';
    // await Directory(dirpath).create(recursive: true);
    // final String filepath = '$dirpath/$timesteps.png';
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
        // await controller.takePicture().then((_) {
        //   if (takephoto) {
        //     Image.file(File(filepath));
        //     File imgfile = File(filepath);
        //     print(filepath);
        //     fetchResponse(imgfile);
        //   } else {
        //     return;
        //   }
        // });
        // await Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => DisplayPictureScreen(
        //       // Pass the automatically generated path to
        //       // the DisplayPictureScreen widget.
        //       imagePath: image.path,
        //     ),
        //   ),
        // );
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

  void initializeController() async {
    controller = CameraController(cameras.first, ResolutionPreset.medium);
    _initializeControllerFuture = controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      if (takephoto) {
        const interval = Duration(seconds: 3);
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
            );
          }
          return const CircularProgressIndicator();
        });
  }

  Widget buildCameraPreview() {
    var size = MediaQuery.of(context).size.width * 0.7;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: size,
                height: size,
                child: CameraPreview(controller),
              ),
              const SizedBox(
                height: 40,
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
          ),
        ],
      ),
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
