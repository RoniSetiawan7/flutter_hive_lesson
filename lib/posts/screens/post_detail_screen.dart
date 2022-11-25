import 'package:flutter/material.dart';
import 'package:hive_lesson/posts/models/post.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(post.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                post.content,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Author : ${post.author}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
