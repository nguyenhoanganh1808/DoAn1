import 'dart:math';

import 'package:flutter/material.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Guide'),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              'Live Camera',
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textScaleFactor: ScaleSize.textScaleFactor(context),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              textAlign: TextAlign.justify,
              textScaleFactor: ScaleSize.textScaleFactor(context),
              const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 1: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Select the "Live Camera" button to open the camera directly from your mobile device, and live descriptions will be generated directly below the camera frame.',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Camera Roll',
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textScaleFactor: ScaleSize.textScaleFactor(context),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              textAlign: TextAlign.justify,
              textScaleFactor: ScaleSize.textScaleFactor(context),
              const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 1: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Select the "Camera Roll" button to open the photo library of your mobile device.',
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              textScaleFactor: ScaleSize.textScaleFactor(context),
              textAlign: TextAlign.justify,
              const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 2: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Choose a photo for which you want to generate a description, and the result of that photo along with its descriptions will be displayed on the screen.',
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Take a Photo',
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textScaleFactor: ScaleSize.textScaleFactor(context),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              textScaleFactor: ScaleSize.textScaleFactor(context),
              textAlign: TextAlign.justify,
              const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 1: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Select the "Take a Photo" button to open the camera of your mobile device.',
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              textScaleFactor: ScaleSize.textScaleFactor(context),
              textAlign: TextAlign.justify,
              const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 2: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Capture a photo for which you want to generate a description.',
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              textScaleFactor: ScaleSize.textScaleFactor(context),
              textAlign: TextAlign.justify,
              const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 3: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Select the "Accept" (checkmark) button to generate descriptions for the captured photo, and the result of the photo along with its descriptions will be displayed on the screen.',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
