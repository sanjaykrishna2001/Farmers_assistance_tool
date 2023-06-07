import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Detection extends StatefulWidget {
  final String phoneNo;
  final int currentIndex;
  const Detection({Key? key, required this.currentIndex, required this.phoneNo})
      : super(key: key);

  @override
  State<Detection> createState() => _DetectionState(currentIndex, phoneNo);
}

class _DetectionState extends State<Detection> {
  late String phoneNo;
  late int currentIndex;
  File? _imageFile;

  _DetectionState(this.currentIndex, this.phoneNo);

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      } else {
        _imageFile = null;
      }
    });
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Image.file(
            _imageFile!,
            fit: BoxFit.cover,
          ),
          IconButton(
            onPressed: _removeImage,
            icon: Icon(Icons.close),
          ),
        ],
      );
    } else {
      return const Text('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(child: _buildImagePreview()),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Select from Gallery'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Take a Photo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
