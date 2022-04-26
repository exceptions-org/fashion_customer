import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/model/product_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class WishlistWidget extends StatelessWidget {
  WishlistWidget({Key? key}) : super(key: key);

  final UserController userController = getIt.get<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
                return GridView.count(
                  childAspectRatio: 1 / 1.2,
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  crossAxisCount: 2,
                  children: products.map((e) => ProductCard(data: e)).toList(),
                );
              }
              return const Center(child: Text('Loading...'));
            }),
      ),
    );
  }
}
