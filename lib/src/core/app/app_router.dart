import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../module/chat/presentation/chatting_page.dart';
import '../../module/estimate/domain/model/estimate.dart';
import '../../module/estimate/presentation/estimate_detail_page.dart';
import '../../module/home/home_page.dart';
import '../../module/invoice/domain/model/invoice.dart';
import '../../module/invoice/presentation/invoice_detail_page.dart';
import '../../module/splash/splash_page.dart';
import '../../module/term/presentation/term_page.dart';
import '../../module/proposal/domain/model/proposal.dart';
import '../../module/proposal/presentation/proposal_detail/proposal_detail_page.dart';
import '../datasource/local/hive/term_hive_repository.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, path: '/'),
    AutoRoute(page: HomeRoute.page),

    AutoRoute(page: InvoiceDetailRoute.page),

    AutoRoute(page: ChattingRoute.page),
    AutoRoute(page: EstimateDetailRoute.page),

    AutoRoute(page: TermRoute.page),
    AutoRoute(page: ProposalDetailRoute.page),
  ];
}
