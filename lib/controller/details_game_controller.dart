import 'package:dio/dio.dart';
import 'package:trophy_tracker/model/game_model.dart';
import 'package:trophy_tracker/model/trophy_model.dart';
import 'package:universal_html/parsing.dart';

class DetailsGameController {
  static String baseUrl = "https://psnprofiles.com";

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String result = htmlText.replaceAll("<br>", "\n").replaceAll(exp, '');

    return result.trim();
  }

  static Future<GameModel?> getGameDetails(String link) async {
    final dio = Dio();
    var response = await dio.get("$baseUrl$link");

    if (response.statusCode != 200) {
      return null;
    }

    final htmlDocument = parseHtmlDocument(response.data);

    var goldCount =
        htmlDocument.querySelector("ul > li.icon-sprite.gold")?.innerHtml;
    var bronzeCount =
        htmlDocument.querySelector("ul > li.icon-sprite.bronze")?.innerHtml;
    var silverCount =
        htmlDocument.querySelector("ul > li.icon-sprite.silver")?.innerHtml;

    var trophyDiv = htmlDocument
        .querySelector(
            "#content > div.row > div.col-xs-4.col-xs-max-320 > table.box.no-top-border > tbody > tr > td:nth-child(2) > div")
        ?.children;
    var trophyCount = trophyDiv?.last.children.first.innerHtml;

    var difficulty = htmlDocument
        .querySelector("div > div > span:nth-child(1) > span.typo-top")
        ?.innerHtml;

    var playthroughs = htmlDocument
        .querySelector("div > div > span:nth-child(2) > span.typo-top")
        ?.innerHtml;

    var hours = htmlDocument
        .querySelector("div > div > span:nth-child(3) > span.typo-top")
        ?.innerHtml;

    var background = htmlDocument
        .querySelector("#first-banner > div.img")
        ?.getAttribute("style")
        ?.replaceAll("background-image: url(", "")
        .replaceAll(")", "");

    List<trophyModel> trophyes = [];

    var trophyesDivs = htmlDocument.querySelectorAll(".box.section-holder");
    for (var trophy in trophyesDivs) {
      var name = trophy.querySelector("a.title")?.innerText;
      var description = trophy
          .querySelector("table > tbody > tr:nth-child(2) > td:nth-child(2)")
          ?.innerText
          .trim();
      var rarity = trophy.querySelector("center > span.typo-top")?.innerText;
      var image = trophy.querySelector("a > img")?.getAttribute("src");
      var type = baseUrl +
          (trophy.querySelector("center > img")?.getAttribute("src") ?? "");

      var guide = trophy.nextElementSibling
          ?.querySelector(".fr-view.box.light.guide.no-top-border")
          ?.innerHtml
          ?.trim();

      if (name != null && description != null) {
        trophyes.add(trophyModel(
          name,
          description,
          type,
          image ?? "",
          rarity ?? "N/A",
          removeAllHtmlTags(guide ?? ""),
        ));
      }
    }

    if (trophyes.isEmpty) {
      return null;
    }

    return GameModel(
      int.parse(trophyCount ?? "0"),
      int.parse(goldCount ?? "0"),
      int.parse(bronzeCount ?? "0"),
      int.parse(silverCount ?? "0"),
      int.parse(hours ?? "0"),
      difficulty ?? "N/A",
      int.parse(playthroughs ?? "0"),
      trophyes,
      background ?? "",
    );
  }
}
