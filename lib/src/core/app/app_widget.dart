import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../generated/l10n.dart';
import '../../common/theme/app_theme.dart';
import '../../common/theme/app_theme_wrapper.dart';
import '../../common/utils/getit_utils.dart';

import '../../module/invoice/cubit/invoice_cubit.dart';
import '../language/cubit/language_cubit.dart';
import '../language/service/language.dart';
import 'app_router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<InvoiceCubit>()),
        BlocProvider(create: (context) => getIt<LanguageCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            child: BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return AppThemeWrapper(
                  appTheme: AppTheme.create(),
                  builder: (BuildContext context, ThemeData themeData) {
                    return MaterialApp.router(
                      supportedLocales: state.languages
                          .map((e) => e.locale)
                          .toList(),
                      locale: state.language.locale,
                      localizationsDelegates: const [
                        S.delegate,
                        FlutterQuillLocalizations.delegate,
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
