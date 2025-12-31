import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final Dio _dio;
  final String _apiKey;

  GeminiService()
      : _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '',
        _dio = Dio(BaseOptions(
          baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  Future<String?> generateStudioImage({
    required File imageFile,
    required String vibePrompt,
  }) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception('API key not found. Please add GEMINI_API_KEY to .env file');
      }

      // Read image and convert to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Determine MIME type
      final mimeType = _getMimeType(imageFile.path);

      // Construct the prompt
      final systemPrompt =
          'Enhance this product image. Keep the product exactly as it is, '
          'but place it in a $vibePrompt. '
          'Maintain the product\'s original appearance, colors, and details. '
          'Only change the background and lighting.';

      // API request body
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': systemPrompt},
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.4,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 4096,
        }
      };

      // Make API call
      final response = await _dio.post(
        '/models/gemini-2.5-flash-image:generateContent',
        queryParameters: {'key': _apiKey},
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Extract generated image URL or data
      if (response.statusCode == 200) {
        final data = response.data;

        // The response structure depends on the model
        // For image generation, we typically get the image in the response
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          final content = candidate['content'];

          if (content != null && content['parts'] != null) {
            for (var part in content['parts']) {
              // Check if the part contains inline image data
              if (part['inlineData'] != null) {
                return part['inlineData']['data'];
              }
            }
          }
        }
      }

      throw Exception('Failed to generate image: Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'API Error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to generate image: $e');
    }
  }

  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
