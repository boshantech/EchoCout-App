// EXAMPLE: Complete API Service Integration
// This shows how to create repository implementations

import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/api_endpoints.dart';
import '../errors/app_exceptions.dart';

/// Example Auth Remote Data Source
class AuthRemoteDataSourceExample {
  final DioClient dioClient;

  AuthRemoteDataSourceExample({required this.dioClient});

  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.sendOtp,
        data: {'phoneNumber': phoneNumber},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to send OTP',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phoneNumber': phoneNumber,
          'otpCode': otpCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerException(
          response.data['message'] ?? 'OTP verification failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      final response = await dioClient.post(ApiEndpoints.logout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          response.data['message'] ?? 'Logout failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }
}

/// Example Home Remote Data Source
class HomeRemoteDataSourceExample {
  final DioClient dioClient;

  HomeRemoteDataSourceExample({required this.dioClient});

  Future<List<Map<String, dynamic>>> getWasteCategories() async {
    try {
      final response = await dioClient.get(ApiEndpoints.wasteCategories);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['categories'] ?? []);
      } else {
        throw ServerException(
          'Failed to fetch categories',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getWasteList({
    required String categoryId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.wasteList,
        queryParameters: {
          'categoryId': categoryId,
          'page': page,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['items'] ?? []);
      } else {
        throw ServerException(
          'Failed to fetch waste list',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> estimatePrice({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.estimatePrice,
        data: {
          'itemId': itemId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerException(
          'Failed to estimate price',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }
}

/// Example Echo Remote Data Source
class EchoRemoteDataSourceExample {
  final DioClient dioClient;

  EchoRemoteDataSourceExample({required this.dioClient});

  Future<Map<String, dynamic>> getEchoSummary() async {
    try {
      final response = await dioClient.get(ApiEndpoints.echoSummary);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerException(
          'Failed to fetch echo summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingPickups() async {
    try {
      final response = await dioClient.get(ApiEndpoints.echoPendingPickups);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['pickups'] ?? []);
      } else {
        throw ServerException(
          'Failed to fetch pickups',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }
}

/// Example Scanner Remote Data Source
class ScannerRemoteDataSourceExample {
  final DioClient dioClient;

  ScannerRemoteDataSourceExample({required this.dioClient});

  Future<Map<String, dynamic>> estimateFromImage(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await dioClient.post(
        ApiEndpoints.scanEstimate,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerException(
          'Failed to estimate waste',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> uploadWastePhoto({
    required String imagePath,
    required String wasteType,
    required int quantity,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
        'wasteType': wasteType,
        'quantity': quantity,
      });

      final response = await dioClient.post(
        ApiEndpoints.uploadWastePhoto,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerException(
          'Failed to upload waste photo',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }
}

/// Example Rank Remote Data Source
class RankRemoteDataSourceExample {
  final DioClient dioClient;

  RankRemoteDataSourceExample({required this.dioClient});

  Future<List<Map<String, dynamic>>> getLeaderboard({int page = 1}) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.leaderboard,
        queryParameters: {'page': page, 'limit': 10},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['users'] ?? []);
      } else {
        throw ServerException(
          'Failed to fetch leaderboard',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getUserRank() async {
    try {
      final response = await dioClient.get(ApiEndpoints.userRank);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerException(
          'Failed to fetch user rank',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }
}

/// Example Profile Remote Data Source
class ProfileRemoteDataSourceExample {
  final DioClient dioClient;

  ProfileRemoteDataSourceExample({required this.dioClient});

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await dioClient.get(ApiEndpoints.userProfile);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerException(
          'Failed to fetch profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required Map<String, dynamic> updates,
  }) async {
    try {
      final response = await dioClient.put(
        ApiEndpoints.updateProfile,
        data: updates,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerException(
          'Failed to update profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }
}
