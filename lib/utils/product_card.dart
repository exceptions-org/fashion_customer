import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_customer/model/product_model.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import 'constants.dart';

class ProductCard extends StatelessWidget {
  final ProductModel data;
  final bool notFromHome;
  final VoidCallback onTap;
  const ProductCard(
      {Key? key,
      required this.data,
      this.notFromHome = false,
      required this.onTap})
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
          ).then((value) {
            onTap();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blueGrey.shade100,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          height: height * 0.100,
          width: width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.15,
                width: 142,
                margin: const EdgeInsets.only(top: 10, left: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        data.images.first.images.first),
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
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text("Rating : "),
                    SmoothStarRating(size: 18, rating: data.rating),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
