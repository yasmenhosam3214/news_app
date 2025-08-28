import 'package:flutter/material.dart';
import 'package:news_app/widgets/list_item.dart';

import 'api/api_service.dart';
import 'models/article_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<String> titles = ["Tesla", "Apple", "SpaceX", "Bitcoin"];
  int selectedIndex = 0;

  bool showSearch = false;
  String searchQuery = "";

  List<Article> articles = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  
  @override
  void initState() {
    super.initState();
    _fetchArticles();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _fetchArticles();
      }
    });
  }

  Future<void> _fetchArticles({bool reset = false}) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    if (reset) {
      setState(() {
        currentPage = 1;
        articles.clear();
        hasMore = true;
      });
    }

    final query = showSearch && searchQuery.isNotEmpty
        ? searchQuery
        : titles[selectedIndex];

    final newArticles = await _apiService.getArticlesPagination(
      query,
      page: currentPage,
    );

    setState(() {
      if (newArticles.isEmpty) {
        hasMore = false;
      } else {
        currentPage++;
        articles.addAll(newArticles);
      }
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: showSearch
            ? TextField(
                autofocus: true,
                onSubmitted: (value) {
                  searchQuery = value;
                  _fetchArticles(reset: true);
                },
                onChanged: (value) => searchQuery = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              )
            : const Text(
                "General",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.list_rounded, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showSearch = !showSearch;
                searchQuery = "";
              });
              _fetchArticles(reset: true);
            },
            icon: Icon(
              showSearch ? Icons.close : Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(titles.length, (index) {
                final isSelected = index == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ChoiceChip(
                    label: Text(
                      titles[index],
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => selectedIndex = index);
                      _fetchArticles(reset: true);
                    },
                    selectedColor: Colors.white,
                    backgroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white70),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: articles.isEmpty && !isLoading
                ? const Center(
                    child: Text(
                      "No articles found",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: articles.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == articles.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return ListItem(article: articles[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
