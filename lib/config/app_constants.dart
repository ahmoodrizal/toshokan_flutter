// ignore_for_file: unused_field

class AppConstants {
  static const appName = 'Toshokan';

  static const String _host = 'https://toshokan.ahmoodrizal.my.id/api';
  static const String hostImage = 'https://toshokan.ahmoodrizal.my.id/storage';

  // Auth URL
  static const String authLoginUrl = '$_host/login';
  static const String authRegisterUrl = '$_host/register';
  static const String authLogoutUrl = '$_host/logout';
  static const String updateProfileUrl = '$_host/update';
  static const String userDetailUrl = '$_host/user';

  // Book URL
  static const String latestBookUrl = '$_host/latest-books';
  static const String popularBookUrl = '$_host/popular-books';
  static const String searchBookByTitleUrl = '$_host/books/search';

  // Transaction URL
  static const String createTransactionUrl = '$_host/transaction/create';
  static const String myTransactionUrl = '$_host/transactions';

  static const transactionStatus = [
    'All',
    'Pending',
    'Active',
    'Done',
    'Late',
  ];
}
