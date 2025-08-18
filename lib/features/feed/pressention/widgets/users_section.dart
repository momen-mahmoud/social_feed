import 'package:flutter/material.dart';

import '../../data/users_model.dart';

class SuggestedUsersRow extends StatelessWidget {
  const SuggestedUsersRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(7)
        ),
        SizedBox(
          height: 110,
          child: FutureBuilder<List<SuggestedUser>>(
            future: SuggestedService.fetch(limit: 10),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Failed to load suggestions: ${snap.error}'),
                );
              }
              final users = snap.data!;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(width: 4),
                itemBuilder: (context, i) {
                  final u = users[i];
                  return SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(u.avatarUrl),
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(height: 6),
                        Text(
                          u.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          u.handle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
