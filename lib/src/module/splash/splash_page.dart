import 'package:auto_route/auto_route.dart';
import 'package:construction_estimator/src/common/widgets/app_text.dart';
import 'package:flutter/material.dart';
import '../../../generated/colors.gen.dart';
import '../../common/utils/getit_utils.dart';
import '../../core/datasource/local/shared_prederences/storage.dart';
import '../../core/app/app_router.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  SplashPage({super.key}) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    await Future.delayed(Duration(seconds: 2));

    final isFirstTimeOnApp = AppStorage.isFirstTimeOnApp;
    if (isFirstTimeOnApp) {
      AppStorage.setFirstTimeOnApp(false);
    }
    getIt<AppRouter>().replaceAll([HomeRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.primary,
      body: Center(
        child: AppText(
          'Construction Estimator',
          fontSize: 24,
          textColor: ColorName.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
