import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:trophy_tracker/controller/search_game_controller.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:trophy_tracker/model/search_model.dart';
import 'package:trophy_tracker/pages/details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();

  final PagingController<int, SearchModel> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    pagingController.addPageRequestListener((pageKey) async {
      BotToast.showLoading();
      final newItems = await SearchGameController.search(search.text, pageKey);

      if (newItems == null) {
        pagingController.error =
            "Something went wrong during the search, please try again";
        BotToast.closeAllLoading();
        return;
      }

      final isLastPage = pageKey >= newItems.maxPage;
      if (isLastPage) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("trophy Tracker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 15),
            TextField(
              controller: search,
              decoration: InputDecoration(
                labelText: "Search Games",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    BotToast.showLoading();
                    pagingController.itemList = null;
                    var searchDetails =
                        await SearchGameController.search(search.text, 1);
                    BotToast.closeAllLoading();

                    if (searchDetails == null) {
                      BotToast.showText(
                          text:
                              "Something went wrong during the search, please try again");
                      return;
                    }

                    if (searchDetails.maxPage == 1) {
                      pagingController.appendLastPage(searchDetails.results);
                    } else {
                      pagingController.appendPage(searchDetails.results, 2);
                    }

                    setState(() {});
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 15),
            pagingController.itemList == null
                ? const SizedBox.shrink()
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
                                    child: Text(
                                      game.platform,
                                      style: TextStyle(
                                        backgroundColor: Colors.blue,
                                        color: Colors.white,
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
