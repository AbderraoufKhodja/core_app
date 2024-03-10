import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/mini_apps/translator_app/translator_app.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/my_seller_store_page.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/ui/register_business_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';

class ExpertPage extends StatefulWidget {
  const ExpertPage({super.key});

  @override
  ExpertPageState createState() => ExpertPageState();
}

class ExpertPageState extends State<ExpertPage> with AutomaticKeepAliveClientMixin<ExpertPage> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_currentUser?.businessType == null) return const RegisterBusinessPage();
    if (_currentUser?.businessType == BusinessTypes.translator.name) return const TranslatorApp();

    if (_currentUser?.businessType == BusinessTypes.retailer.name) {
      return FutureBuilder<DocumentSnapshot<Store>>(
        future: Store.ref.doc(_currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingGrid(width: _size.width);
          }
          if (snapshot.hasError) {
            //TODO: build no data widget
            print(snapshot.error);
            return const SizedBox();
          }

          if (snapshot.data?.data() != null) {
            final store = snapshot.data!.data()!;
            return MySellerStorePage(store: store);
          } else {
            return Center(
              child: Text(RCCubit.instance.getText(R.oops)),
            );
          }
        },
      );
    }

    return const SizedBox();
  }
}
