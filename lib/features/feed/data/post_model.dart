import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String text;

  Comment({
    required this.userId,
    required this.text,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
    };
  }
}

class Post {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  int likes;
  final String author;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.likes,
    required this.author,
    this.comments = const [],
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    List<Comment> commentsList = [];
    if (data['comments'] != null) {
      commentsList = List<Map<String, dynamic>>.from(data['comments'])
          .map((c) => Comment.fromMap(c))
          .toList();
    }

    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      likes: data['likes'] ?? 0,
      author: data['author'] ?? '',
      comments: commentsList,
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
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }
}
