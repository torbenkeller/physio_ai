import 'dart:io';

import 'package:dio/dio.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/rezept.dart';
import 'package:physio_ai/rezepte/rezept_repository.dart';
import 'package:http_parser/http_parser.dart';

class RezeptRepositoryImplementation implements RezeptRepository {
  final Dio _dio;
  
  RezeptRepositoryImplementation(this._dio);
  
  @override
  Future<List<Rezept>> getRezepte() async {
    final response = await _dio.get<List<dynamic>>('/rezepte');
    return (response.data ?? [])
        .map((json) => Rezept.fromJson(json as Map<String, dynamic>))
        .toList();
  }
  
  @override
  Future<Rezept> createRezept(Map<String, dynamic> rezeptCreate) async {
    try {
      // Log the request payload
      print('Creating rezept with data: $rezeptCreate');
      
      final response = await _dio.post<Map<String, dynamic>>(
        '/rezepte',
        data: rezeptCreate,
      );
      
      // Log the response
      print('Received response: ${response.data}');
      
      return Rezept.fromJson(response.data!);
    } catch (e) {
      // Log the error
      print('Error creating rezept: $e');
      if (e is DioException) {
        print('Request: ${e.requestOptions.uri}');
        print('Request data: ${e.requestOptions.data}');
        print('Response status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }
  
  @override
  Future<void> deleteRezept(String id) async {
    await _dio.delete('/rezepte/$id');
    return;
  }

  @override
  Future<RezeptEinlesenResponse> uploadRezeptImage(File file) async {
    // Get file extension
    String fileName = file.path.split('/').last;
    String extension = fileName.split('.').last.toLowerCase();
    
    // Map file extension to mime type
    String mimeType;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        mimeType = 'image/jpeg';
        break;
      case 'png':
        mimeType = 'image/png';
        break;
      case 'gif':
        mimeType = 'image/gif';
        break;
      case 'webp':
        mimeType = 'image/webp';
        break;
      case 'heic':
        mimeType = 'image/heic';
        break;
      default:
        mimeType = 'application/octet-stream';
    }
    
    // Create form data
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ),
    });
    
    // Send the request
    final response = await _dio.post(
      '/rezepte/createFromImage',
      data: formData,
    );
    
    return RezeptEinlesenResponse.fromJson(response.data as Map<String, dynamic>);
  }
}