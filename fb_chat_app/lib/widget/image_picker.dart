import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) imgPickerFn;
  UserImagePicker(this.imgPickerFn);
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<UserImagePicker> {
  File _selectedImageFile;
  void _pickImage() async {
    final selectedImage = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 200);
    if (selectedImage != null) {
      setState(() {
        _selectedImageFile = File(selectedImage.path);
      });
      widget.imgPickerFn(_selectedImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: _selectedImageFile != null
                ? FileImage(_selectedImageFile)
                : null,
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          FlatButton.icon(
            onPressed: () => _pickImage(),
            icon: Icon(
              Icons.image,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Select image',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
