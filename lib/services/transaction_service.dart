import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:toshokan/config/app_constants.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_request.dart';
import 'package:toshokan/config/app_response.dart';
import 'package:toshokan/config/app_sessions.dart';

class BookService {
  static Future<Either<Failure, Map>> fetchMyTransactions() async {
    Uri url = Uri.parse(AppConstants.myTransactionUrl);
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> createTransaction({required String bookId, required String duration}) async {
    Uri url = Uri.parse(AppConstants.createTransactionUrl);
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'book_id': bookId,
          'duration': duration,
        },
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(FetchFailure(e.toString()));
    }
  }
}
