import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generatelivecaption/pages/history.dart';
import 'package:generatelivecaption/utils/device_info.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'generatecaption.dart';
import '../utils/string_extension.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final storageRef = FirebaseStorage.instance.ref();
  final firestore = FirebaseFirestore.instance;

  bool _loading = true;
  bool _isLoadingResult = true;
  late File _image;
  final picker = ImagePicker();
  String resultText = 'Fetching Response...';
  late String deviceId;

  @override
  void initState() {
    super.initState();
    getDeviceId();
  }

  getDeviceId() async {
    final androidId = await getId();
    if (androidId != null) {
      deviceId = androidId;
    } else {
      deviceId = 'Not Android Device';
    }
  }

  Future pickimage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _loading = false;
      }
    });
    dialogLoop();
  }

  dialogLoop() async {
    var responseData = await fetchResponse(_image);
    while (responseData['errors'] != null) {
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: const Text('Something wrong, do you want to try again'),
              actions: [
                TextButton(
                    onPressed: () {
                      // Navigator.pop(ctx, 'Go back');
                      Navigator.pushReplacement(ctx,
                          MaterialPageRoute(builder: (ctx) => const Home()));
                    },
                    child: const Text('Go Back')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx, 'Try again');
                    },
                    child: const Text('Try again')),
              ],
            );
          }).then((value) async {
        if (value == 'Try again') {
          responseData = await fetchResponse(_image);
        } else {
          responseData.clear();
        }
      });
    }
    await parseResponse(responseData);
  }

  pickgalleryimage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _image = File(pickedFile.path);
      _loading = false;
    });

    dialogLoop();
  }

  Future<Map<String, dynamic>> fetchResponse(File image) async {
    // var x =
    //     '/data/user/0/com.example.generatelivecaption/cache/efc0287e-620b-42cc-87db-de7b4000f57e295018784529051407.jpg';
    print(image);
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
      var response = await http.Response.fromStream(streamedResponse);

      Map<String, dynamic> responseData = {};
      responseData = json.decode(response.body);

      return responseData;
    } catch (e) {
      return {};
    }
  }

  Future parseResponse(var response) async {
    String r = '';
    var predictions = response['predictions'];
    if (predictions != null) {
      for (var prediction in predictions) {
        var caption = prediction['caption'];
        String finalCaption = caption.toString().capitalize();
        // var probability = prediction['probability'];
        r = r + '$finalCaption. \n\n';
      }
      final imageId = DateTime.now().microsecondsSinceEpoch;

      final imagesRef = storageRef.child('images/$imageId');
      try {
        await imagesRef.putFile(_image);
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
      setState(() {
        _isLoadingResult = false;
        resultText = r;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.004, 1],
              colors: [Color(0x11232526), Color(0xFF232526)]),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              const Text(
                'text generator',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
              const Text(
                'image to text generator',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height - 250,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7),
                    ]),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: _loading
                          ? SizedBox(
                              width: 500,
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Material(
                                      color: Colors.transparent,
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.hardEdge,
                                      child: IconButton(
                                        iconSize: 32,
                                        icon: const Icon(Icons.history),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  History(deviceId: deviceId),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Image.asset(
                                      'assets/notepad.png',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const GnerateLiveCaptions()));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                180,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 17),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF56ab2f),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'Live Camera',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          // onTap: () => Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             Cameraroll())),
                                          onTap: pickgalleryimage,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                180,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 17),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF56ab2f),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'Camera Roll',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: pickimage,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                180,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 17),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF56ab2f),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'Take a Photo',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 200,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _loading = true;
                                              _isLoadingResult = true;
                                              resultText =
                                                  'Fetching Response...';
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                          ),
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              205,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              _image,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _isLoadingResult
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          resultText,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
