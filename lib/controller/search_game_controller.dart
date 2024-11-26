import 'package:dio/dio.dart';
import 'package:trophy_tracker/model/search_details.dart';
import 'package:universal_html/parsing.dart';

import '../model/search_model.dart';

class SearchGameController {
  static String baseUrl = "https://psnprofiles.com/search/guides?q=";

  static Future<SearchDetails?> search(String query, int page) async {
    final dio = Dio();

    var response = await dio.get("$baseUrl$query&page=$page");

    if (response.statusCode != 200) {
      return null;
    }

    final htmlDocument = parseHtmlDocument(response.data);
    var elements = htmlDocument
        .querySelector(
            "#search-results > div > div > div:nth-child(1) > div > ul")
        ?.children;

    String? maxPage = "1";
    if (elements != null) {
      maxPage = elements
          .elementAt(elements.indexOf(elements.last) - 1)
          .children
          .first
          .innerHtml;
    }

    var games = htmlDocument
        .querySelector(maxPage == "1"
            ? "#search-results > div > div > div"
            : "#search-results > div > div > div:nth-child(2)")
        ?.children;

    if (games == null) {
      return null;
    }

    String resultCount =
        htmlDocument.getElementById('result-count')?.innerText ?? '';

    List<SearchModel> results = [];

    for (var game in games) {
      var title = game.querySelector(".ellipsis")?.children.first.innerHtml;
      var link = game.querySelector("a")?.getAttribute("href");
      var platform = game.querySelector("div.platforms > span")?.innerHtml;
      var bg = game
          .querySelector("div > a > div")
          ?.getAttribute("style")
          ?.replaceAll("background-image: url('", "")
          .replaceAll("')", "");

      if (title != null && link != null) {
        results.add(SearchModel(title, platform ?? "N/A", bg ?? "", link));
      }
    }

    return SearchDetails(int.parse(maxPage ?? "1"), results, resultCount);
  }
}
