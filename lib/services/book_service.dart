import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:toshokan/config/app_constants.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_request.dart';
import 'package:toshokan/config/app_response.dart';
import 'package:toshokan/config/app_sessions.dart';

class BookService {
  static Future<Either<Failure, Map>> fetchPopularBooks() async {
    Uri url = Uri.parse(AppConstants.popularBookUrl);
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

  static Future<Either<Failure, Map>> fetchLatestBooks() async {
    Uri url = Uri.parse(AppConstants.latestBookUrl);
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

  static Future<Either<Failure, Map>> searchBookByTitle(String title) async {
    Uri url = Uri.parse('${AppConstants.searchBookByTitleUrl}/$title');
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
}
