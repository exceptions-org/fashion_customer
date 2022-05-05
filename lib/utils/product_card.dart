import 'package:fashion_customer/model/product_model.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class ProductCard extends StatelessWidget {
  final ProductModel data;
  final bool notFromHome;
  const ProductCard({Key? key, required this.data, this.notFromHome = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductDetails(
                productModel: data,
                notFromHome: notFromHome,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blueGrey.shade100,
              // width: 1,
            ),
            // color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          //margin: const EdgeInsets.all(10),
          // padding: const EdgeInsets.all(8),
          height: height * 0.100,

          width: width * 0.4,
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.15,
                width: 142,
                // padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(top: 10, left: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(data.images.first.images.first),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    data.name.toTitleCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Rs. ${data.prices.first.colorPrice.first.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: KConstants.kPrimary100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Rs. ${data.highPrice}",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              /* Container(
                                              height: 50,
                                              width: 162,
                                              decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                                              ),
                                              child: const Center(
                        child: Text(
                          "NameOfProduct",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                                              ),
                                            ), */
            ],
          ),
        ),
      ),
    );
  }
}
