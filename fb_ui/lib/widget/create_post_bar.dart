import 'package:flutter/material.dart';

/// A widget that simulates the "What's on your mind?" section in Facebook,
/// including the user's avatar and action buttons below.
class CreatePostBar extends StatelessWidget {
  const CreatePostBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0), // No bottom padding here
      child: Column(
        children: [
          // The top row with the avatar and text field
          Row(
            children: [
              // User's profile picture
              const CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/myprofile/100/100'),
              ),
              const SizedBox(width: 12.0),
              // The text input field simulation
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // A light grey background
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('What\'s on your mind?'),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20.0, thickness: 0.5),
          // Action buttons: Live, Photo, Room
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPostOption(
                  icon: Icons.videocam, label: 'Live', color: Colors.red),
              const SizedBox(
                  height: 25, child: VerticalDivider(color: Colors.grey)),
              _buildPostOption(
                  icon: Icons.photo_library,
                  label: 'Photo',
                  color: Colors.green),
              const SizedBox(
                  height: 25, child: VerticalDivider(color: Colors.grey)),
              _buildPostOption(
                  icon: Icons.video_call,
                  label: 'Room',
                  color: Colors.purple),
            ],
          ),
          const SizedBox(height: 8.0), // Padding at the bottom
        ],
      ),
    );
  }

  /// Helper method to build the Live, Photo, and Room buttons.
  Widget _buildPostOption(
      {required IconData icon, required String label, required Color color}) {
    return Expanded(
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}