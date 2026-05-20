import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/career_kit_model.dart';

class CareerKitRepository {
  final ApiClient apiClient;

  CareerKitRepository({required this.apiClient});

  Future<CareerKitModel> generateKit({
    required Uint8List fileBytes,
    required String fileName,
    required String targetRole,
    String? companyName,
    String? tone,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
        'target_role': targetRole,
        if (companyName != null && companyName.isNotEmpty) 'company_name': companyName,
        if (tone != null && tone.isNotEmpty) 'tone': tone,
      });

      final response = await apiClient.dio.post(
        '/api/v1/career/generate-application-kit',
        data: formData,
      );

      final rawData = response.data;
      final Map<String, dynamic> decodedData;
      if (rawData is String) {
        decodedData = jsonDecode(rawData);
      } else if (rawData is Map<String, dynamic>) {
        decodedData = rawData;
      } else {
        throw Exception('Invalid response type: ${rawData.runtimeType}');
      }

      return CareerKitModel.fromJson(decodedData);
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message} - ${e.response?.data}');
    } catch (e) {
      throw Exception('Data Error: $e');
    }
  }
}
