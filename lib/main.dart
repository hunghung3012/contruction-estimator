import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/common/utils/app_environment.dart';
import 'src/common/utils/getit_utils.dart';
import 'src/core/app/app_widget.dart';
import 'src/core/datasource/local/hive/hive_service.dart';
import 'src/core/datasource/local/shared_prederences/storage.dart';
import 'src/core/only_one_point_widget.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      await AppEnvironment.setup();
      await AppStorage.setup();
      await GetItUtils.setup();
      await getIt<HiveService>().setup();

      await initializeDateFormatting();

      final talker = getIt<Talker>();
      _setupErrorHooks(talker);

      Bloc.observer = TalkerBlocObserver(talker: talker);

      runApp(OnlyOnePointerRecognizerWidget(child: AppWidget()));

      AppStorage.setUserId('H415iT0ZltboZsygjIZN');
    },
    (error, stack) {
      getIt<Talker>().handle(error, stack);
    },
  );
}

Future _setupErrorHooks(Talker talker, {bool catchFlutterErrors = true}) async {
  if (catchFlutterErrors) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      _reportError(details.exception, details.stack, talker);
    };
  }
  PlatformDispatcher.instance.onError = (error, stack) {
    _reportError(error, stack, talker);
    return true;
  };

  /// Web doesn't have Isolate error listener support
  if (!kIsWeb) {
    Isolate.current.addErrorListener(
      RawReceivePort((dynamic pair) async {
        final isolateError = pair as List<dynamic>;
        _reportError(
          isolateError.first.toString(),
          isolateError.last.toString(),
          talker,
        );
      }).sendPort,
    );
  }
}

void _reportError(dynamic error, dynamic stackTrace, Talker talker) async {
  talker.error('Unhandled Exception', error, stackTrace);
}
