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

  @override
  void initState() {
    super.initState();
    isLiked = false; // initially not liked, could be updated per user later
    likesCount = widget.post.likes;
  }

  void _toggleLike() async {
    setState(() {
      if (isLiked) {
        likesCount -= 1;
      } else {
        likesCount += 1;
      }
      isLiked = !isLiked;
    });

    // Firestore update
    if (isLiked) {
      await widget.onLike();
    } else {
      await widget.onUnlike();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.imageUrl.isNotEmpty)
            Image.network(
              widget.post.imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.title.isNotEmpty)
                  Text(widget.post.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                if (widget.post.description.isNotEmpty)
                  Text(widget.post.description),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
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
          ),
        ],
      ),
    );
  }
}
