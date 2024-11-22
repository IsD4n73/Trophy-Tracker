import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:trophy_tracker/model/trophy_model.dart';

class DatabaseController {
  static late Database database;

  static Future<void> initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'trophytracker_database.db');
    database = await databaseFactoryIo.openDatabase(dbPath);
  }

  static Future<List<String>> getDoneTrophy() async {
    var store = StoreRef.main();

    var encodedSource =
        (await store.record('completedtrophy').get(database) as String?) ??
            '{"list" : []}';

    var trophyJson = jsonDecode(encodedSource);

    List<TrophyModel> doneTrophy = List.from(trophyJson["list"])
        .map((e) => TrophyModel.fromJson(e))
        .toList();

    return doneTrophy.map((e) => e.name).toList();
  }

  static Future<void> markTrophyAsDone(TrophyModel trophy) async {
    var store = StoreRef.main();

    var encodedSource =
        (await store.record('completedtrophy').get(database) as String?) ??
            '{"list" : []}';

    var trophyJson = jsonDecode(encodedSource);

    List<TrophyModel> doneTrophy = List.from(trophyJson["list"])
        .map((e) => TrophyModel.fromJson(e))
        .toList();

    var alreadyAdded = doneTrophy.map((e) => e.name).toList();

    if (alreadyAdded.contains(trophy.name)) {
      return;
    }

    doneTrophy.add(trophy);
    var jsoned = {"list": doneTrophy.map((e) => e.toJson()).toList()};

    await store.record('completedtrophy').put(database, jsonEncode(jsoned));
  }

  static Future<void> markTrophyAsNotDone(TrophyModel trophy) async {
    var store = StoreRef.main();

    var encodedSource =
        (await store.record('completedtrophy').get(database) as String?) ??
            '{"list" : []}';

    var trophyJson = jsonDecode(encodedSource);

    List<TrophyModel> doneTrophy = List.from(trophyJson["list"])
        .map((e) => TrophyModel.fromJson(e))
        .toList();

    doneTrophy.removeWhere((element) => element.name == trophy.name);

    var jsoned = {"list": doneTrophy.map((e) => e.toJson()).toList()};

    await store.record('completedtrophy').put(database, jsonEncode(jsoned));
  }
}
