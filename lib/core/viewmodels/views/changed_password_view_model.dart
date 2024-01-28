// import 'package:mostlyrx/core/services/authentication_service.dart';
// import 'package:mostlyrx/core/viewmodels/base_model.dart';

// class ChangePasswordViewModel extends BaseModel {
//   final AuthenticationService _authenticationService;
//   ChangePasswordViewModel({
//     required AuthenticationService authenticationService,
//   }) : _authenticationService = authenticationService;
//   Future<bool> changedPasswordInViewModel(
//       String newpassword, String email) async {
//     setBusy(true);
//     var success =
//         await _authenticationService.changedPasswordInAuth(newpassword, email);
//     setBusy(false);
//     return success;
//   }
// }
