import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_categories_header.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_shopping_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AeSearchPage extends StatelessWidget {
  const AeSearchPage({super.key});

  static void show() => Get.to(() => const AeSearchPage());

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AeCategoriesHeader(),
        Expanded(child: AeShoppingItems()),
      ],
    );
  }
}
