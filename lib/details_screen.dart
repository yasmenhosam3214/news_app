import 'package:flutter/material.dart';

import 'models/article_model.dart';

class DetailsScreen extends StatelessWidget {
  final Article article;

  const DetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    DateTime? publishedDate = article.publishedAt != null
        ? DateTime.tryParse(article.publishedAt!)
        : null;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${article.title}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "${article.description}",
                  style: TextStyle(
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  "By : ${article.author}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  "${publishedDate!.toLocal()}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
