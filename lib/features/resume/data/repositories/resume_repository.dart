import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/resume_model.dart';

class ResumeRepository {
  final ApiClient apiClient;

  ResumeRepository({required this.apiClient});

  Future<ResumeResultModel> optimizeAndAnalyzeResume(Uint8List fileBytes, String fileName) async {
    try {
      // Re-create the MultipartFiles separately so Dio doesn't conflict
      final formDataOptimize = FormData.fromMap({
        'file': MultipartFile.fromBytes(List.from(fileBytes), filename: fileName),
      });

      final formDataAnalyze = FormData.fromMap({
        'file': MultipartFile.fromBytes(List.from(fileBytes), filename: fileName),
      });

      final responses = await Future.wait([
        apiClient.dio.post('/api/v1/resume/optimize', data: formDataOptimize),
        apiClient.dio.post('/api/v1/resume/analyze', data: formDataAnalyze),
      ]);

      final rawDataOpt = responses[0].data;
      final Map<String, dynamic> decodedOpt;
      if (rawDataOpt is String) {
        decodedOpt = jsonDecode(rawDataOpt);
      } else {
        decodedOpt = rawDataOpt;
      }
      final optData = decodedOpt['data'] ?? decodedOpt;
      final optimization = ResumeOptimizationModel.fromJson(optData);

      final rawDataAna = responses[1].data;
      final Map<String, dynamic> decodedAna;
      if (rawDataAna is String) {
        decodedAna = jsonDecode(rawDataAna);
      } else {
        decodedAna = rawDataAna;
      }
      final anaData = decodedAna['data'] ?? decodedAna;
      final analysis = ResumeAnalysisModel.fromJson(anaData);

      return ResumeResultModel(
        optimization: optimization,
        analysis: analysis,
      );
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message} - ${e.response?.data}');
    } catch (e) {
      throw Exception('Data Error: $e');
    }
  }
}
