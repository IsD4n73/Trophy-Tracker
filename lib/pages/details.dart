import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:trophy_tracker/controller/database_controller.dart';
import 'package:trophy_tracker/controller/details_game_controller.dart';
import 'package:trophy_tracker/model/game_model.dart';
import 'package:trophy_tracker/model/search_model.dart';
import 'package:trophy_tracker/pages/widget/game_banner.dart';
import 'package:trophy_tracker/pages/widget/game_info.dart';
import 'package:trophy_tracker/pages/widget/trophy_recap.dart';
import 'package:trophy_tracker/pages/widget/trophy_tiles.dart';

class GameDetailsPage extends StatefulWidget {
  final SearchModel game;
  const GameDetailsPage({super.key, required this.game});

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  GameModel? details;

  List<String> doneTrophy = [];

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        BotToast.showLoading();
        details = await DetailsGameController.getGameDetails(widget.game.link);
        setState(() {});

        if (details == null) {
          BotToast.showText(
              text:
                  "Something went wrong when loading the data, please try again");
        }
        doneTrophy = await DatabaseController.getDoneTrophy(
            widget.game.title.replaceAll(" ", ""));
        BotToast.closeAllLoading();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trophy Tracker"),
        centerTitle: true,
      ),
      body: details == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                children: [
                  GameBanner(
                    title: widget.game.title,
                    background: details!.background,
                  ),
                  const SizedBox(height: 15),
                  GameInfo(
                    difficulty: details!.difficulty,
                    playthroughs: details!.playthroughs.toString(),
                    hours: details!.hours.toString(),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Trophies: ${doneTrophy.length}/${details!.trophyCount}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TrophyRecap(
                    platinum: details!.platinumCount.toString(),
                    gold: details!.goldCount.toString(),
                    silver: details!.silverCount.toString(),
                    bronze: details!.bronzeCount.toString(),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Tags:\n${details!.tags.join(" - ")}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Trophies",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text("Click on the trophy to show the guide (if available)"),
                  Text("Swipe to mark the trophy as done/not done"),
                  const SizedBox(height: 15),
                  ListView.separated(
                    itemCount: details!.trophyes.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.blue,
                      thickness: 0.2,
                    ),
                    itemBuilder: (context, index) {
                      var trophy = details!.trophyes[index];

                      return TrophyTiles(
                        done: doneTrophy.contains(trophy.name),
                        trophy: trophy,
                        gameName: widget.game.title.replaceAll(" ", ""),
                        onUpdate: () async {
                          doneTrophy = await DatabaseController.getDoneTrophy(
                              widget.game.title.replaceAll(" ", ""));
                          setState(() {});
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
