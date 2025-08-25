import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/presentation/authentication/state/login_cubit/login_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_summary/get_weighing_summary_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/app_options_selector.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_summary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<GetWeighingSummaryCubit>().getWeighingSummary();
    context.read<GetWeighingListCubit>().getWeighingList();
  }

  static const _filtersOptionList = [
    {
      "id": "1",
      "code": "D'aujourd'hui",
    },
    {
      "id": "2",
      "code": "De la semaine",
    },
    {
      "id": "3",
      "code": "Du mois",
    },
    {
      "id": "4",
      "code": "Autre",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<GetWeighingSummaryCubit>().getWeighingSummary();
          context.read<GetWeighingListCubit>().getWeighingList();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bannière image
              _buildBanner(),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Pesées",
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.green2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppOptionSelector(
                dataList: _filtersOptionList,
                value: (value) {},
              ),
              const SizedBox(height: 16),
              _buildWeighingSummary(),

              // Create history
              _buildWeighingList(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildWeighingList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Historique",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.green2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Item $index"),
              );
            },
          ),
        ],
      ),
    );
  }

  Container _buildWeighingSummary() {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Résumé",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.green2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<GetWeighingSummaryCubit, GetWeighingSummaryState>(
            builder: (context, state) {
              if (state is GetWeighingSummaryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetWeighingSummarySuccess) {
                final summary = state.summary;
                return GridView(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                  ),
                  children: [
                    WeighingSummaryItem(
                      title: "Poids net",
                      value: summary.totalWeight.toString(),
                      icon: Image.asset(
                        'lib/core/assets/weight-scale.png',
                        fit: BoxFit.cover,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: Icon(Icons.image, size: 80)),
                        ),
                      ),
                    ),
                    WeighingSummaryItem(
                        title: "Revenu",
                        value: summary.totalItems.toString(),
                        icon: Image.asset(
                          'lib/core/assets/low-income.png',
                          fit: BoxFit.cover,
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[300],
                            child: const Center(
                                child: Icon(Icons.image, size: 80)),
                          ),
                        )),
                    WeighingSummaryItem(
                      title: "Anomalies",
                      value: summary.lastUpdated.toString(),
                      icon: Image.asset(
                        'lib/core/assets/alert.png',
                        fit: BoxFit.cover,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: Icon(Icons.image, size: 80)),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  SizedBox _buildBanner() {
    return SizedBox(
      height: 216,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(64),
            ),
            child: Image.asset(
              'lib/core/assets/bg_1.jpeg',
              fit: BoxFit.cover,
              height: 192,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image, size: 80)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.green1),
                borderRadius: BorderRadius.circular(38),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.green1,
                size: 32,
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Akwaba,",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              if (state is LoginSuccess) {
                                return Text(
                                  state.user.username,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          color: AppColors.white,
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                        ),
                        IconButton(
                          color: AppColors.white,
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
