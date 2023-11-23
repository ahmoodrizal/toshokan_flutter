class AppConstants {
  static const appName = 'Toshokan';

  static const _host = 'http://192.168.1.15:8000/api';

  static const String authLoginUrl = '$_host/login';
  static const String authRegisterUrl = '$_host/register';
  static const String authLogoutUrl = '$_host/logout';

  static const transactionStatus = [
    'All',
    'Pending',
    'Active',
    'Done',
    'Late',
  ];
}
