import 'package:flutter/material.dart';
import 'package:social_feed/features/feed/pressention/widgets/dotted_border.dart';
import 'package:social_feed/features/feed/pressention/widgets/textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  File? image;
  final ImagePicker picker = ImagePicker();

  // Example hashtags
  final List<String> hashtags = ["#Flutter", "#Coding", "#Tech", "#Trending","#JSON","#Dart","#Firebase","#Flutter","#Coding", "#Test", "#Data"];
  String? selectedHashtag;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        debugPrint("No image selected.");
      }
    });
  }

  Future<void> publishPost() async {
    if (title.text.isEmpty || description.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title & description required!")),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      String? imageUrl;
      if (image != null) {
        imageUrl = image!.path; // ⚠️ This is just a local path, not a real URL
      }

      await FirebaseFirestore.instance.collection("posts").add({
        "title": title.text,
        "description": description.text,
        "imageURL": imageUrl ?? "",
        "hashtag": selectedHashtag ?? "",
        "userId": user?.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error saving post: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomTextFormField(controller: title, hint: 'Title'),
              const SizedBox(height: 20),

              TextFormField(
                controller: description,
                maxLines: 5,
                decoration: InputDecoration(
                  fillColor: Colors.blue[50],
                  filled: true,
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.blue[200]),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              UploadImageCard(
                image: image,
                onUpload: getImage,
                onRemove: () {
                  setState(() {
                    image = null; // reset to dotted card
                  });
                },
              ),



              const SizedBox(height: 20),

              // Trending hashtags
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hashtags.length,
                  itemBuilder: (context, index) {
                    final tag = hashtags[index];
                    final isSelected = selectedHashtag == tag;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            color: Colors.black, // black text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.grey[400], // darker grey when selected
                        backgroundColor: Colors.grey[200], // normal grey
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // rounded like button
                        ),
                        onSelected: (val) {
                          setState(() {
                            selectedHashtag = val ? tag : null;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 120),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B57D0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: publishPost,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Publish",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
