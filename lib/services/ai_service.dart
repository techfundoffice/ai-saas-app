import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';

class AIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  
  // Generate text completion using GPT
  Future<String?> generateText({
    required String prompt,
    String model = 'gpt-4o-mini',
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SupabaseConfig.openAIApiKey}',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': maxTokens,
          'temperature': temperature,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('OpenAI API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error generating text: $e');
      return null;
    }
  }
  
  // Generate image using DALL-E
  Future<String?> generateImage({
    required String prompt,
    String size = '1024x1024',
    int n = 1,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SupabaseConfig.openAIApiKey}',
        },
        body: jsonEncode({
          'model': 'dall-e-3',
          'prompt': prompt,
          'size': size,
          'n': n,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'][0]['url'];
      } else {
        print('DALL-E API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error generating image: $e');
      return null;
    }
  }
  
  // Analyze image using Vision API
  Future<String?> analyzeImage({
    required String imageUrl,
    String prompt = 'What is in this image?',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SupabaseConfig.openAIApiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': prompt},
                {'type': 'image_url', 'image_url': {'url': imageUrl}},
              ],
            }
          ],
          'max_tokens': 300,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('Vision API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error analyzing image: $e');
      return null;
    }
  }
  
  // Calculate credit cost based on operation
  int calculateCreditCost(String operation, {String? model}) {
    switch (operation) {
      case 'text_generation':
        return model == 'gpt-4' ? 5 : 1;
      case 'image_generation':
        return 10;
      case 'image_analysis':
        return 3;
      default:
        return 1;
    }
  }
}
