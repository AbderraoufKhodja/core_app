import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/delivery_address/delivery_address_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/add_delivery_address_page.dart';
import 'package:fibali/ui/pages/edit_delivery_address_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/delivery_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DeliveryAddressesPage extends StatefulWidget {
  const DeliveryAddressesPage({super.key});

  static Future<dynamic>? show({required String userID}) async {
    return Get.to(() => BlocProvider(
        create: (context) => DeliveryAddressCubit(userID: userID),
        child: const DeliveryAddressesPage()));
  }

  @override
  DeliveryAddressesPageState createState() => DeliveryAddressesPageState();
}

// TODO add set default address interface
class DeliveryAddressesPageState extends State<DeliveryAddressesPage> {
  DeliveryAddressCubit get _delAddCubit => BlocProvider.of<DeliveryAddressCubit>(context);

  @override
  void initState() {
    super.initState();
    _delAddCubit.getDeliveryAddress();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryAddressCubit, DeliveryAddressState>(
      builder: (context, state) {
        if (state is DeliveryAddressEdit) {
          return EditDeliveryAddressPage(address: state.address);
        }
        if (state is DeliveryAddressAdd) {
          return const AddDeliveryAddressPage();
        }
        if (state is DeliveryAddressDisplay) {
          return Scaffold(
            appBar: AppBar(
              title: Text(RCCubit.instance.getText(R.deliveryAddress)),
              leading: const PopButton(),
            ),
            bottomNavigationBar: BottomAppBar(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _delAddCubit.showAddPage(),
                child: Text(RCCubit.instance.getText(R.addDeliveryAddress)),
              ),
            ),
            body: StreamBuilder<QuerySnapshot<DeliveryAddress>>(
              stream: _delAddCubit.addresses,
              builder: (context, snapshot) {
                if (snapshot.hasError) return const SizedBox();

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.data!.docs.isEmpty) return Text(RCCubit.instance.getText(R.empty));

                final delAddWidgets = snapshot.data!.docs
                    .map((delAddDoc) => delAddDoc.data())
                    .where((delAdd) => delAdd.isValid())
                    .map(
                      (delAdd) => ListTile(
                        onTap: () => _delAddCubit.showEditPage(
                          address: delAdd,
                        ),
                        title: Text('${delAdd.name!} : ${delAdd.phoneNumber!}'),
                        subtitle: Text(
                            '${delAdd.province!}, ${delAdd.subProvince!}, ${delAdd.streetAddress!}'),
                        trailing: const FaIcon(FontAwesomeIcons.penToSquare),
                      ),
                    )
                    .toList();

                return delAddWidgets.isEmpty
                    ? Text(RCCubit.instance.getText(R.empty))
                    : ListView.builder(
                        itemBuilder: (context, index) => delAddWidgets[index],
                        itemCount: delAddWidgets.length,
                      );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
