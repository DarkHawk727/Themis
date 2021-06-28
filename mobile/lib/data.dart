import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'average_color.dart';

class Data {
  static String _apiUrl = 'http://13.233.51.226';
  static List<Function> listeners = [];
  static addListener(Function update) => listeners.add(update);
  static _notify() => listeners.forEach((e) => e());

  static LoadingState _loadingState = LoadingState.waiting;
  static LoadingState get loadingState => _loadingState;
  static set loadingState(LoadingState newState) {
    _loadingState = newState;
    if(newState == LoadingState.loading) articles = [];
    if(newState == LoadingState.home) articles = homePageArticles;
    _notify();
  }

  static List<News> homePageArticles = [];

  static List<String> availableTags = 
    [
      'Health',
      'Business',
      'Technology',
      'Elections'
    ];
  static String selectedTag = '';

  static List<News> _articles = [];
  static set articles(List<News> artcls){
    _articles = artcls;
    _notify();
  }
  static List<News> get articles => _articles;

  static isSelected(String tag) => selectedTag == tag;
  static tapTag(tag, selected) {
    selectedTag = '';
    if(selected) selectedTag = tag;
    if(selected) search(tag);
    if(selectedTag == '') loadingState = LoadingState.home;
    _notify();
  }

  static search(String query) async {
    loadingState = LoadingState.loading;
    http.Response response = await http.post(
      Uri.parse(_apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'query': query,
      }),
    );

    loadData(response, false);
  }
  
  static getToday() async {
    loadingState = LoadingState.loading;
     http.Response response = await http.get(
      Uri.parse(_apiUrl + '/today'),
    );

    loadData(response, true);
  }

  static loadData(response, bool home) {
    try {
      List<dynamic> summaries = jsonDecode(response.body)['articles'];
      if(summaries.isNotEmpty) {
        summaries.forEach((e) => addJsonToArticles(e, home));
        loadingState = LoadingState.found;
      } else {
        loadingState = LoadingState.none;
      }
    } catch (error) {
      print("INTERNAL SEVER ERROR");
      loadingState = LoadingState.none;
    }
  }

  static addJsonToArticles(data, bool home) async {
    News newsArticle = News.fromJson(data);
    articles.add(newsArticle);
    if(home) homePageArticles.add(newsArticle);
  }
}

class News {
  String headline = '';
  String content = '';
  String image = '';
  double bias = 0;
  double subjectivity = 0.5;
  double polarity = 0.5;
  int readingLevel = 50;
  String articleUrl = '';
  Map<String, Color> avgColor = {};
  List<String> sources = [];
  
  News.fromJson(json) {
    this.headline = json['headline'] ?? '';
    this.image = json['image'] ?? '';
    if(this.image == '') this.image = 'https://smartcdn.prod.postmedia.digital/nationalpost/wp-content/uploads/2021/06/Anthony-Rota-1-33.png?quality=90&strip=all&w=564&type=webp';
    //this.avgColor = avgColor;
    this.sources = [json['source']] ?? [];
    String _content = json['summary'].replaceAll(' .', '.') ?? '';
    if(_content[0] == ' ')
    _content = _content.substring(1);
    this.content = _content;
    this.polarity = json['polarity'] ?? 0;
    this.subjectivity = json['subjectivity'] ?? 0.5;
    this.readingLevel = json['readingLevel'] ?? 50;
    this.articleUrl = json['article_url'] ?? '';
    // this.bias = ((((1 - json['political_leaning'] - 0.5) * 2) * json['political_leaning_proba']) + 1) / 2;
    // this.bias = pow(bias, 1.2);
    this.bias = 1.0;
  }

  getAvgColor() async {
    this.avgColor = await AvgColor.getAverageColor(image);
    return avgColor;
  }
}

enum LoadingState {
  none,
  waiting,
  loading,
  home,
  found
}