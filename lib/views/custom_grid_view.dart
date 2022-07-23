import 'package:collection/collection.dart';
import 'package:fashion_customer/model/product_model.dart';
import 'package:fashion_customer/utils/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CustomGridView extends StatelessWidget {
  final List<ProductModel> products;
  final VoidCallback onTap;
  CustomGridView({Key? key, required this.products, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return AnimationLimiter(
      child: GridView.count(
          physics: BouncingScrollPhysics(),
          childAspectRatio: width / width * 0.9,
          shrinkWrap: true,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          crossAxisCount: 2,
          children: products
              .mapIndexed((i, element) => AnimationConfiguration.staggeredGrid(
                  duration: Duration(milliseconds: 350),
                  delay: Duration(milliseconds: 200),
                  columnCount: 2,
                  position: i,
                  child: ScaleAnimation(
                    child: ProductCard(
                      data: element,
                      onTap: onTap,
                    ),
                  )))
              .toList()),
    );
  }
}
