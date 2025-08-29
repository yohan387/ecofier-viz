import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_summary/get_weighing_summary_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/app_options_selector.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_list.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

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

              const WeighingSummary(),

              const WeighingList(),

              const Center(
                child: Text("By Ecofier",
                    style: TextStyle(
                      color: AppColors.green1,
                      fontStyle: FontStyle.italic,
                    )),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
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
                          Text(
                            widget.user.fullName,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
