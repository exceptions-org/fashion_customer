import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/model/review_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/review_card.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final String productId;
  static const String routeName = "ReviewScreen";
  const ReviewScreen(this.productId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58),
        child: CustomAppBar(
          isCenterTitle: true,
          title: "Reviews",
          isleading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                'Icons/Arrow.png',
                color: KConstants.kPrimary100,
              )),
          isaction: [Icon(Icons.abc)],
        ),
      ),

      body: StreamBuilder<QuerySnapshot<ReviewModel>>(
        stream: FirebaseFirestore.instance
            .collection("reviews")
            .orderBy('createdAt', descending: true)
            .where("productId", arrayContains: productId)
            .withConverter<ReviewModel>(
                fromFirestore: (snapshot, options) =>
                    ReviewModel.fromMap(snapshot.data()!),
                toFirestore: (reviews, options) => reviews.toMap())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No Reviews"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return ReviewCard(
                  reviewModel: snapshot.data!.docs[index].data(),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
