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
      /*  AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Wishlist',
          style:
              GoogleFonts.montserratAlternates(color: KConstants.kPrimary100),
        ),
        leading: IconButton(
          icon: Image.asset(
            "Icons/Arrow.png",
            color: KConstants.kPrimary100,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ), */
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

              // if (snapshot.data!.docs.isEmpty) {
              //   return Center(child: Text("No such Product Found"));
              // }
              if (snapshot.hasData && snapshot.data != null) {
                List<ProductModel> products = snapshot.data!.docs
                    .map((e) => e.data())
                    .where((element) =>
                        userController.userModel.wishList.contains(element.id))
                    .toList();
                // var productLength = snapshot.data!.docs.length;
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No Product Found",
                      //  style: TextStyle(fontSize: 20),
                    ),
                  );
                }
                return CustomGridView(products: products);
              }
              return const Center(child: Text('Loading...'));
            }),
      ),
    );
  }
}
