import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/getit_utils.dart';
import '../client/presentation/client_page.dart';
import '../invoice/presentation/invoice_page.dart';
import '../project/presentation/project_page.dart';
import '../proposal/presentation/proposal_page.dart';
import 'application/home_cubit.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              const ProjectPage(),
              const InvoicePage(),
              const ProposalPage(),
              const ClientPage(),
            ],
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) => context.read<HomeCubit>().setTabIndex(index),
            type: BottomNavigationBarType.fixed,
            // backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'Projects',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Invoices',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Proposals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Clients',
              ),
            ],
          ),
        );
      },
    );
  }
}
