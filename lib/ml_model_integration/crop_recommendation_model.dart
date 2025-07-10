// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:agro_vision/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// A model class that represents the crop recommendation logic or data structure.
/// 
/// This class is intended to encapsulate the properties and methods required
/// for recommending suitable crops based on various input parameters such as
/// soil type, weather conditions, and other relevant agricultural data.
class CropRecommendationModel {
  Interpreter? _interpreter;
  List<double> mean = [];
  List<double> scale = [];
  int nFeaturesIn = 0;
  List<String> featureNames = [];

  // PCA parameters
  List<List<double>> pcaComponents = [];
  List<double> pcaMean = [];
  int nPcaComponents = 0;

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset(AppConstants.cropRecommendationModelPath);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error loading model: $e");
      }
    }
  }

  /// Encode `start_month` into one-hot vector
  List<double> encodeMonth(int index) {
    List<double> encodedMonth = List.filled(12, 0.0); // 12 months
    if (index != -1) {
      encodedMonth[index] = 1.0;
    }
    return encodedMonth;
  }

  dynamic predict(List<double> inputFeatures) async {
    // Load scaler parameters
    await loadFromJson(AppConstants.scalerParamsJsonFilePath);

    // Load PCA parameters
    await loadPcaParamsFromJson(AppConstants.pcaParamsJsonFilePath);

    // Step 1: Scale the input data
    List<double> scaledData = transform(inputFeatures);

    // Create output buffer
    var output = List.filled(22, 0.0).reshape([1, 22]);

    // Run inference
    _interpreter?.run(scaledData, output);

    // Process output
    // List outputList =
    //     List.of(output[0]).map((probability) => probability * 100).toList();

    List<double> probabilities = output[0];
    // Find the maximum probability
    double maxProbability = probabilities.reduce((a, b) => a > b ? a : b);

    // Get the index of the highest probability
    int maxIndex = probabilities.indexOf(maxProbability);

    List<String> cropLabels = await loadLabelClasses();

    // DEBUG: Can be used to check label-probability mapping for model output
    // List<Map<String, double>> cropProbabilityMapList = List.generate(
    //   cropLabels.length,
    //   (index) => {cropLabels[index]: outputList[index]},
    // );

    String predictedCrop = cropLabels[maxIndex];

    return predictedCrop;
  }

  // Load scaler parameters from JSON file
  Future<void> loadFromJson(String path) async {
    final String response = await rootBundle.loadString(path);
    final Map<String, dynamic> params = jsonDecode(response);

    mean = List<double>.from(params['mean']);
    scale = List<double>.from(params['scale']);
    nFeaturesIn = mean.length;
    featureNames = List<String>.from(params['feature_names']);

  }

  // Load PCA parameters from JSON file
  Future<void> loadPcaParamsFromJson(String path) async {
    final String response = await rootBundle.loadString(path);
    final Map<String, dynamic> params = jsonDecode(response);

    // Load PCA components as a 2D array
    List<dynamic> componentsJson = params['components'];
    pcaComponents =
        componentsJson.map((row) => List<double>.from(row)).toList();

    pcaMean = List<double>.from(params['mean']);
    nPcaComponents = params['n_components'];
  }

  // Transform a single input sample using StandardScaler
  List<double> transform(List<double> X) {
    if (X.length != nFeaturesIn) {
      throw Exception(
          'Feature dimensions mismatch. Expected $nFeaturesIn features, got ${X.length}');
    }

    List<double> XScaled = List<double>.filled(nFeaturesIn, 0.0);
    for (int i = 0; i < nFeaturesIn; i++) {
      XScaled[i] = (X[i] - mean[i]) / scale[i];
    }

    return XScaled;
  }

  // Apply PCA transformation to scaled data
  List<double> applyPca(List<double> scaledData) {
    // First center the data using PCA mean
    List<double> centeredData = List<double>.filled(scaledData.length, 0.0);
    for (int i = 0; i < scaledData.length; i++) {
      centeredData[i] = scaledData[i] - pcaMean[i];
    }

    // Project the centered data onto principal components
    List<double> transformedData = List<double>.filled(nPcaComponents, 0.0);

    // Matrix multiplication: transformedData = centeredData * pcaComponents^T
    for (int i = 0; i < nPcaComponents; i++) {
      double sum = 0.0;
      for (int j = 0; j < centeredData.length; j++) {
        sum += centeredData[j] * pcaComponents[i][j];
      }
      transformedData[i] = sum;
    }

    return transformedData;
  }

  Future<List<String>> loadLabelClasses() async {
    // Load the JSON file
    String jsonString = await rootBundle
        .loadString('lib/assets/ml_model_labels/label_classes.json');
    // Parse the JSON string to a list
    List<dynamic> jsonList = json.decode(jsonString);
    // Convert to List<String>
    List<String> labels = jsonList.map((label) => label.toString()).toList();
    return labels;
  }
}

// Extension to reshape lists to make them easier to use with TFLite
extension ListExtension<T> on List<T> {
  List<List<T>> reshape(List<int> shape) {
    if (shape.length != 2) {
      throw ArgumentError('Only 2D reshaping is supported');
    }

    if (shape[0] * shape[1] != length) {
      throw ArgumentError('Shape dimensions must match list length');
    }

    List<List<T>> result = [];
    for (int i = 0; i < shape[0]; i++) {
      List<T> row = [];
      for (int j = 0; j < shape[1]; j++) {
        row.add(this[i * shape[1] + j]);
      }
      result.add(row);
    }
    return result;
  }
}
