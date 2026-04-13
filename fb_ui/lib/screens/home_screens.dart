import 'package:fb_ui/screens/profile_screens.dart';
import 'package:fb_ui/screens/login_screen.dart';
import 'package:fb_ui/widget/create_post_bar.dart';
import 'package:fb_ui/widget/post_card.dart';
import 'package:fb_ui/widget/story_reel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String displayName;

  const HomeScreen({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyFeed'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xFF1777F2)),
                    child: Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(displayName: displayName),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          const CreatePostBar(),
          const Divider(thickness: 8.0, color: Color(0xFFF0F2F5)),
          const StoryReel(),
          const Divider(thickness: 8.0, color: Color(0xFFF0F2F5)),
          const PostCard(
            username: 'Juan Dela Cruz',
            userAvatarUrl: 'https://picsum.photos/seed/user_main/100/100',
            timeAgo: 'Just now',
            postText:
            'Finally set up my new Facebook-style app in Flutter! Excited to share updates here.',
            postImageUrl: 'https://picsum.photos/seed/feed1/600/400',
          ),
          const PostCard(
            username: 'College Friends',
            userAvatarUrl: 'https://picsum.photos/seed/user2/100/100',
            timeAgo: '1h',
            postText:
            'Throwback to our last campus event. Can\'t wait to see everyone again soon!',
            postImageUrl: 'https://picsum.photos/seed/feed2/600/400',
          ),
          const PostCard(
            username: 'Tech News PH',
            userAvatarUrl: 'https://picsum.photos/seed/user3/100/100',
            timeAgo: '3h',
            postText:
            'Flutter continues to grow fast in 2026. What are you building today?',
          ),
        ],
      ),
    );
  }
}
