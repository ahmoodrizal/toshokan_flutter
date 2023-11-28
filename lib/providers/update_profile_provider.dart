import 'package:d_method/d_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateProfileStatusProvider = StateProvider.autoDispose((ref) => '');

setUpdateProfileStatus(WidgetRef ref, String newStatus) {
  DMethod.printTitle('setUpdateProfileStatus', newStatus);
  ref.read(updateProfileStatusProvider.notifier).state = newStatus;
}
