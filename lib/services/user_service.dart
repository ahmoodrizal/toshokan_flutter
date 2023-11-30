import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:toshokan/config/app_constants.dart';
import 'package:toshokan/config/app_failure.dart';
import 'package:toshokan/config/app_request.dart';
import 'package:toshokan/config/app_response.dart';
import 'package:toshokan/config/app_sessions.dart';

class UserService {
  static Future<Either<Failure, Map>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    Uri url = Uri.parse(AppConstants.authRegisterUrl);
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'name': name,
          'email': email,
          'password': password,
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

  static Future<Either<Failure, Map>> login(
    String email,
    String password,
  ) async {
    Uri url = Uri.parse(AppConstants.authLoginUrl);
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'email': email,
          'password': password,
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

  static Future<Either<Failure, Map>> logout() async {
    Uri url = Uri.parse(AppConstants.authLogoutUrl);
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.post(
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

  static Future<Either<Failure, Map>> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
    required String city,
    required String address,
    required String affilation,
  }) async {
    Uri url = Uri.parse(AppConstants.updateProfileUrl);
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'name': name,
          'email': email,
          'city': city,
          'address': address,
          'affilation': affilation,
          'phone_number': phoneNumber,
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

  static Future<Either<Failure, Map>> detail() async {
    Uri url = Uri.parse(AppConstants.userDetailUrl);
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
