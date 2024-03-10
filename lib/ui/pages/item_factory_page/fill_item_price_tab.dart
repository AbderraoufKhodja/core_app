import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: check images picker missmatch images
class FillItemPriceTab extends StatefulWidget {
  const FillItemPriceTab({super.key});

  @override
  FillItemPriceTabState createState() => FillItemPriceTabState();
}

class FillItemPriceTabState extends State<FillItemPriceTab>
    with AutomaticKeepAliveClientMixin<FillItemPriceTab> {
  @override
  bool get wantKeepAlive => true;
  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        children: widgets
            .map(
              (widget) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: widget,
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> get widgets => <Widget>[];
}
