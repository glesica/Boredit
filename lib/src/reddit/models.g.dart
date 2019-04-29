// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) {
  return Listing(
      after: json['after'] as String,
      before: json['before'] as String,
      links: json['children'] == null
          ? null
          : _linksFromJson(json['children'] as List));
}

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'after': instance.after,
      'before': instance.before,
      'children': instance.links == null ? null : _linksToJson(instance.links)
    };

Link _$LinkFromJson(Map<String, dynamic> json) {
  return Link(
      postHint: json['post_hint'] as String,
      score: json['score'] as int,
      subreddit: json['subreddit'] as String,
      thumbnail: json['thumbnail'] == null
          ? null
          : _uriFromJson(json['thumbnail'] as String),
      title: json['title'] as String,
      url: json['url'] == null ? null : _uriFromJson(json['url'] as String));
}

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'post_hint': instance.postHint,
      'score': instance.score,
      'subreddit': instance.subreddit,
      'thumbnail':
          instance.thumbnail == null ? null : _uriToJson(instance.thumbnail),
      'title': instance.title,
      'url': instance.url == null ? null : _uriToJson(instance.url)
    };
