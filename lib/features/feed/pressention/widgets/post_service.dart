import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/post_model.dart';

class FirestoreService {
  final _postsRef = FirebaseFirestore.instance.collection('posts');

  Stream<List<Post>> getPosts() {
    return _postsRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  Future<void> likePost(Post post) async {
    // Update locally for instant UI feedback
    post.likes += 1;


    await _postsRef.doc(post.id).update({'likes': post.likes});
  }

  Future<void> unlikePost(Post post) async {
    post.likes -= 1; // local update
    await _postsRef.doc(post.id).update({'likes': post.likes});
  }
}
