class Data {
  static List<Function> listeners = [];
  static addListener(Function update) => listeners.add(update);
  static _notify() => listeners.forEach((e) => e());

  static List<String> availableTags = 
    [
      'Elections',
      'Federal',
      'Environment',
      'Debates'
    ];
  static List<String> selectedTags = [];

  static List<News> _articles = [];
  static set articles(List<News> artcls){
    _articles = artcls;
    _notify();
  }
  static get articles => _articles;

  static isSelected(String tag) => selectedTags.contains(tag);
  static tapTag(tag, selected) {
    selectedTags.remove(tag);
    if(selected) selectedTags.add(tag);
    _notify();
  }
}

class News {
  String headline = '';
  String content = '';
  String image = '';
  double bias = 0.5;
  double subjectivity = 0.5;
  double polarity = 0.5;
  List<String> sources = [];
}