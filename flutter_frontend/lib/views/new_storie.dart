import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_button.dart';
import 'package:flutter_frontend/models/story.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await Story.createStory(authService, _imageFile!);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story created successfully')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      if (e is Exception) {
        var message = e.toString();
        if (message.contains('isStory')) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('You can only share one story per day')),
          );
        } else if (message.contains('isUknown')) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uknown user')),
          );
        }
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating story: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
