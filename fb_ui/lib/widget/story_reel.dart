import 'package:flutter/material.dart';

/// A widget that displays a horizontal, scrollable list of stories.
/// This includes a special card for creating a new story.
class StoryReel extends StatelessWidget {
  const StoryReel({super.key});

  @override
  Widget build(BuildContext context) {
    // A container to give the story reel a specific height and background.
    return Container(
      height: 200.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: ListView.builder(
        // Use a ListView.builder for an efficient, scrollable list.
        scrollDirection: Axis.horizontal, // Make the list scroll left-to-right.
        itemCount: 10, // Example number of stories.
        itemBuilder: (context, index) {
          // The first item is the "Create Story" button.
          if (index == 0) {
            return _buildCreateStoryCard();
          }

          // The rest of the items are the user stories.
          return _buildStoryCard(index);
        },
      ),
    );
  }

  /// Builds the special card for creating a new story.
  Widget _buildCreateStoryCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: 110,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background of the card (user's own picture)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'https://picsum.photos/seed/myprofile/200/300',
                fit: BoxFit.cover,
              ),
            ),
            // White area at the bottom for text
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
                alignment: const Alignment(0, 0.6), // Align text to bottom center
                child: const Text(
                  'Create Story',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // The blue plus icon button
            Positioned(
              left: 35, // Centered horizontally (110 / 2 - 20)
              bottom: 30, // Positioned just above the text area
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4.0),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a card for a single user's story.
  Widget _buildStoryCard(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: 110,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The main story image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'https://picsum.photos/seed/$index/200/300', // Different image for each story
                fit: BoxFit.cover,
              ),
            ),
            // User profile picture in the top-left
            Positioned(
              top: 8.0,
              left: 8.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 3.0),
                ),
                child: CircleAvatar(
                  radius: 18.0,
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/user$index/100/100', // User's profile pic
                  ),
                ),
              ),
            ),
            // User's name at the bottom
            Positioned(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
              child: Text(
                'User $index',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4.0)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}