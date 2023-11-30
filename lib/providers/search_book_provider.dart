import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toshokan/models/book_model.dart';

final searchBookByTitleProvider = StateProvider.autoDispose((ref) => '');

setSearchBookStatus(WidgetRef ref, String newStatus) {
  ref.read(searchBookByTitleProvider.notifier).state = newStatus;
}

final searchByTitleListProvider = StateNotifierProvider.autoDispose<SearchByTitleList, List<BookModel>>(
  (ref) => SearchByTitleList([]),
);

class SearchByTitleList extends StateNotifier<List<BookModel>> {
  SearchByTitleList(super.state);

  setData(newList) {
    state = newList;
  }
}
