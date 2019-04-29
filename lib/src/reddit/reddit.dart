import 'dart:convert' show json;

import 'package:bored_it/src/reddit/models.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

final Logger _logger = Logger('reddit');

Future<Listing> fetchFrontPage() async {
  return fetchSubreddit();
}

Future<Listing> fetchSubreddit([String name]) async {
  final startTime = DateTime.now();

  final subreddit = name == null ? '' : 'r/$name/';
  _logger.info('fetching ${name ?? '/'}');

  final uri = Uri(
    scheme: 'https',
    host: 'reddit.com',
    path: '$subreddit.json',
    queryParameters: {
      'limit': '100',
    },
  );

  // TODO: Handle GET timeout
  final response = await http.get(
    uri.toString(),
    headers: {
      'User-Agent': 'Boredit/alpha',
    },
  );
  if (response.statusCode != 200) {
    _logger.warning('received status ${response.statusCode}');
    return null;
  }

  final bodyMap = json.decode(response.body);

  final stopTime = DateTime.now();
  final deltaTime = stopTime.difference(startTime);
  _logger.info('fetched ${name ?? '/'} in ${deltaTime.inMilliseconds}ms');

  return Listing.fromResponseJson(bodyMap);
}
