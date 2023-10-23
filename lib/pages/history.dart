import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generatelivecaption/widgets/image_display.dart';

class History extends StatelessWidget {
  final String deviceId;

  const History({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    CollectionReference predictsRef =
        firestore.collection('devices').doc(deviceId).collection('predicts');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.black,
        ),
        title: const Text('History'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: predictsRef.orderBy('time', descending: true).get(),
        builder: (context, snapshot) {
          print(deviceId);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 20,
              ),
              snapshot.hasData
                  ? Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          var itemData =
                              data[index].data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => ImageDisplay(
                                      resultText: itemData['predicts']!,
                                      imageUrl: itemData['imageUrl']!),
                                ),
                              );
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.blue),
                              ),
                              margin: const EdgeInsets.all(20),
                              child: FadeInImage.assetNetwork(
                                image: itemData['imageUrl']!,
                                placeholder: 'assets/loading.gif',
                                placeholderCacheWidth: 20,
                                placeholderCacheHeight: 20,
                              ),
                            ),
                          );
                        },
                        itemCount: data.length,
                      ),
                    )
                  : const Text('History Emplty'),
            ],
          );
        },
      ),
    );
  }
}
