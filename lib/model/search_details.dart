import 'package:trophy_tracker/model/search_model.dart';

class SearchDetails {
  final int maxPage;
  final List<SearchModel> results;

  SearchDetails(this.maxPage, this.results);
}
