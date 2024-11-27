import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:trophy_tracker/controller/database_controller.dart';
import 'package:trophy_tracker/controller/search_game_controller.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:trophy_tracker/model/search_model.dart';
import 'package:trophy_tracker/model/trophy_model.dart';
import 'package:trophy_tracker/pages/details.dart';
import 'package:trophy_tracker/pages/widget/console_icons.dart';
import 'package:trophy_tracker/pages/widget/platinum_recap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  bool needToLoadOther = true;
  String searchCount = "";
  List<TrophyModel> platinums = [];
  final PagingController<int, SearchModel> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    searchCount = "";
    FlutterNativeSplash.remove();

    Future.delayed(
      Duration.zero,
      () async {
        platinums = await DatabaseController.getPlatinumTrophy();
        setState(() {});
      },
    );

    pagingController.addPageRequestListener((pageKey) async {
      if (!needToLoadOther) {
        return;
      }

      BotToast.showLoading();
      final newItems = await SearchGameController.search(search.text, pageKey);

      if (newItems == null) {
        pagingController.error =
            "Something went wrong during the search, please try again";
        searchCount = "";
        setState(() {});
        BotToast.closeAllLoading();
        return;
      }

      final isLastPage = pageKey >= newItems.maxPage;
      if (isLastPage || newItems.maxPage == 1) {
        pagingController.appendLastPage(newItems.results);
      } else {
        final nextPageKey = pageKey++;
        pagingController.appendPage(newItems.results, nextPageKey);
      }
      BotToast.closeAllLoading();
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  _search() async {
    BotToast.showLoading();
    pagingController.itemList = null;
    var searchDetails = await SearchGameController.search(search.text, 1);
    platinums = await DatabaseController.getPlatinumTrophy();
    pagingController.itemList = [];
    searchCount = '';
    BotToast.closeAllLoading();

    if (searchDetails == null) {
      BotToast.showText(
          text: "Something went wrong during the search, please try again");
      return;
    }

    searchCount = searchDetails.resultCount;
    print(searchDetails.maxPage);

    if (searchDetails.maxPage == 1) {
      needToLoadOther = false;
      pagingController.appendLastPage(searchDetails.results);
    } else {
      needToLoadOther = true;
      pagingController.appendPage(searchDetails.results, 2);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(searchCount != "" ? searchCount : "Trophy Tracker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 15),
            TextField(
              controller: search,
              onSubmitted: (value) async {
                await _search();
              },
              decoration: InputDecoration(
                labelText: "Search Games",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    await _search();
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 15),
            pagingController.itemList == null
                ? PlatinumRecap(
                    platinumTrophys: platinums,
                  )
                : Flexible(
                    child: PagedListView<int, SearchModel>(
                      shrinkWrap: true,
                      pagingController: pagingController,
                      builderDelegate: PagedChildBuilderDelegate<SearchModel>(
                        itemBuilder: (context, game, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GameDetailsPage(game: game),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      game.background,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    game.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.black45,
                                    ),
                                  ),
                                  subtitle: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ConsoleIcons(console: game.platform),
                                          const SizedBox(width: 5),
                                          Text(
                                            game.platform,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
