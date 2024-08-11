import 'package:flutter/material.dart';

class ResourceLibraryPage extends StatelessWidget {
  static const routeName = '/resource_library';

  final List<Resource> resources = [
    Resource(
      title: 'Mindfulness Meditation Guide',
      description: 'A comprehensive guide to mindfulness meditation practices.',
      imageUrl: 'assets/images/happymood.jpeg',
      link: 'https://example.com/meditation-guide',
    ),
    Resource(
      title: 'Understanding Anxiety',
      description: 'An informative article about anxiety and coping mechanisms.',
      imageUrl: 'assets/images/anxious.jpeg',
      link: 'https://example.com/anxiety-article',
    ),
    Resource(
      title: 'Mental Health Apps',
      description: 'A list of recommended mental health apps for daily use.',
      imageUrl: 'assets/images/sadmood.jpeg',
      link: 'https://example.com/mental-health-apps',
    ),
      Resource(
      title: 'Coping Strategies for Stress',
      description: 'Explore various strategies to manage and reduce stress effectively.',
      imageUrl: 'assets/images/user_avatar.jpg',
      link: 'https://example.com/coping-strategies',
    ),
    Resource(
      title: 'Building Resilience',
      description: 'Learn how to build resilience and handle life’s challenges better.',
      imageUrl: 'assets/images/ai_avatar.jpeg',
      link: 'https://example.com/building-resilience',
    ),
  ];

  ResourceLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Library'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final resource = resources[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () {
                  _launchURL(resource.link);
                },
                child: Row(
                  children: [
                    Image.asset(
                      resource.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resource.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              resource.description,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _launchURL(String url) {
    // Add logic to launch the URL
    // Use url_launcher package to handle the URL launch
    // final Uri uri = Uri.parse(url);
    // launch(uri.toString());
  }
}

class Resource {
  final String title;
  final String description;
  final String imageUrl;
  final String link;

  Resource({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
  });
}
