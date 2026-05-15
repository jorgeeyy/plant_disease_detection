import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  late Interpreter _interpreter;
  late List<String> _labels;

  static const String modelFile = "assets/models/plant_disease_model.tflite";
  static const String labelFile = "assets/models/labels.txt";

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(modelFile);
      final labelData = await rootBundle.loadString(labelFile);
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();
      _isLoaded = true;
      print('Model loaded successfully with ${_labels.length} classes');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded) return {'label': 'Error', 'confidence': 0.0};

    // 1. Read image
    final imageData = await imageFile.readAsBytes();
    final image = img.decodeImage(imageData);
    if (image == null) return {'label': 'Error', 'confidence': 0.0};

    // 2. Pre-process (resize to model input size, e.g., 224x224)
    final inputSize = 224;
    final resizedImage = img.copyResize(image, width: inputSize, height: inputSize);

    // 3. Convert to Float32 list and normalize (0-1)
    final input = _imageToByteList(resizedImage, inputSize);

    // 4. Run inference
    // The model expects [1, 224, 224, 3] and outputs [1, 38]
    final output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter.run(input, output);

    // 5. Apply Softmax to Logits
    final logits = output[0] as List<double>;
    final probabilities = _softmax(logits);

    // 6. Get results
    int maxIndex = 0;
    double maxConfidence = -1.0;

    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxConfidence) {
        maxConfidence = probabilities[i];
        maxIndex = i;
      }
    }

    return {
      'label': _labels[maxIndex],
      'confidence': maxConfidence,
    };
  }

  List<double> _softmax(List<double> logits) {
    double maxLogit = logits.reduce((a, b) => a > b ? a : b);
    List<double> exps = logits.map((l) => exp(l - maxLogit)).toList();
    double sumExps = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sumExps).toList();
  }

  List<List<List<List<double>>>> _imageToByteList(img.Image image, int inputSize) {
    var input = List.generate(
      1,
      (i) => List.generate(
        inputSize,
        (j) => List.generate(
          inputSize,
          (k) => List.generate(3, (l) => 0.0),
        ),
      ),
    );

    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);
        // Normalization: (value / 255.0) - Some models need specific normalization
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }
    return input;
  }

  void dispose() {
    _interpreter.close();
  }
}
