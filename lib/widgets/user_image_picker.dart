import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onImagePick});

  final void Function(File pickedImage) onImagePick;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    _pickedImageFile = File(pickedImage.path);
    widget.onImagePick(_pickedImageFile!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          child: _pickedImageFile == null
              ? Icon(
                  Icons.person,
                  size: 45,
                  color: Colors.white,
                )
              : null,
        ),
        SizedBox(height: 8),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
