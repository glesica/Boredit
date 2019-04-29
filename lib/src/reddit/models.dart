import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'models.g.dart';

@JsonSerializable()
class Listing {
  final String after;

  final String before;

  @JsonKey(name: 'children', fromJson: _linksFromJson, toJson: _linksToJson)
  final Iterable<Link> links;

  Listing({
    this.after,
    this.before,
    this.links,
  });

  static Listing fromResponseJson(Map<String, dynamic> json) =>
      fromJson(json['data']);

  static Listing fromJson(Map<String, dynamic> json) => _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);

  @override
  String toString() => links.join('\n');
}

@JsonSerializable()
class Link {
  @JsonKey(name: 'post_hint')
  final String postHint;

  final int score;

  final String subreddit;

  @JsonKey(fromJson: _uriFromJson, toJson: _uriToJson)
  final Uri thumbnail;

  final String title;

  @JsonKey(fromJson: _uriFromJson, toJson: _uriToJson)
  final Uri url;

  Link({
    @required this.postHint,
    @required this.score,
    @required this.subreddit,
    @required this.thumbnail,
    @required this.title,
    @required this.url,
  });

  static Link fromChildJson(Map<String, dynamic> json) =>
      fromJson(json['data']);

  static Link fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);

  @override
  String toString() => '$subreddit - $title';
}

Type _toType(String type) => {
      't2': Type.account,
      't6': Type.award,
      't1': Type.comment,
      't3': Type.link,
      't4': Type.message,
      't5': Type.subreddit,
    }[type.substring(0, 2)];

enum Type {
  account,
  award,
  comment,
  link,
  message,
  subreddit,
}

Iterable<Link> _linksFromJson(List<dynamic> links) =>
    links.cast<Map<String, dynamic>>().map(Link.fromChildJson);

Iterable<Map<String, dynamic>> _linksToJson(Iterable<Link> links) =>
    links.map((link) => link.toJson());

Uri _uriFromJson(String uri) => uri.startsWith('https') ? Uri.parse(uri) : null;

String _uriToJson(Uri uri) => uri?.toString() ?? 'default';
