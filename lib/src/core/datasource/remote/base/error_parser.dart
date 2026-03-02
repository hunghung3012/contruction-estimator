import '../../../../../generated/l10n.dart';

abstract interface class ErrorMessage {
  static String somethingError() => S.current.something_error;
}

// class ErrorParser {
//   static String getErrorMessage(String error) {
//     switch (error) {
//       case 'errors.provider.notfound':
//         return S.current.account_not_exist;
//       case 'errors.login.failed':
//         return S.current.incorrect_password;
//       case 'errors.provider.alreadyinuse':
//         return S.current.email_used;
//       case 'errors.password.incorrect':
//         return S.current.incorrect_password;
//       default:
//         return error;
//     }
//   }
// }
