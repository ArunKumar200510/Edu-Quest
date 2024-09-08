import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:convert';

Future<List<String>> scrapeData(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final links = <String>[];

      for (var element in document.querySelectorAll('[xmlns\\:xlink]')) {
        final link = element.attributes['xlink:href'];
        print(link);
        if (link != null) {
          links.add(link);
        }
      }
      print(links);
      return links;
    } else {
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  } catch (e) {
    return ['', '', 'ERROR: $e'];
  }
}
