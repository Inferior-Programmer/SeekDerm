import 'dart:async';
import 'dart:io';
import 'generalcomponents/AppBar.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'ImagePredictionLoader.dart';
import 'model/callerfunctions.dart';




const String queryPredict = '''
query(\$val: String!){
  predictions(val: \$val)
}
''';

// A screen that allows users to take a picture using a given camera.
class CameraWidget extends StatefulWidget {
  const CameraWidget({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              Text(
                'Take a picture for skin disease prediction',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ Colors.white,
              const Color(0xFFFDA43B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: CameraPreview(_controller),
            ),
            SizedBox(height: 16),]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if (!mounted) return;
            final bytes = await image.readAsBytes();
            final strings = base64Encode(bytes);

            Map<String, dynamic> variables = {
              'val': strings,
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
            
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
