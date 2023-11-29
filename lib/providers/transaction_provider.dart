import 'package:d_method/d_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toshokan/models/transaction_model.dart';

final transactionStatusProvider = StateProvider.autoDispose((ref) => '');

setTransactionStatus(WidgetRef ref, String newStatus) {
  DMethod.printTitle('setTransactionStatus', newStatus);
  ref.read(transactionStatusProvider.notifier).state = newStatus;
}

final myTransactionStatusProvider = StateProvider.autoDispose((ref) => 'All');

setMyTransactionStatus(WidgetRef ref, String newStatus) {
  DMethod.printTitle('setMyTransactionStatus', newStatus);
  ref.read(myTransactionStatusProvider.notifier).state = newStatus;
}

final fetchMyTransaction = StateProvider.autoDispose((ref) => '');

setFetchMyTransaction(WidgetRef ref, String newStatus) {
  ref.read(fetchMyTransaction.notifier).state = newStatus;
}

final myTransactionListProvider = StateNotifierProvider.autoDispose<MyTransactionList, List<TransactionModel>>(
  (ref) => MyTransactionList([]),
);

class MyTransactionList extends StateNotifier<List<TransactionModel>> {
  MyTransactionList(super.state);

  setData(List<TransactionModel> newList) {
    state = newList;
  }
}
