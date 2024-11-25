import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:trophy_tracker/controller/database_controller.dart';
import 'package:trophy_tracker/controller/details_game_controller.dart';
import 'package:trophy_tracker/model/game_model.dart';
import 'package:trophy_tracker/model/search_model.dart';

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
        doneTrophy = await DatabaseController.getDoneTrophy();
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        details!.background,
                        fit: BoxFit.cover,
                      ),
                      Center(
                        child: Text(
                          widget.game.title,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              backgroundColor: Colors.black38),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Difficulty: \n${details!.difficulty}",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Playthroughs:\n${details!.playthroughs}",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Hours: \n${details!.hours}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Trophies: ${details!.trophyCount}",
                      style: TextStyle(color: Colors.black),
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

                      Widget widget = SizedBox.shrink();
                      if (trophy.guide != null && trophy.guide!.isNotEmpty) {
                        widget = Dismissible(
                          key: Key(trophy.name),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              await DatabaseController.markTrophyAsNotDone(
                                  trophy);
                            } else {
                              await DatabaseController.markTrophyAsDone(trophy);
                            }

                            doneTrophy =
                                await DatabaseController.getDoneTrophy();

                            setState(() {});
                            return false;
                          },
                          child: ExpansionTile(
                            title: Text(trophy.name),
                            subtitle: Text(
                              "${trophy.description}\n\nRarity: ${trophy.rarity}",
                              softWrap: true,
                            ),
                            leading: Image.network(trophy.image),
                            trailing: Image.network(trophy.type),
                            children: [
                              const SizedBox(height: 10),
                              const Divider(),
                              Text(trophy.guide!),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      } else {
                        widget = Dismissible(
                          key: Key(trophy.name),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              await DatabaseController.markTrophyAsNotDone(
                                  trophy);
                            } else {
                              await DatabaseController.markTrophyAsDone(trophy);
                            }
                            doneTrophy =
                                await DatabaseController.getDoneTrophy();

                            setState(() {});

                            return false;
                          },
                          child: ListTile(
                            title: Text(trophy.name),
                            subtitle: Text(
                              "${trophy.description}\n\nRarity: ${trophy.rarity}",
                              softWrap: true,
                            ),
                            leading: Image.network(trophy.image),
                            trailing: Image.network(trophy.type),
                          ),
                        );
                      }

                      return doneTrophy.contains(trophy.name)
                          ? Banner(
                              message: "Done",
                              location: BannerLocation.topEnd,
                              color: Colors.green,
                              child: widget,
                            )
                          : widget;
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
