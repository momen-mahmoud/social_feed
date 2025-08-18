import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
   int likes;
  final String author;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.likes,
    required this.author,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      likes: data['likes'] ?? 0,
      author: data['author'] ?? '',
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'likes': likes,
      'author': author,
    };
  }
}
