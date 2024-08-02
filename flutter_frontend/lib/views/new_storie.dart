import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_button.dart';
import 'package:image_picker/image_picker.dart';

class NewStory extends StatefulWidget {
  const NewStory({super.key});

  @override
  State<NewStory> createState() => _NewStoryState();
}

class _NewStoryState extends State<NewStory> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _createStory() async {
    // if (_imageFile == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please provide an image')),
    //   );
    //   return;
    // }

    // setState(() {
    //   _isLoading = true;
    // });

    // try {
    //   User? user = FirebaseAuth.instance.currentUser;
    //   if (user == null) {
    //     throw Exception('User not authenticated');
    //   }

    //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    //   Reference storageRef = FirebaseStorage.instance
    //       .ref()
    //       .child('stories')
    //       .child(user.uid)
    //       .child(fileName);
    //   await storageRef.putFile(_imageFile!);
    //   String imageUrl = await storageRef.getDownloadURL();

    //   DocumentSnapshot<Map<String, dynamic>> userInfo = await FirebaseFirestore
    //       .instance
    //       .collection("users")
    //       .doc(user.uid)
    //       .get();

    //   final PaletteGenerator paletteGenerator =
    //       await PaletteGenerator.fromImageProvider(
    //     CachedNetworkImageProvider(imageUrl),
    //   );
    //   final Color backgroundColor =
    //       paletteGenerator.dominantColor?.color ?? Colors.black;

    //   await FirebaseFirestore.instance.collection('stories').add({
    //     'userId': user.uid,
    //     'username': userInfo.data()?['username'],
    //     'profileImg': userInfo.data()?['profileImg'],
    //     'image_url': imageUrl,
    //     'timestamp': FieldValue.serverTimestamp(),
    //     'backgroundColor': backgroundColor.toString(),
    //   });

    //   // ignore: use_build_context_synchronously
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Storie created successfully')),
    //   );

    //   // ignore: use_build_context_synchronously
    //   Navigator.pop(context);
    //   // ignore: use_build_context_synchronously
    //   Navigator.pop(context);
    // } catch (e) {
    //   // ignore: use_build_context_synchronously
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error creating story: $e')),
    //   );
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text('Create New Storie'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _imageFile != null ? Image.file(_imageFile!) : const Text(''),
              const SizedBox(height: 16.0),
              MyButton(onTap: _pickImage, text: "Upload Image"),
              const SizedBox(height: 16.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(onTap: _createStory, text: "Share"),
            ],
          ),
        ),
      ),
    );
  }
}
