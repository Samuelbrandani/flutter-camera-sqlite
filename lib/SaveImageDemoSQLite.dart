import 'package:camera_sqlite/DAO/Sqlite/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'Models/Photo.dart';
import 'dart:async';

class SaveImageDemoSQLite extends StatefulWidget {
  SaveImageDemoSQLite() : super();
  final String title = "Flutter Save Image";

  @override
  _SaveImageDemoSQLiteState createState() => _SaveImageDemoSQLiteState();
}

class _SaveImageDemoSQLiteState extends State<SaveImageDemoSQLite> {
  //
  Future<File> imageFile;
  Image image;
  DBHelper dbHelper;
  List<Photo> images;

  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper = new DBHelper();
    refreshImages();
  }

  refreshImages() {
    dbHelper.getPhotos().then((imgs) {
      print(imgs[0].photoName);
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  _takePhoto() {
    ImagePicker.pickImage(source: ImageSource.camera)
        .then((File recordedImage) async {
      if (recordedImage != null && recordedImage.path != null) {
        await GallerySaver.saveImage(recordedImage.path);
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String encoded = stringToBase64.encode(recordedImage.path);
        Photo photo = Photo(id: timestamp, photoName: encoded);
        await dbHelper.save(photo);
        await refreshImages();
      }
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          if (photo.photoName != null) {
            Codec<String, String> stringToBase64 = utf8.fuse(base64);
            String decoded = stringToBase64.decode(photo.photoName);
            return Image.file(File(decoded));
          } else
            return Container(
              child: Text("img vazia"),
            );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: _takePhoto,
      ),
    );
  }
}
