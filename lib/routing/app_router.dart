import 'package:flutter/material.dart';
import '../features/auth/pressention/signin_page.dart';
import '../features/auth/pressention/signup_page.dart';
import '../features/feed/pressention/feed_page.dart';
import '../features/feed/pressention/post_screen.dart';


class AppRoutes {
  static const String signUp = '/signup';
  static const String signIn = '/signin';
  static const String feed = '/feed';
  static const String post = '/post';

  static Map<String, WidgetBuilder> routes = {
    signUp: (context) => const SignupPage(),
    signIn: (context) => const SigninPage(),
    feed: (context) =>  FeedPage(),
    post: (context) => const CreatePost(),
  };
}
