import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/model/order_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/generate_pdf.dart';
import 'package:fashion_customer/views/add_review.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cached_network_image/cached_network_image.dart';
class ViewOrders extends StatefulWidget {
  final String userPhone;
  ViewOrders({Key? key, required this.userPhone}) : super(key: key);

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  OrderModel? orderModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            'Your Orders',
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
          bottom: TabBar(
            indicatorColor: Colors.transparent,
            indicator: BoxDecoration(
              color: Colors.transparent,
            ),
            indicatorWeight: 0,
            labelPadding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: double.infinity,
                color: KConstants.textColor25,
                alignment: Alignment.center,
                height: kTextTabBarHeight,
                child: Text(
                  'Ongoing',
                  style: GoogleFonts.montserrat(
                      color: _tabController.index == 0
                          ? KConstants.kPrimary100
                          : KConstants.kPrimary75,
                      fontWeight: _tabController.index == 0
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: double.infinity,
                color: KConstants.textColor25,
                alignment: Alignment.center,
                height: kTextTabBarHeight,
                child: Text(
                  'Completed',
                  style: GoogleFonts.montserrat(
                      color: _tabController.index == 1
                          ? KConstants.kPrimary100
                          : KConstants.kPrimary75,
                      fontWeight: _tabController.index == 1
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
            ],
            controller: _tabController,
          ),
        ),
        body: StreamBuilder<QuerySnapshot<OrderModel>>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('userPhone', isEqualTo: widget.userPhone)
              .orderBy('createdAt', descending: true)
              .withConverter(
                  fromFirestore: (snapshot, options) =>
                      OrderModel.fromMap(snapshot.data()!),
                  toFirestore: (OrderModel document, options) =>
                      document.toMap())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Orders Yet'),
              );
            }
            List<OrderModel> ongoing = snapshot.data!.docs
                .where((element) =>
                    element.data().orderState != OrderState.delivered &&
                    element.data().orderState != OrderState.cancel)
                .map((e) => e.data())
                .toList();
            List<OrderModel> completed = snapshot.data!.docs
                .where((element) =>
                    element.data().orderState == OrderState.delivered ||
                    element.data().orderState == OrderState.cancel)
                .map((e) => e.data())
                .toList();
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                if (ongoing.isEmpty)
                  Center(
                    child: Text('No Orders Yet'),
                  )
                else
                  ListView(
                    shrinkWrap: true,
                    children: ongoing
                        .map((element) => OrderCard(
                              order: element,
                              viewDetails: (order) {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        OrderDetails(order: order),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                if (completed.isEmpty)
                  Center(
                    child: Text('No Orders Yet'),
                  )
                else
                  ListView(
                    shrinkWrap: true,
                    children: completed
                        .map((element) => OrderCard(
                              order: element,
                              viewDetails: (order) {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        OrderDetails(order: order),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  )
              ],
            );
          },
        ));
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final Function(OrderModel) viewDetails;
  const OrderCard({Key? key, required this.order, required this.viewDetails})
      : super(key: key);

  String orderState() {
    switch (order.orderState) {
      case OrderState.placed:
        return 'Order Placed';
      case OrderState.confirmed:
        return 'Order Confirmed';
      case OrderState.outForDelivery:
        return 'Out for Delivery';
      case OrderState.delivered:
        return 'Delivered';
      case OrderState.cancel:
        return 'Order Cancelled';

      default:
        return 'Order Placed';
    }
  }

  Color getStateColor() {
    switch (order.orderState) {
      case OrderState.placed:
      case OrderState.confirmed:
      case OrderState.outForDelivery:
      case OrderState.delivered:
        return KConstants.greenOrderState;
      case OrderState.cancel:
        return Colors.red;
      default:
        return KConstants.greenOrderState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        viewDetails(order);
      },
      child: Container(
        margin: EdgeInsets.only(top: 8),
        decoration: KConstants.defContainerDec,
        padding: EdgeInsets.all(25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID ${order.orderId}', textScaleFactor: 1.1),
                SizedBox(
                  height: 7,
                ),
                Text(
                  DateFormat('hh:mm a, dd MMMM, yyyy')
                      .format(order.createdAt.toDate()),
                  style: TextStyle(color: KConstants.textColor50),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  orderState(),
                  style: TextStyle(color: getStateColor()),
                ),
                if ([OrderState.confirmed, OrderState.outForDelivery]
                    .contains(order.orderState)) ...[
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    'Expected Delivery by: ' +
                        DateFormat(
                                (order.orderState == OrderState.outForDelivery
                                        ? 'hh:mm a,'
                                        : '') +
                                    'dd MMMM, yyyy')
                            .format(order.deliveryDate.toDate()),
                    style: TextStyle(color: KConstants.textColor50),
                  ),
                ]
              ],
            ),
            Icon(
              Icons.navigate_next,
              color: KConstants.kPrimary100,
            )
          ],
        ),
      ),
    );
  }
}

class OrderDetails extends StatefulWidget {
  final OrderModel order;
  const OrderDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isCancellation = false;

  List<String> cancellationReasons = [
    'Want to change the order',
    'High Price',
    'Other'
  ];

  TextEditingController rController = TextEditingController();

  String reason = '';

  String orderState() {
    switch (widget.order.orderState) {
      case OrderState.placed:
        return 'Order Placed';
      case OrderState.confirmed:
        return 'Order Confirmed';
      case OrderState.outForDelivery:
        return 'Out for Delivery';
      case OrderState.delivered:
        return 'Delivered';
      case OrderState.cancel:
        return 'Order Cancelled';

      default:
        return 'Order Placed';
    }
  }

  Color getStateColor() {
    switch (widget.order.orderState) {
      case OrderState.placed:
      case OrderState.confirmed:
      case OrderState.outForDelivery:
      case OrderState.delivered:
        return KConstants.greenOrderState;

      case OrderState.cancel:
        return Colors.red;
      default:
        return KConstants.greenOrderState;
    }
  }

  Widget loadinWidget(String text) {
    return AbsorbPointer(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              Text(
                text,
                style: TextStyle(color: KConstants.textColor50),
              )
            ],
          ),
        ),
      ),
    );
  }

  String loadingText = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    Size size = media.size;
    var height = size.height;
    var width = size.width;
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            if (!isCancellation)
              return true;
            else {
              setState(() {
                isCancellation = false;
              });
              return false;
            }
          },
          child: Scaffold(
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
                  InkWell(
                    onTap: () async {
                      Uint8List list = await generatePdf(widget.order);
                      await FileSaver.instance.saveAs(
                          widget.order.orderId, list, 'pdf', MimeType.PDF);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: KConstants.kPrimary100),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Download Invoice',
                            style: TextStyle(
                                color: KConstants.kPrimary100, fontSize: 20),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.download,
                            color: KConstants.kPrimary100,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  if (![OrderState.cancel, OrderState.delivered]
                      .contains(widget.order.orderState))
                    InkWell(
                      onTap: () async {
                        if (!isCancellation) {
                          setState(() {
                            isCancellation = true;
                          });
                        } else {
                          setState(() {
                            loadingText = 'Cancelling Order';
                            isLoading = true;
                          });
                          DocumentSnapshot<OrderModel> orderModel =
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(widget.order.orderDocId)
                                  .withConverter(
                                      fromFirestore: (snapshot, options) =>
                                          OrderModel.fromMap(snapshot.data()!),
                                      toFirestore: (v, s) => {})
                                  .get();
                          if (orderModel.data()!.orderState.index <
                              OrderState.outForDelivery.index) {
                            String finalReason =
                                reason == cancellationReasons.last
                                    ? rController.text
                                    : reason;
                            FirebaseFirestore.instance
                                .collection('orders')
                                .doc(widget.order.orderDocId)
                                .update({
                              'orderState': OrderState.cancel.index,
                              'cancelledByUser': true,
                              'cancellationReason': finalReason
                            });



                          
                                KConstants.sendFCMMessage(
                                    'Order Cancelled',
                                    'Order ${orderModel.data()!.orderId} was cancelled by user because $finalReason',
                                    "/topics/admin");
                              

                            setState(() {
                              loadingText = '';
                              isLoading = false;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Order Cancelled')));
                          } else {
                            setState(() {
                              loadingText = '';
                              isLoading = false;
                              isCancellation = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Order Cannot be cancelled now')));
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: KConstants.kPrimary100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Cancel Order',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  else if (widget.order.orderState == OrderState.delivered)
                    InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      AddReview(orderModel: widget.order)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: KConstants.kPrimary100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Review',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ))
                ],
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(58),
              child: CustomAppBar(
                isaction: [Icon(Icons.abc)],
                title: "Your Orders",
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

            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: KConstants.defContainerDec,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID ${widget.order.orderId}',
                            textScaleFactor: 1.1),
                        Text(
                          DateFormat('hh:mm a, dd MMMM, yyyy')
                              .format(widget.order.createdAt.toDate()),
                          style: TextStyle(color: KConstants.textColor50),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: widget.order.products.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.0),
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xffC8D5EF),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 120,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffC8D5EF),
                                    ),
                                  ),
                                  child:  CachedNetworkImage(
                              imageUrl: 
                                    widget.order.products[index].image.first,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.products[index].name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "Price: ${widget.order.products[index].price}",
                                      style: TextStyle(
                                          color: Color(0xff604FCC),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (widget.order.products[index]
                                            .selectedSize !=
                                        '') ...[
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        "Selected Size: ${widget.order.products[index].selectedSize}",
                                        style: TextStyle(
                                            color: Color(0xff604FCC),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                    Row(
                                      children: [
                                        Text(
                                          "Selected Colour:",
                                          style: TextStyle(
                                              color: Color(0xff604FCC),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color(widget
                                                  .order.products[index].color),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: 20,
                                          width: 30,
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      );
                    },
                  ),
                  if (!isCancellation) ...[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xffC7D4EE),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Deliver to',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            widget.order.address.actualAddress,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      width: width,
                      decoration: KConstants.defContainerDec,
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "You can directly buy it from the store",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.02,
                                color: KConstants.txtColor100,
                                letterSpacing: 1),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width * 0.7,
                                child: Text(
                                  "Rabia Masjid, Mangal Bazaar Slap, Bhiwandi",
                                  style: TextStyle(
                                      fontSize: height * 0.015,
                                      color: Colors.grey,
                                      letterSpacing: 1),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    launchMap(
                                        'Rabia Masjid, Mangal Bazaar Slap, Bhiwandi');
                                  },
                                  child: Text('View On Map')),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              launch("tel:${8286349316}");
                            },
                            child: Text(
                              "Contact No: 8286349316",
                              style: TextStyle(
                                  fontSize: height * 0.015,
                                  color: Colors.grey,
                                  letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xffC7D4EE),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff130B43),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xff130B43),
                                ),
                              ),
                              Spacer(),
                              Text(
                                widget.order.totalPrice.toString(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xff130B43),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'Delivery Charges',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xff130B43),
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Free',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xff130B43),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          if (widget.order.couponModel != null) ...[
                            Row(
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff130B43),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  (widget.order.totalDiscountPrice).toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff130B43),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                          ],
                          Row(
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff130B43),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                (widget.order.totalPrice -
                                        widget.order.totalDiscountPrice)
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff130B43),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.order.couponModel != null) ...[
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        decoration: KConstants.defContainerDec,
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Coupon Applied',
                                    style: TextStyle(
                                        color: KConstants.kPrimary100)),
                                Text(widget.order.couponModel!.couponCode,
                                    style: TextStyle(
                                        color: KConstants.kPrimary100)),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.check,
                              color: KConstants.kPrimary100,
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      decoration: KConstants.defContainerDec,
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderState(),
                            style: TextStyle(color: getStateColor()),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          if ([OrderState.confirmed, OrderState.outForDelivery]
                              .contains(widget.order.orderState))
                            Text(
                              'Expected Delivery by: ' +
                                  DateFormat((widget.order.orderState ==
                                                  OrderState.outForDelivery
                                              ? 'hh:mm a,'
                                              : '') +
                                          'dd MMMM, yyyy')
                                      .format(
                                          widget.order.deliveryDate.toDate()),
                              style: TextStyle(color: KConstants.textColor50),
                            )
                          else if (widget.order.orderState ==
                              OrderState.delivered)
                            Text(
                                'Delivered on: ' +
                                    DateFormat('hh:mm a, dd MMMM, yyyy').format(
                                        widget.order.deliveredDate.toDate()),
                                style:
                                    TextStyle(color: KConstants.textColor50)),
                        ],
                      ),
                    ),
                    if (widget.order.orderState == OrderState.cancel)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 7),
                        padding: EdgeInsets.all(16.0),
                        decoration: KConstants.defContainerDec,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancellation Details',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff130B43),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'Cancelled By: ${widget.order.cancelledByUser ? 'You' : 'Admin'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Reason: ${widget.order.cancellationReason}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: KConstants.defContainerDec,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Reason to cancel the order',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff130B43),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          ...cancellationReasons
                              .map((e) => RadioListTile<String>(
                                  value: e,
                                  groupValue: reason,
                                  activeColor: KConstants.kPrimary100,
                                  title: Text(e),
                                  onChanged: (b) {
                                    setState(() {
                                      reason = b!;
                                    });
                                  }))
                        ],
                      ),
                    ),
                    if (cancellationReasons.last == reason)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: KConstants.defContainerDec,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Give us more specific reason ( Optional )',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff130B43),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text('Tell Us More'),
                            TextField(
                              controller: rController,
                            )
                          ],
                        ),
                      )
                  ]
                ],
              ),
            ),
          ),
        ),
        if (isLoading) loadinWidget(loadingText)
      ],
    );
  }
}
