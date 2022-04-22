import 'package:fashion_customer/model/review_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel reviewModel;
  const ReviewCard({Key? key, required this.reviewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: KConstants.defContainerDec,
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'Icons/User.png',
                color: KConstants.txtColor75,
              ),
              Text(reviewModel.userName,
                  style: TextStyle(color: KConstants.txtColor100)),
              Spacer(),
              Text(
                  DateFormat('dd MMM yyyy')
                      .format(reviewModel.createdAt.toDate()),
                  style: TextStyle(color: KConstants.txtColor100)),
            ],
          ),
          SmoothStarRating(
            rating: reviewModel.rating,
            color: KConstants.txtColor75,
            borderColor: KConstants.txtColor75,
            defaultIconData: Icons.star_border,
          ),
          if (reviewModel.heading.isNotEmpty) ...[
            SizedBox(
              height: 10,
            ),
            Text(
              reviewModel.heading,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
          if (reviewModel.review.isNotEmpty) ...[
            SizedBox(
              height: 10,
            ),
            Text(
              reviewModel.review,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
          if (reviewModel.images.isNotEmpty) ...[
            SizedBox(
              height: 15,
            ),
            Text('Images Uploaded'),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: reviewModel.images
                    .map((e) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Scaffold(
                                        body: Center(
                                          child: Hero(
                                              tag: e,
                                              child: InteractiveViewer(
                                                  child: Image.network(e))),
                                        ),
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Hero(
                              tag: e,
                              child: Image.network(
                                e,
                                height: 160,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )))
                    .toList(),
              ),
            )
          ]
        ],
      ),
    );
  }
}
