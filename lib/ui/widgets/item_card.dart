import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> with AutomaticKeepAliveClientMixin<ItemCard> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhotoWidgetNetwork(
            label: null,
            photoUrl: widget.item.photoUrls?[0],
            loadingWidth: Get.width / 2.1,
            loadingHeight: Get.height / 4,
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 2),
            title: Text(widget.item.title!, maxLines: 1),
            subtitle: Text(widget.item.description!, maxLines: 2),
            dense: true,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${widget.item.price!.toStringAsFixed(0)} ${widget.item.currency ?? ''} ',
                    maxLines: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: PopupMenuButton<String>(
                      child: const Icon(Icons.more_horiz),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<String>(
                            value: RCCubit.instance.getText(R.contact),
                            child: Text(RCCubit.instance.getText(R.contact)),
                            onTap: () => Future.delayed(const Duration(milliseconds: 50)).then(
                              (value) {
                                final typeChatID = '${ChatTypes.shopping.name}_${Utils.getUniqueID(
                                  firstID: _currentUser!.uid,
                                  secondID: widget.item.storeID!,
                                )}';

                                showMessagingPage(
                                  chatID: typeChatID,
                                  type: ChatTypes.shopping,
                                  otherUserID: widget.item.storeOwnerID!,
                                );
                              },
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: RCCubit.instance.getText(R.updateStoreInfo),
                            child: Text(RCCubit.instance.getText(R.addFavorite)),
                            onTap: () {},
                          ),
                        ];
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
