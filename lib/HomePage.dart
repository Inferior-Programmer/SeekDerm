import 'dart:convert';
import 'package:newproject/generalcomponents/CustomImageButton.dart';
import 'package:camera/camera.dart';
import 'model/callerfunctions.dart';
import 'package:flutter/material.dart';
import 'CameraWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'ImagePredictionLoader.dart';
const double coverHeight = 250;
const double coverWidth = 190;
const double boxHeight = 310;
const double boxWidth = 180;
const int numberOfCharactersPerLine = 25;
const int totalNumberOfCharacters = 100;

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,});

 
  @override
  State<HomePage> createState() => _HomePageState();
}

const String queryPredict = '''
query(\$val: String!){
  predictions(val: \$val)
}
''';

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  var tags = {};
  var loaded = false;

  late TextEditingController _controller;
  var titlesAndId = [];

  void initialCalling(String title) {
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    initialCalling('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getImageAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 256,
        maxWidth: 256,
        imageQuality: 75);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final strings = base64Encode(bytes);
      Map<String, dynamic> variables = {
        "val":  strings
      };

      final result = await graphqlQuery(queryPredict, variables);
            
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImagePredictionLoader(
                  base64Image: strings,
                  predictedValue: result['data']['predictions'],
                ),
              ),
            );
      
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Submission Failed'),
                content: Text('Submission Failed'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      }
  

  

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              const Color(0xFFFDA43B),
            ],
          )),
          child: Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Colors.blue), //choose your own color
          )));
    }

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white,
            const Color(0xFFFDA43B),
          ],
        )),
        child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.

            child: Column(children: [
              CustomImageButton(onPressed: () async{
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraWidget(camera: firstCamera,)),
              );
              }, buttonText: "Diagnose from Camera", imagePath: "https://i.ibb.co/b7PpXqM/SC-living-fda-approves-new-dermatology-camera.jpg"),
              SizedBox(height: 16.0),
              CustomImageButton(onPressed: () {
                getImageAndUpload();
                
              }, buttonText: "Diagnose from Image", imagePath: "https://i.ibb.co/b7PpXqM/SC-living-fda-approves-new-dermatology-camera.jpg")

            ],)));
  }
}
