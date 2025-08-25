import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

class WeighingList extends StatelessWidget {
  const WeighingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          _builWeighingList(),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 164,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 227, 236, 227),
                  borderRadius: BorderRadius.circular(16)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Text(
                      "Rechercher",
                      style: TextStyle(color: AppColors.green1),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.zoom_in,
                    color: AppColors.green1,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  BlocBuilder<GetWeighingListCubit, GetWeighingListState> _builWeighingList() {
    return BlocBuilder<GetWeighingListCubit, GetWeighingListState>(
      builder: (context, state) {
        if (state is GetWeighingListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetWeighingListSuccess) {
          final weighings = state.weighings;
          return ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: weighings.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeighingDetailPage(
                        weighing: weighings[index],
                      ),
                    ),
                  );
                },
                title: Container(
                  padding: const EdgeInsets.all(4),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        weighings[index].codePesee,
                      ),
                      Text(
                        "${weighings[index].poidsNet?.toStringAsFixed(2) ?? 'N/A'} kg",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
