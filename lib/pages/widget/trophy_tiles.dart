import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:trophy_tracker/model/trophy_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../controller/database_controller.dart';

class TrophyTiles extends StatelessWidget {
  final bool done;
  final TrophyModel trophy;
  final String gameName;

  final Function() onUpdate;

  const TrophyTiles(
      {super.key,
      required this.done,
      required this.trophy,
      required this.onUpdate,
      required this.gameName});

  @override
  Widget build(BuildContext context) {
    Widget widget = SizedBox.shrink();

    if (trophy.guide != null && trophy.guide!.isNotEmpty) {
      widget = Dismissible(
        key: Key(trophy.name),
        background: Container(
          color: done ? Colors.red : Colors.green,
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                done ? Icons.close : Icons.done,
              ),
              Icon(
                done ? Icons.close : Icons.done,
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (done) {
            await DatabaseController.markTrophyAsNotDone(trophy, gameName);
          } else {
            await DatabaseController.markTrophyAsDone(trophy, gameName);
          }

          await onUpdate();
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
            HtmlWidget(
              trophy.guide!,
              onTapUrl: (url) async {
                await launchUrlString(url);
                return true;
              },
            ),
            //Text(trophy.guide!),
            const SizedBox(height: 10),
          ],
        ),
      );
    } else {
      widget = Dismissible(
        key: Key(trophy.name),
        background: Container(
          color: done ? Colors.red : Colors.green,
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                done ? Icons.close : Icons.done,
              ),
              Icon(
                done ? Icons.close : Icons.done,
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (done) {
            await DatabaseController.markTrophyAsNotDone(trophy, gameName);
          } else {
            await DatabaseController.markTrophyAsDone(trophy, gameName);
          }

          await onUpdate();
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

    return done
        ? Banner(
            message: "Done",
            location: BannerLocation.topEnd,
            color: Colors.green,
            child: widget,
          )
        : widget;
  }
}
