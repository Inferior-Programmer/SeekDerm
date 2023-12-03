import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomImageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final String imagePath;

  const CustomImageButton({
    required this.onPressed,
    required this.buttonText,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Set max width for the button
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(buttonText),
            Padding(
              padding: EdgeInsets.all(20.0), // Adjust the padding as needed
              child: SizedBox(
                width: 0.50 * (MediaQuery.of(context).size.width - 20.0), // Adjust for padding
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover, // Adjust the BoxFit property as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}