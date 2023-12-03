import 'dart:convert';
import 'package:flutter/material.dart';
import 'generalcomponents/AppBar.dart';



class ImagePredictionLoader extends StatelessWidget {
  final String base64Image;
  final String predictedValue;

  // Constructor to receive the base64-encoded image as a parameter
  ImagePredictionLoader({required this.base64Image, required this.predictedValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white,
              Color.fromARGB(255, 253, 164, 59),],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                'Predicted Skin Disease',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.memory(
                  base64Decode(base64Image),
                  fit: BoxFit.contain, // Ensure the image fits within the container without distorting its aspect ratio
                )),
              SizedBox(height: 16),
              Text(
                predictedValue,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}