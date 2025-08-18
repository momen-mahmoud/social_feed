import 'package:flutter/material.dart';

class CreatePostButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreatePostButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add, size: 28),
      tooltip: 'Create Post',
    );
  }
}
