// ignore_for_file: unused_field

class AppConstants {
  static const appName = 'Toshokan';

  static const String _host = 'http://192.168.1.6:8000/api';
  static const String hostImage = 'http://192.168.1.6:8000/storage';

  // Auth URL
  static const String authLoginUrl = '$_host/login';
  static const String authRegisterUrl = '$_host/register';
  static const String authLogoutUrl = '$_host/logout';
  static const String updateProfileUrl = '$_host/update';

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
