import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:tuan2/models/photo_model.dart';
import 'package:tuan2/components/photo_list.dart';

class PhotoScreen extends StatelessWidget {
  final String albumId;
  const PhotoScreen({Key? key, required this.albumId}) : super(key: key);

  Future<List<Photo>> fetchPhotos(http.Client client) async {
    final response =
        await client.get(Uri.parse('https://jsonplaceholder.typicode.com/photos?albumId=$albumId'));
    return compute(parsePhotos, response.body);
  }

  List<Photo> parsePhotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Photo>>(
      future: fetchPhotos(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot);
          return const Center(
            child: Text('An error occurred while fetching'),
          );
        } else if (snapshot.hasData) {
          return PhotosList(photos: snapshot.data!);
          // return snapshot.data.map((e) => PhotoListTile(e)).toList(),
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
