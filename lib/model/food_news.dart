class FoodNews {
  final String status;
  final int totalResults;
  final List<NewsArticle> results;

  FoodNews({
    required this.status,
    required this.totalResults,
    required this.results,
  });

  factory FoodNews.fromJson(Map<String, dynamic> json) {
    return FoodNews(
      status: json['status'] as String,
      totalResults: json['totalResults'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

class NewsArticle {
  final String? articleId;
  final String? title;
  final String? link;
  final List<String?> keywords;
  final List<String?> creator;
  final String? videoUrl;
  final String? description;
  final String? content;
  final String? pubDate;
  final String? pubDateTZ;
  final String? imageUrl;
  final String? sourceId;
  final int sourcePriority;
  final String? sourceName;
  final String? sourceUrl;
  final String? sourceIcon;
  final String? language;
  final List<String?> country;
  final List<String?> category;
  final String? aiTag;
  final String? sentiment;
  final String? sentimentStats;
  final String? aiRegion;
  final String? aiOrg;
  final bool duplicate;

  NewsArticle({
    required this.articleId,
    required this.title,
    required this.link,
    required this.keywords,
    required this.creator,
    this.videoUrl,
    required this.description,
    required this.content,
    required this.pubDate,
    required this.pubDateTZ,
    required this.imageUrl,
    required this.sourceId,
    required this.sourcePriority,
    required this.sourceName,
    required this.sourceUrl,
    this.sourceIcon,
    required this.language,
    required this.country,
    required this.category,
    required this.aiTag,
    required this.sentiment,
    required this.sentimentStats,
    required this.aiRegion,
    required this.aiOrg,
    required this.duplicate,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      articleId: json['article_id'] as String?,
      title: json['title'] as String?,
      link: json['link'] as String?,
      keywords: List<String>.from(json['keywords'] ?? []),
      creator: List<String>.from(json['creator'] ?? []),
      videoUrl: json['video_url'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      pubDate: json['pubDate'] as String?,
      pubDateTZ: json['pubDateTZ'] as String?,
      imageUrl: json['image_url'] as String?,
      sourceId: json['source_id'] as String?,
      sourcePriority: json['source_priority'] as int,
      sourceName: json['source_name'] as String?,
      sourceUrl: json['source_url'] as String?,
      sourceIcon: json['source_icon'] as String?,
      language: json['language'] as String?,
      country: List<String>.from(json['country'] ?? []),
      category: List<String>.from(json['category'] ?? []),
      aiTag: json['ai_tag'] as String?,
      sentiment: json['sentiment'] as String?,
      sentimentStats: json['sentiment_stats'] as String?,
      aiRegion: json['ai_region'] as String?,
      aiOrg: json['ai_org'] as String,
      duplicate: json['duplicate'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'article_id': articleId,
      'title': title,
      'link': link,
      'keywords': keywords,
      'creator': creator,
      'video_url': videoUrl,
      'description': description,
      'content': content,
      'pubDate': pubDate,
      'pubDateTZ': pubDateTZ,
      'image_url': imageUrl,
      'source_id': sourceId,
      'source_priority': sourcePriority,
      'source_name': sourceName,
      'source_url': sourceUrl,
      'source_icon': sourceIcon,
      'language': language,
      'country': country,
      'category': category,
      'ai_tag': aiTag,
      'sentiment': sentiment,
      'sentiment_stats': sentimentStats,
      'ai_region': aiRegion,
      'ai_org': aiOrg,
      'duplicate': duplicate,
    };
  }
}
