import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:fashion_customer/model/order_model.dart';
import 'package:fashion_customer/model/review_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class AddReview extends StatefulWidget {
  final OrderModel orderModel;
  const AddReview({Key? key, required this.orderModel}) : super(key: key);

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  OrderModel get order => widget.orderModel;
  ImagePicker picker = ImagePicker();

  Container defContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: KConstants.defContainerDec,
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  double rating = 0;

  TextEditingController reviewController = TextEditingController();

  List<String> images = [];

  Widget imageContainer(String image, int i) {
    return Container(
      height: 200,
      width: 100,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.file(
            File(image),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          InkWell(
            onTap: () {
              setState(() {
                images.removeAt(i);
              });
            },
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10))),
              child: Center(
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> imageUpload(
      {required String path,
      required String orderId,
      required int milliseconds,
      required int index}) async {
    try {
      String fileName =
          "review_image_${orderId}_${milliseconds.toString() + '_' + index.toString()}" +
              '.' +
              path.split('.').last;
      Reference reference = FirebaseStorage.instance.ref();
      TaskSnapshot uploadTask = await reference
          .child('reviews/$orderId/${milliseconds}')
          .child(fileName)
          .putFile(File(path));
      String downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight * 1.5,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: Offset(0, -0.5),
              blurRadius: 4,
              color: Colors.grey.withOpacity(0.25)),
        ]),
        child: Row(
          children: [
            Spacer(),
            InkWell(
              onTap: () async {
                DateTime dt = DateTime.now();

                List<String> imagePaths = [];

                for (int i = 0; i < images.length; i++) {
                  String path = images[i];
                  String downloadUrl = await imageUpload(
                      path: path,
                      orderId: order.orderId,
                      milliseconds: dt.millisecondsSinceEpoch,
                      index: i);
                  imagePaths.add(downloadUrl);
                }

                ReviewModel reviewModel = ReviewModel(
                    createdAt: Timestamp.fromDate(dt),
                    productId: order.products.map((e) => e.productId).toList(),
                    rating: rating,
                    review: reviewController.text,
                    images: imagePaths,
                    userName: widget.orderModel.userName,
                    userPhone: widget.orderModel.userPhone);
                await FirebaseFirestore.instance
                    .collection('reviews')
                    .add(reviewModel.toMap());
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: KConstants.kPrimary100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Add Review',
          style: GoogleFonts.montserratAlternates(
            color: KConstants.kPrimary100,
          ),
        ),
      ),
      body: Column(
        children: [
          defContainer(
            children: [
              Text(
                'Rating',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff130B43),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SmoothStarRating(
                rating: rating,
                size: 40,
                borderColor: KConstants.kPrimary100,
                color: KConstants.kPrimary100,
                onRatingChanged: (e) {
                  setState(() {
                    rating = e;
                  });
                },
              ),
            ],
          ),
          defContainer(
            children: [
              Text(
                'Review',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff130B43),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 5,
                controller: reviewController,
                decoration: InputDecoration(
                  hintText: 'Tell us how you feel about our product',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          defContainer(
            children: [
              Text('Upload Images'),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...images
                        .mapIndexed((i, e) => imageContainer(e, i))
                        .toList(),
                    IconButton(
                        onPressed: () {
                          picker.pickMultiImage().then((value) {
                            if (value != null) {
                              setState(() {
                                images
                                    .addAll(value.map((e) => e.path).toList());
                              });
                            }
                          });
                        },
                        icon: Icon(Icons.add_a_photo)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
