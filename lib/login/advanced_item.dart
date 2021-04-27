class AdvancedItem {

  String username;
  int maxChars;

  AdvancedItem(this.username, this.maxChars);

  factory AdvancedItem.fromJson(dynamic json) {
    return AdvancedItem(json['username'] as String, json['max_len'] as int);
  }
}