class ArticlesModel {
  final String title;
  final String content;
  final String poster;

  ArticlesModel({
    required this.title,
    required this.content,
    required this.poster,
  });

  factory ArticlesModel.fromJSON(Map<String, dynamic> json) {
    return ArticlesModel(
      title: json['articleHeading'],
      content: json['articleDescription'],
      poster: json['articleImage'] ?? '',
    );
  }
}
