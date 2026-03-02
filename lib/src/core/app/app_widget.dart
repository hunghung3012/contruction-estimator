import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../generated/l10n.dart';
import '../../common/theme/app_theme.dart';
import '../../common/theme/app_theme_wrapper.dart';
import '../../common/utils/getit_utils.dart';

import '../../module/invoice/cubit/invoice_cubit.dart';
import 'app_router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();

    return BlocProvider(
      create: (context) => getIt<InvoiceCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            child: AppThemeWrapper(
              appTheme: AppTheme.create(),
              builder: (BuildContext context, ThemeData themeData) {
                return MaterialApp.router(
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  debugShowCheckedModeBanner: false,
                  theme: themeData,
                  routerConfig: router.config(
                    navigatorObservers: () => [
                      TalkerRouteObserver(getIt<Talker>()),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
