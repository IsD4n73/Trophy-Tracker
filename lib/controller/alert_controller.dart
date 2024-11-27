import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:trophy_tracker/model/trophy_model.dart';

class AlertController {
  static void showTrophyAlert(
    String title,
    String description,
    TrophyLevel type,
  ) {
    BotToast.showCustomNotification(
      crossPage: false,
      onlyOne: true,
      useSafeArea: true,
      align: Alignment.topLeft,
      duration: const Duration(seconds: 5),
      toastBuilder: (cancelFunc) {
        return LayoutBuilder(builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xff292a2f),
            ),
            child: Row(
              children: [
                Image.asset(
                  getTypeFromLevel(type).asset,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: constraints.maxWidth / 1.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        description,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/trophy/ps.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 15),
              ],
            ),
          );
        });
      },
    );
  }

  static TrophyType getTypeFromLevel(TrophyLevel level,
      [ConsolePlatform platform = ConsolePlatform.ps5]) {
    if (platform == ConsolePlatform.ps5) {
      switch (level) {
        case TrophyLevel.platinum:
          return TrophyType.plastinum;
        case TrophyLevel.gold:
          return TrophyType.gold;
        case TrophyLevel.silver:
          return TrophyType.silver;
        case TrophyLevel.bronze:
          return TrophyType.bronze;
      }
    }

    switch (level) {
      case TrophyLevel.platinum:
        return TrophyType.oldPlastinum;
      case TrophyLevel.gold:
        return TrophyType.oldGold;
      case TrophyLevel.silver:
        return TrophyType.oldSilver;
      case TrophyLevel.bronze:
        return TrophyType.oldBronze;
    }
  }
}

enum TrophyType {
  plastinum('assets/trophy/new-trophy-platinum.png'),
  gold('assets/trophy/new-trophy-gold.png'),
  silver('assets/trophy/new-trophy-silver.png'),
  bronze('assets/trophy/new-trophy-bronze.png'),
  oldPlastinum('assets/trophy/old-trophy-platinum.png'),
  oldGold('assets/trophy/old-trophy-gold.png'),
  oldSilver('assets/trophy/old-trophy-silver.png'),
  oldBronze('assets/trophy/old-trophy-bronze.png');

  const TrophyType(this.asset);
  final String asset;
}

enum ConsolePlatform {
  ps5,
  ps4,
  ps3,
  psvita,
}
