import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/model/product_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:fashion_customer/views/custom_grid_view.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class WishlistWidget extends StatelessWidget {
  WishlistWidget({Key? key}) : super(key: key);

  final UserController userController = getIt.get<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58),
        child: CustomAppBar(
          isaction: [Icon(Icons.abc)],
          title: "Wishlist",
          isCenterTitle: true,
          isleading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "Icons/Arrow.png",
              color: KConstants.kPrimary100,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: StreamBuilder<QuerySnapshot<ProductModel>>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .withConverter<ProductModel>(
                    fromFirestore: (snapshot, options) =>
                        ProductModel.fromMap(snapshot.data()!),
                    toFirestore: (product, options) => product.toMap())
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("something went wrong"),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                List<ProductModel> products = snapshot.data!.docs
                    .map((e) => e.data())
                    .where((element) =>
                        userController.userModel.wishList.contains(element.id))
                    .toList();
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No Product Found",
                    ),
                  );
                }
                return CustomGridView(onTap: () {}, products: products);
              }
              return const Center(child: Text('Loading...'));
            }),
      ),
    );
  }
}
