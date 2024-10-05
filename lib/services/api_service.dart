import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://finnhub.io/api/v1';
  final String _apiKey = 'crals9pr01qhk4bqotb0crals9pr01qhk4bqotbg';

  Future<List<NewsItem>> fetchNews() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/news',
        queryParameters: {
          'category': 'general',
          'token': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> newsData = response.data;
        return newsData.map((item) => NewsItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}

class NewsItem {
  final String source;
  final String date;
  final String headline;
  final String image;
  final String url;

  NewsItem({
    required this.source,
    required this.date,
    required this.headline,
    required this.image,
    required this.url,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    final dateFormatter = DateFormat('d MMMM yyyy');
    final dateTime = json['datetime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['datetime'] * 1000)
        : DateTime.now();

    return NewsItem(
      source: json['source'] ?? '',
      date: dateFormatter.format(dateTime),
      headline: json['headline'] ?? '',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
