import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:yolo_helper/yolo_helper.dart';

class YoloDetection {
  int? _numClasses;
  List<String>? _labels;
  Interpreter? _interpreter; //모델을 로드하고 추론을 할 수 있게 해주는 클래스

  String label(int index) => _labels?[index] ?? '';

  bool get isInitialized => _interpreter != null && _labels != null;

  // 1. 모델 불러오기
  Future<void> initialize() async {
    _interpreter = await Interpreter.fromAsset('assets/yolov8n.tflite');
    final labelAsset = await rootBundle.loadString('assets/labels.txt');
    _labels = labelAsset.split('\n');
    _numClasses = _labels!.length;
  }

  // 2. 이미지 입력받아서 추론
  List<DetectedObject> runInference(Image image) {
    if (!isInitialized) {
      throw Exception('The model must be initialized');
    }

    // 3. 이미지를 YOLO v8 input 에 맞게 640x640 사이즈로 변환
    final imgResized = copyResize(image, width: 640, height: 640);

    // 4. 변환된 이미지 픽셀 nomalize(정규화)
    // 640x640 이미지에서 각 픽셀값을 가져와서
    // 0~255 사이의 값인 RGB 값을 0~1 로 변환
    final imgNormalized = List.generate(
      640,
      (y) => List.generate(640, (x) {
        final pixel = imgResized.getPixel(x, y);
        return [pixel.rNormalized, pixel.gNormalized, pixel.bNormalized];
      }),
    );

    final output = [
      List<List<double>>.filled(4 + _numClasses!, List<double>.filled(8400, 0)),
    ];
    _interpreter!.run([imgNormalized], output);
    // 원본 이미지 사이즈 넘기기!!!
    return YoloHelper.parse(output[0], image.width, image.height);
  }
}
