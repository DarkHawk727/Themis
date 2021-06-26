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
  
  
  static isSelected(String tag) => selectedTags.contains(tag);
  static tapTag(tag, selected) {
    selectedTags.remove(tag);
    if(selected) selectedTags.add(tag);
    _notify();
  }

}