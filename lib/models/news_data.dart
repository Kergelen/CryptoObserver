class NewsData {
  final String? id;
  final List<String>? searchKeyWords;
  final int? feedDate;
  final String? source;
  final String? title;
  final String? sourceLink;
  final bool? isFeatured;
  final String? imgUrl;
  final Map<String, int>? reactionsCount;
  final List<dynamic>? reactions;
  final String? shareURL;
  final List<String>? relatedCoins;
  final bool? content;
  final String? link;
  final bool? bigImg;
  final String? description;
  final List<dynamic>? coins;

  NewsData({
    required this.id,
    required this.searchKeyWords,
    required this.feedDate,
    required this.source,
    required this.title,
    required this.sourceLink,
    required this.isFeatured,
    required this.imgUrl,
    required this.reactionsCount,
    required this.reactions,
    required this.shareURL,
    required this.relatedCoins,
    required this.content,
    required this.link,
    required this.bigImg,
    required this.description,
    required this.coins,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      id: json['id'],
      searchKeyWords: json['searchKeyWords'] != null ? List<String>.from(json['searchKeyWords']) : null,
      feedDate: json['feedDate'],
      source: json['source'],
      title: json['title'],
      sourceLink: json['sourceLink'],
      isFeatured: json['isFeatured'],
      imgUrl: json['imgUrl'],
      reactionsCount: json['reactionsCount'] != null ? Map<String, int>.from(json['reactionsCount']) : null,
      reactions: json['reactions'],
      shareURL: json['shareURL'],
      relatedCoins: json['relatedCoins'] != null ? List<String>.from(json['relatedCoins']) : null,
      content: json['content'],
      link: json['link'],
      bigImg: json['bigImg'],
      description: json['description'],
      coins: json['coins'],
    );
  }
}
