import 'package:flutter/foundation.dart';
import '../services/ai_service.dart';

class AIProvider with ChangeNotifier {
  final AIService _aiService = AIService();
  
  bool _isProcessing = false;
  String? _error;
  String? _lastResult;
  String? _lastImageUrl;
  
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  String? get lastResult => _lastResult;
  String? get lastImageUrl => _lastImageUrl;
  
  Future<String?> generateText({
    required String prompt,
    String model = 'gpt-4o-mini',
  }) async {
    _isProcessing = true;
    _error = null;
    _lastResult = null;
    notifyListeners();
    
    try {
      final result = await _aiService.generateText(
        prompt: prompt,
        model: model,
      );
      
      _lastResult = result;
      _isProcessing = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isProcessing = false;
      notifyListeners();
      return null;
    }
  }
  
  Future<String?> generateImage({
    required String prompt,
    String size = '1024x1024',
  }) async {
    _isProcessing = true;
    _error = null;
    _lastImageUrl = null;
    notifyListeners();
    
    try {
      final imageUrl = await _aiService.generateImage(
        prompt: prompt,
        size: size,
      );
      
      _lastImageUrl = imageUrl;
      _isProcessing = false;
      notifyListeners();
      return imageUrl;
    } catch (e) {
      _error = e.toString();
      _isProcessing = false;
      notifyListeners();
      return null;
    }
  }
  
  Future<String?> analyzeImage({
    required String imageUrl,
    String prompt = 'What is in this image?',
  }) async {
    _isProcessing = true;
    _error = null;
    _lastResult = null;
    notifyListeners();
    
    try {
      final result = await _aiService.analyzeImage(
        imageUrl: imageUrl,
        prompt: prompt,
      );
      
      _lastResult = result;
      _isProcessing = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isProcessing = false;
      notifyListeners();
      return null;
    }
  }
  
  int calculateCreditCost(String operation, {String? model}) {
    return _aiService.calculateCreditCost(operation, model: model);
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
