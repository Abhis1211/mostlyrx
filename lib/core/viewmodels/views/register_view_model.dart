import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/core/viewmodels/base_model.dart';

class RegisterViewModel extends BaseModel {
  final AuthenticationService _authenticationService;

  RegisterViewModel({
    required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Future<bool> register(String username, String password, String email,
      String address, String contact, double latitude, double longitude) async {
    setBusy(true);
    await _authenticationService.register();
    setBusy(false);
    return true;
  }
}
