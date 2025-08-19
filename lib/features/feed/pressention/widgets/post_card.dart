import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Future<void> Function() onLike;
  final Future<void> Function() onUnlike;

  const PostCard({
    required this.post,
    required this.onLike,
    required this.onUnlike,
    super.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isLiked;
  late int likesCount;
  bool showHeart = false;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    isLiked = false;
    likesCount = widget.post.likes;
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() async {
    setState(() {
      if (isLiked) {
        likesCount -= 1;
      } else {
        likesCount += 1;
        showHeart = true;
      }
      isLiked = !isLiked;
    });

    if (isLiked) {
      await widget.onLike();
    } else {
      await widget.onUnlike();
    }

    if (showHeart) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => showHeart = false);
      });
    }
  }

  void _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = Comment(userId: 'user1', text: text);

    setState(() {
      widget.post.comments.add(newComment);
      _commentController.clear();
    });

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post.id)
        .update({
      'comments': FieldValue.arrayUnion([newComment.toMap()])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.post.imageUrl.isNotEmpty)
                GestureDetector(
                  onDoubleTap: _toggleLike,
                  child: Image.network(
                    widget.post.imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.post.title.isNotEmpty)
                      Text(
                        widget.post.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 6),
                    if (widget.post.description.isNotEmpty)
                      Text(widget.post.description),
                    const SizedBox(height: 8),

                    // Likes row
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: isLiked ? Colors.red : Colors.black,
                          ),
                          onPressed: _toggleLike,
                        ),
                        Text('$likesCount likes'),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Comments list
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.post.comments
                          .map(
                            (c) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            c.text,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      )
                          .toList(),
                    ),

                    const SizedBox(height: 6),

                    // Add comment input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _addComment,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Animated heart
          if (showHeart)
            AnimatedScale(
              scale: showHeart ? 1.5 : 0,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              child: const Icon(
                FontAwesomeIcons.solidHeart,
                color: Colors.redAccent,
                size: 100,
              ),
            ),
        ],
      ),
    );
  }
}
