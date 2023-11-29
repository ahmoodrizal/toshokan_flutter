import 'package:d_method/d_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionStatusProvider = StateProvider.autoDispose((ref) => '');

setTransactionStatus(WidgetRef ref, String newStatus) {
  DMethod.printTitle('setTransactionStatus', newStatus);
  ref.read(transactionStatusProvider.notifier).state = newStatus;
}
