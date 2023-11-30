import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toshokan/models/book_model.dart';

// Fetch Popular Books
final popularBooksStatusProvider = StateProvider.autoDispose((ref) => '');

final popularBooksListProvider = StateNotifierProvider.autoDispose<PopularBookList, List<BookModel>>(
  (ref) => PopularBookList([]),
);

class PopularBookList extends StateNotifier<List<BookModel>> {
  PopularBookList(super.state);

  setData(List<BookModel> newData) {
    state = newData;
  }
}

setPopularBookStatus(WidgetRef ref, String newStatus) {
  ref.read(popularBooksStatusProvider.notifier).state = newStatus;
}

// Fetch Latest Books
final latestBooksStatusProvider = StateProvider.autoDispose((ref) => '');

final latestBooksListProvider = StateNotifierProvider.autoDispose<LatestBookList, List<BookModel>>(
  (ref) => LatestBookList([]),
);

class LatestBookList extends StateNotifier<List<BookModel>> {
  LatestBookList(super.state);

  setData(List<BookModel> newData) {
    state = newData;
  }
}

setLatestBookStatus(WidgetRef ref, String newStatus) {
  ref.read(latestBooksStatusProvider.notifier).state = newStatus;
}
