class Ingredient {
  final String inferenceId;
  final double time;
  final ImageDetails image;
  final List<Prediction> predictions;

  Ingredient({
    required this.inferenceId,
    required this.time,
    required this.image,
    required this.predictions,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      inferenceId: json['inference_id'],
      time: json['time'],
      image: ImageDetails.fromJson(json['image']),
      predictions: (json['predictions'] as List)
          .map((e) => Prediction.fromJson(e))
          .toList(),
    );
  }
}

class ImageDetails {
  final int width;
  final int height;

  ImageDetails({
    required this.width,
    required this.height,
  });

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      width: json['width'],
      height: json['height'],
    );
  }
}

class Prediction {
  final double x;
  final double y;
  final double width;
  final double height;
  final double confidence;
  final String detectedClass;
  final int classId;

  Prediction({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.confidence,
    required this.detectedClass,
    required this.classId,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      x: json['x'],
      y: json['y'],
      width: json['width'],
      height: json['height'],
      confidence: json['confidence'],
      detectedClass: json['class'],
      classId: json['class_id'],
    );
  }
}
