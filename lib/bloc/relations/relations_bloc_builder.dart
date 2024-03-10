import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

export 'package:fibali/bloc/relations/bloc.dart';

class RelationsCubitBuilder extends StatelessWidget {
  const RelationsCubitBuilder({super.key, required this.onRelationsBuilder});

  final Widget Function(RelationsLoaded state) onRelationsBuilder;

  @override
  Widget build(BuildContext context) {
    final relationsCubit = BlocProvider.of<RelationsCubit>(context);

    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return BlocBuilder<RelationsCubit, RelationsState>(
      builder: (context, state) {
        if (state is RelationsInitial) {
          relationsCubit.initStream(userID: currentUser!.uid);
          return LoadingGrid(width: Get.width - 16);
        }

        if (state is RelationsLoading) {
          return LoadingGrid(width: Get.width - 16);
        }

        if (state is RelationsLoaded) {
          return onRelationsBuilder(state);
        }

        return Center(child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong)));
      },
    );
  }
}
