import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'widgets/fab.dart';
import 'widgets/nav_bar.dart';
import 'widgets/post_card.dart';
import 'widgets/post_service.dart';
import 'widgets/users_section.dart';
import '../data/post_model.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741', // test AdMob ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return _buildFeedContent();
      case 1:
        return const Center(child: Text('People Page'));
      case 2:
        return const Center(child: Text('Notifications Page'));
      case 3:
        return const Center(child: Text('Profile Page'));
      default:
        return _buildFeedContent();
    }
  }

  Widget _buildFeedContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Suggested', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            const SizedBox(height: 140, width: double.infinity, child: SuggestedUsersRow()),
            const SizedBox(height: 5),
            if (_isAdLoaded)
              SizedBox(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            const SizedBox(height: 12),
            const Text('Posts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: StreamBuilder<List<Post>>(
                  stream: _firestoreService.getPosts(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Connect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        leading: IconButton(icon: const Icon(FontAwesomeIcons.bars), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.inbox),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: CreatePostButton(onPressed: () => Navigator.pushNamed(context, '/post')),
    );
  }
}
