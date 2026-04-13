import 'package:flutter/material.dart';

/// A widget that displays a single post, similar to a Facebook post.
class PostCard extends StatelessWidget {
  final String username;
  final String userAvatarUrl;
  final String timeAgo;
  final String postText;
  final String? postImageUrl;

  const PostCard({
    super.key,
    required this.username,
    required this.userAvatarUrl,
    required this.timeAgo,
    required this.postText,
    this.postImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(),
          _buildPostContent(context),
          if (postImageUrl != null) _buildPostImage(),
          const Divider(height: 1.0),
          _buildPostActions(), // Dito nakalagay ang mga buttons
        ],
      ),
    );
  }

  /// Builds the header of the post with user info.
  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(userAvatarUrl),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /// Builds the text content of the post.
  Widget _buildPostContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Text(postText),
    );
  }

  /// Builds the image section of the post.
  Widget _buildPostImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Image.network(
        postImageUrl!,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Builds the action buttons (Like, Comment, Share, Subscribe).
  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(icon: Icons.thumb_up_alt_outlined, label: 'Like'),
          _buildActionButton(icon: Icons.comment_outlined, label: 'Comment'),
          _buildActionButton(icon: Icons.share_outlined, label: 'Share'),
          // --- ITO ANG BAGONG DAGDAG ---
          _buildActionButton(icon: Icons.subscriptions_outlined, label: 'Subscribe'),
        ],
      ),
    );
  }

  /// Helper widget to create a single action button.
  Widget _buildActionButton({required IconData icon, required String label}) {
    return Expanded(
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.grey[700]),
        label: Text(
          label,
          style: TextStyle(color: Colors.grey[800]),
        ),
      ),
    );
  }
}