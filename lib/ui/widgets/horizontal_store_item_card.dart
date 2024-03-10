import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalStoreItemCard extends StatefulWidget {
  const HorizontalStoreItemCard({super.key, required this.item, this.isShimmer});

  final Item? item;
  final bool? isShimmer;

  factory HorizontalStoreItemCard.shimmer() =>
      const HorizontalStoreItemCard(item: null, isShimmer: true);

  @override
  State<HorizontalStoreItemCard> createState() => _HorizontalStoreItemCardState();
}

class _HorizontalStoreItemCardState extends State<HorizontalStoreItemCard> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return widget.isShimmer == true
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: _buildShoppingItem(),
          )
        : _buildShoppingItem();
  }

  Widget _buildShoppingItem() {
    return SizedBox(
      height: _size.height / 8,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item?.title! ?? kFaker.lorem.sentence(),
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        widget.item?.description! ?? kFaker.lorem.sentences(2).join(),
                        maxLines: 3,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Stack(
                  fit: StackFit.passthrough,
                  alignment: Alignment.topRight,
                  children: [
                    PhotoWidget.network(
                      photoUrl: widget.item?.photoUrls?[0],
                      loadingWidth: _size.height / 8,
                      loadingHeight: _size.height / 8,
                      width: _size.height / 8,
                      height: _size.height / 8,
                      boxShape: BoxShape.rectangle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          widget.item != null
                              ? PopupMenuButton<String>(
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.black45,
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: RCCubit.instance.getText(R.contact),
                                        child: Text(RCCubit.instance.getText(R.contact)),
                                        onTap: () =>
                                            Future.delayed(const Duration(milliseconds: 50)).then(
                                          (value) {
                                            final typeChatID = ChatTypes.shopping.name +
                                                '_' +
                                                Utils.getUniqueID(
                                                  firstID: _currentUser!.uid,
                                                  secondID: widget.item!.storeID!,
                                                );
                                            showMessagingPage(
                                              chatID: typeChatID,
                                              type: ChatTypes.shopping,
                                              otherUserID: widget.item!.storeOwnerID!,
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
                                )
                              : const Icon(Icons.more_horiz),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 1.0, right: 3.0, left: 3.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.deepOrange.shade300,
                        Colors.deepOrangeAccent,
                      ],
                    ),
                  ),
                  child: Text(
                    (widget.item?.price!.toStringAsFixed(0) ?? kFaker.lorem.word()) +
                        ' ' +
                        (widget.item?.currency ?? ''),
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
