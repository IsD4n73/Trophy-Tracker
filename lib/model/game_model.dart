import 'package:trophy_tracker/model/trophy_model.dart';

class GameModel {
  final int trophyCount;
  final int goldCount;
  final int bronzeCount;
  final int silverCount;

  final int hours;
  final String difficulty;
  final String background;
  final int playthroughs;

  final List<trophyModel> trophyes;

  GameModel(
      this.trophyCount,
      this.goldCount,
      this.bronzeCount,
      this.silverCount,
      this.hours,
      this.difficulty,
      this.playthroughs,
      this.trophyes,
      this.background);
}