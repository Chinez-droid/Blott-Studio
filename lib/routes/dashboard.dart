import 'package:blott/providers/auth_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? firstName; // Change to nullable type
  final ApiService _apiService = ApiService();
  List<NewsItem> _news = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadFirstName();
    _fetchNews();
  }

  Future<void> _loadFirstName() async {
    final name = await AuthPreferences.getFirstName();
    setState(() {
      firstName = name ?? ''; // Use null-aware operator
    });
  }

  Future<void> _fetchNews() async {
    try {
      final news = await _apiService.fetchNews();
      setState(() {
        _news = news;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF05021C),
              height: 115.0,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey ${firstName ?? ''}',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_hasError)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Something went wrong. Please try again later.',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Colors.white),
                      ),
                      child: RefreshIndicator(
                        onRefresh: _fetchNews,
                        color: Colors.white,
                        backgroundColor: const Color(0xFF05021C),
                        strokeWidth: 3,
                        displacement: 50,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _news.length,
                          itemBuilder: (context, index) {
                            final news = _news[index];
                            return GestureDetector(
                              onTap: () => _launchUrl(news.url),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: news.image.isNotEmpty
                                          ? Image.network(news.image,
                                              fit: BoxFit.cover)
                                          : Container(color: Colors.grey[800]),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                news.source,
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.33,
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                              Text(
                                                news.date,
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.33,
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            news.headline,
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2,
                                              color: Colors.white,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
