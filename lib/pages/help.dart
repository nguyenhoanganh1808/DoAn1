import 'package:flutter/material.dart';

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
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              'Live Camera',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text.rich(
              textAlign: TextAlign.justify,
              TextSpan(
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
                        'Select the "Live Camera" button to open the camera directly from your mobile device, and live descriptions will be generated directly below the camera frame.',
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Camera Roll',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text.rich(
              textAlign: TextAlign.justify,
              TextSpan(
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
            SizedBox(
              height: 5,
            ),
            Text.rich(
              textAlign: TextAlign.justify,
              TextSpan(
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
            SizedBox(
              height: 5,
            ),
            Text(
              'Take a Photo',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text.rich(
              textAlign: TextAlign.justify,
              TextSpan(
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
            SizedBox(
              height: 5,
            ),
            Text.rich(
              textAlign: TextAlign.justify,
              TextSpan(
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
            SizedBox(
              height: 5,
            ),
            Text.rich(
              textAlign: TextAlign.justify,
              TextSpan(
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
