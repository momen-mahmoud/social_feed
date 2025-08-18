import 'dart:convert';
import 'package:http/http.dart' as http;

class SuggestedUser {
  final int id;
  final String name;
  final String handle;
  final String avatarUrl;

  SuggestedUser({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarUrl,
  });

  factory SuggestedUser.fromDummyJson(Map<String, dynamic> j) {
    final first = (j['firstName'] ?? '').toString();
    final last  = (j['lastName']  ?? '').toString();
    final username = (j['username'] ?? '').toString();
    return SuggestedUser(
      id: j['id'] as int,
      name: '$first $last'.trim(),
      handle: '@$username',
      avatarUrl: (j['image'] ?? '').toString(),
    );
  }
}

class SuggestedService {
  static Future<List<SuggestedUser>> fetch({int limit = 10, int skip = 0}) async {
    final uri = Uri.parse('https://dummyjson.com/users?limit=$limit&skip=$skip');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('DummyJSON error: ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final List users = (body['users'] ?? []) as List;
    return users.map((e) => SuggestedUser.fromDummyJson(e as Map<String, dynamic>)).toList();
  }
}
