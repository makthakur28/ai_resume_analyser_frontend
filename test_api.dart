import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile('../backend/app/storage/generated/80112f70-c233-42a2-8d67-3111f4159907.pdf', filename: 'resume.pdf'),
      'target_role': 'Java Developer',
    });
    
    final response = await dio.post('http://127.0.0.1:8000/api/v1/career/generate-application-kit', data: formData);
    print('Response status: ${response.statusCode}');
    print('Response data type: ${response.data.runtimeType}');
    print('Response data: ${response.data}');
  } on DioException catch (e) {
    print('DioException occurred!');
    print('Message: ${e.message}');
    print('Response status: ${e.response?.statusCode}');
    print('Response body: ${e.response?.data}');
  } catch (e) {
    print('Standard Exception: $e');
  }
}
