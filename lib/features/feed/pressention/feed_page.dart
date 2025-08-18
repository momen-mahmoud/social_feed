import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_feed/features/feed/pressention/widgets/post_card.dart';
import 'package:social_feed/features/feed/pressention/widgets/post_service.dart';
import 'package:social_feed/features/feed/pressention/widgets/users_section.dart';

import '../data/post_model.dart';



class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.inbox),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.navicon),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            'Connect',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Suggested',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: double.infinity,
                height: 140,
                child: SuggestedUsersRow(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Posts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<List<Post>>(
                  stream: _firestoreService.getPosts(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());

                    final posts = snapshot.data!;
                    if (posts.isEmpty) return const Center(child: Text('No posts available.'));

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(
                          post: post,
                          onLike: () => _firestoreService.likePost(post),
                          onUnlike: () => _firestoreService.unlikePost(post),
                        );
                      },
                    );
                  },
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}
