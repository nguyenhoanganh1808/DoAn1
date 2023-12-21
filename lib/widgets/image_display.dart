import 'dart:math';

import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String resultText;
  final String imageUrl;
  const ImageDisplay(
      {super.key, required this.resultText, required this.imageUrl});

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
              Text(
                'text generator',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
              Text(
                'image to text generator',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textScaleFactor: ScaleSize.textScaleFactor(context),
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
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                    ),
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 205,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              resultText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
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

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
