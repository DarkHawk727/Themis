import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'average_color.dart';

class Data {
  static String _apiUrl = 'http://127.0.0.1:5000';
  static List<Function> listeners = [];
  static addListener(Function update) => listeners.add(update);
  static _notify() => listeners.forEach((e) => e());

  static LoadingState _loadingState = LoadingState.waiting;
  static LoadingState get loadingState => _loadingState;
  static set loadingState(LoadingState newState) {
    _loadingState = newState;
    if(newState == LoadingState.loading) articles = [];
    _notify();
  }

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

    loadData(response);
  }
  
  static getToday() async {
    loadingState = LoadingState.loading;
     http.Response response = await http.get(
      Uri.parse(_apiUrl + '/today'),
    );

    loadData(response);
  }

  static loadData(response) {
    List<dynamic> summaries = jsonDecode(response.body)['articles'];
    if(summaries.isNotEmpty) {
      summaries.forEach((e) => addJsonToArticles(e));
      loadingState = LoadingState.found;
    } else {
      loadingState = LoadingState.none;
    }
  }

  static addJsonToArticles(data) async {
    News newsArticle = News.fromJson(data);
    articles.add(newsArticle);
  }
}

class News {
  String headline = '';
  String content = '';
  String image = '';
  double bias = 0.5;
  double subjectivity = 0.5;
  double polarity = 0.5;
  int readingLevel = 50;
  Map<String, Color> avgColor = {};
  List<String> sources = [];
  
  News.fromJson(json) {
    this.headline = json['headline'] ?? '';
    this.image = json['image'] ?? '';
    if(this.image == '') this.image = 'https://smartcdn.prod.postmedia.digital/nationalpost/wp-content/uploads/2021/06/Anthony-Rota-1-33.png?quality=90&strip=all&w=564&type=webp';
    //this.avgColor = avgColor;
    this.sources = [json['source']] ?? [];
    this.content = json['summary'] ?? '';
    this.polarity = json['polarity'] ?? 0;
    this.subjectivity = json['subjectivity'] ?? 0.5;
    this.readingLevel = json['readingLevel'] ?? 50;
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
  found
}