import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class StreamFirestoreServerCacheQueryBuilder<T> extends StatefulWidget {
  const StreamFirestoreServerCacheQueryBuilder({
    super.key,
    required this.query,
    required this.builder,
    required this.emptyBuilder,
    this.loader,
    this.widget,
  });

  final Widget Function(
    BuildContext context,
    FirestoreQueryBuilderSnapshot<T> querySnapshot,
    Widget? widget,
  ) builder;

  final Widget Function(
    BuildContext context,
    FirestoreQueryBuilderSnapshot<T> querySnapshot,
  )? loader;

  final Widget Function(
    BuildContext context,
    FirestoreQueryBuilderSnapshot<T> querySnapshot,
  ) emptyBuilder;

  final Query<T> query;
  final Widget? widget;

  @override
  StreamFirestoreServerCacheQueryBuilderState<T> createState() =>
      StreamFirestoreServerCacheQueryBuilderState<T>();
}

class StreamFirestoreServerCacheQueryBuilderState<T>
    extends State<StreamFirestoreServerCacheQueryBuilder<T>> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  late Future<QuerySnapshot<T>> querySnapshot = Utils.futureCacheServerFirestoreQuery(widget.query);

  late Query<T> query = widget.query;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<T>(
      query: widget.query,
      pageSize: 20,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          if (widget.loader != null) {
            return widget.loader!(context, snapshot);
          }

          return LoadingGrid(width: Get.width - 20);
        }

        if (snapshot.hasData) {
          return Column(
            children: [
              if (snapshot.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.wifi_off),
                    tileColor: Get.theme.colorScheme.errorContainer,
                    title: Text(RCCubit.instance.getText(R.noInternetConnection)),
                    // trailing: TextButton(
                    //   onPressed: () {
                    //     snapshot.reloadPage();
                    //   },
                    //   child: Text(RCCubit.instance.getText(R.reload)),
                    // ),
                  ),
                ),
              if (snapshot.docs.isEmpty)
                widget.emptyBuilder(context, snapshot)
              else
                Expanded(child: widget.builder(context, snapshot, widget.widget)),
            ],
          );
        }

        if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // if (snapshot.error is LocationPermanentlyDeniedException)
              //   const LocationDeniedPermanentlyWidget()
              // else if (snapshot.error is LocationDeniedException)
              //   const LocationDeniedWidget()
              // else if (snapshot.error is LocationDisabledException)
              //   const LocationDisableWidget(),
              const NoNetworkWidget(),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       TextButton(
              //         onPressed: () {
              //           snapshot.reloadPage();
              //         },
              //         child: Text(
              //           RCCubit.instance.getText(R.reload),
              //           style: Get.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class NoNetworkWidget extends StatefulWidget {
  const NoNetworkWidget({super.key});

  @override
  State<NoNetworkWidget> createState() => _NoNetworkWidgetState();
}

class _NoNetworkWidgetState extends State<NoNetworkWidget> {
  @override
  Widget build(BuildContext context) {
    return DoubleCirclesWidget(
      title: RCCubit.instance.getText(R.cantReachNetwork),
      description: RCCubit.instance.getText(R.pleaseCheckYourNetworkNTryAgain),
      child: const Icon(
        Icons.wifi_off_rounded,
        color: Colors.white,
        size: 70,
      ),
    );
  }
}
