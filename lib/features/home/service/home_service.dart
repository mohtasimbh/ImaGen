import 'package:imagen/product/enum/service_paths.dart';
import 'package:dio/dio.dart';

import '../model/ai_model.dart';
import '../../../core/init/network/network_manager.dart';

class HomeService {
  static HomeService? _instance;
  static HomeService get instance => _instance ??= HomeService._init();
  HomeService._init();

  Future getImage({required String prompt, required String apiKey}) async {
    return await NetworkManager.instance?.dioPost(
      ServicePaths.imageGenerator.path,
      options: Options(
        headers: {
          "Authorization": "Bearer $apiKey",
          'Content-Type': 'application/json',
        },
      ),
      data: {
        "prompt": prompt,
        "n": 10,
        "size": "512x512",
      },
      model: DallEModel(),
    );
  }
}
