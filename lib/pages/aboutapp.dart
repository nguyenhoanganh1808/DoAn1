import 'dart:math';

import 'package:flutter/material.dart';
import 'package:generatelivecaption/pages/help.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildTextRow(String title, String detail) {
      return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                detail,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
            ),
          ],
        ),
      );
    }

    TextStyle title =
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    TextStyle normalText = const TextStyle(
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: SafeArea(
            child: Column(
              children: [
                // const Row(
                //   children: [
                //     Icon(
                //       Icons.info_outline_rounded,
                //       size: 40,
                //     ),
                //     Text(
                //       'About App',
                //       style:
                //           TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 104, 234, 154)),
                  height: 180,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'App Name',
                              style: title,
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                            ),
                            Text(
                              'Live Caption Generator',
                              style: normalText,
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Version',
                              style: title,
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Text(
                              '1.0.0',
                              style: normalText,
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                buildTextRow('Description',
                    'AI app using machine learning model to generate live captions from camera feed.'),
                buildTextRow('Developer', 'Nguyễn Hoàng Anh\nNguyễn Thái Bình'),
                buildTextRow('Language', 'English'),
                buildTextRow('Support', 'nguyenthaibinh810@gmail.com'),
                buildTextRow('App Rating', 'update later'),
                buildTextRow('Github',
                    'github.com/nguyenbinh0902\ngithub.com/nguyenhoanganh1808'),
                buildTextRow('Name', 'Show and Tell mmodel'),
                buildTextRow('Paper',
                    'Show and Tell: Lessons learned from the 2015 MSCOCO Image Captioning Challenge'),
                buildTextRow('Published in',
                    'IEEE Transactions on Pattern Analysis and Machine Intelligence.'),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 107, 200, 110),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Help()));
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.question_mark,
                            size: 35,
                          ),
                          Text(
                            'Help',
                            style: title,
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
