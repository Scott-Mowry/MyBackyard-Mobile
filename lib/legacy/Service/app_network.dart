import 'dart:async';

import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/repositories/connectivity_repository.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:backyard/my-backyard-app.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

abstract class AppNetwork {
  FutureOr<Response?> networkRequest(
    String type,
    String path, {
    Map<String, String>? parameters,
    List<MultipartFile>? attachments,
  });

  void on401Error();
}

@Injectable(as: AppNetwork)
class AppNetworkImpl implements AppNetwork {
  final LocalStorageRepository _localStorageRepository;
  final ConnectivityRepository _connectivityRepository;

  const AppNetworkImpl(this._localStorageRepository, this._connectivityRepository);

  FutureOr<Response?> networkRequest(
    String type,
    String path, {
    Map<String, String>? parameters,
    List<MultipartFile>? attachments,
  }) async {
    try {
      if (!_connectivityRepository.hasInternetAccess) {
        CustomToast().showToast(message: 'No Internet Connection');
        return null;
      }

      final dynamic request =
          type == RequestTypeEnum.POST.name
              ? MultipartRequest(type, Uri.parse('${API.url}$path'))
              : Request(type, Uri.parse('${API.url}$path'));
      request.headers.addAll({'Content-Type': 'application/json'});
      if (parameters != null) request.fields.addAll(parameters);
      if (attachments != null && attachments.isNotEmpty) request.files.addAll(attachments);

      request.headers.addAll({'Accept': 'application/json'});

      final userCredentials = await _localStorageRepository.getUserCredentials();
      final bearerToken = userCredentials?.bearerToken;
      if (bearerToken != null && bearerToken.isNotEmpty) {
        request.headers.addAll({'Authorization': 'Bearer $bearerToken'});
      }

      final StreamedResponse response = await request.send().timeout(
        API.timeout,
        onTimeout: () {
          CustomToast().showToast(message: 'Network Error');
          throw TimeoutException;
        },
      );

      if (response.statusCode == 401) {
        on401Error();
        return null;
      }

      final res = await Response.fromStream(response);
      return res;
    } catch (e) {
      CustomToast().showToast(message: e.toString());
      return null;
    }
  }

  void on401Error() {
    Timer(const Duration(seconds: 1), () {
      getIt<UserController>().clear();
      MyBackyardApp.appRouter.popUntilRoot();
      MyBackyardApp.appRouter.replace(LandingRoute());
    });
  }
}
