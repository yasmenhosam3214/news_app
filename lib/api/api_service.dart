import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ApiService {
  static const String _baseUrl = "https://newsapi.org/v2/everything";
  static const String _apiKey = "46591505e46b4bc5b8f731dac69f7776";

  Future<List<Article>> getArticlesPagination(String category,{
    required int page,
    int pageSize = 10,
  }) async {
    final url = Uri.parse(
      '$_baseUrl?q=${category}&from=2025-07-28&sortBy=publishedAt&apiKey=$_apiKey&page=$page&pageSize=$pageSize',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["status"] == "ok") {
        List articlesJson = data["articles"];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception("API error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  }
}
