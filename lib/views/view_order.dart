import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/model/order_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  PageController pageController = PageController(initialPage: 0);

  OrderModel? orderModel;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pageController.page == 1) {
          pageController.animateToPage(0,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
          return false;
        }
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            backgroundColor: Colors.white,
            title: Text(
              'Your Orders',
              style: GoogleFonts.montserratAlternates(
                  color: KConstants.kPrimary100),
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
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  PageView(
                    allowImplicitScrolling: false,
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .where((element) =>
                                element.data().orderState !=
                                    OrderState.delivered &&
                                element.data().orderState != OrderState.cancel)
                            .map((element) => OrderCard(
                                  order: element.data(),
                                  viewDetails: (order) {
                                    setState(() {
                                      orderModel = order;
                                    });
                                    pageController.animateToPage(1,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn);
                                  },
                                ))
                            .toList(),
                      ),
                      if (orderModel != null)
                        OrderDetails(
                          order: orderModel!,
                          goBack: () {
                            pageController.jumpToPage(0);
                          },
                        )
                    ],
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs
                        .where((element) =>
                            element.data().orderState == OrderState.delivered ||
                            element.data().orderState == OrderState.cancel)
                        .map((element) => OrderCard(
                              order: element.data(),
                              viewDetails: (order) {
                                orderModel = order;
                              },
                            ))
                        .toList(),
                  )
                ],
              );
            },
          )),
    );
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
      case OrderState.cancel:
        return KConstants.greenOrderState;
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
                )
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

class OrderDetails extends StatelessWidget {
  final OrderModel order;
  final Function() goBack;
  const OrderDetails({Key? key, required this.order, required this.goBack})
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
      case OrderState.cancel:
        return KConstants.greenOrderState;
      default:
        return KConstants.greenOrderState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack();
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: KConstants.defContainerDec,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order ID ${order.orderId}', textScaleFactor: 1.1),
                  Text(
                    DateFormat('hh:mm a, dd MMMM, yyyy')
                        .format(order.createdAt.toDate()),
                    style: TextStyle(color: KConstants.textColor50),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: order.products.length,
              shrinkWrap: true,
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
                            child: Image.network(
                              order.products[index].image.first,
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
                                order.products[index].name,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Price: ${order.products[index].price}",
                                style: TextStyle(
                                    color: Color(0xff604FCC),
                                    fontWeight: FontWeight.bold),
                              ),
                              if (order.products[index].selectedSize != '') ...[
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "Selected Size: ${order.products[index].selectedSize}",
                                  style: TextStyle(
                                      color: Color(0xff604FCC),
                                      fontWeight: FontWeight.bold),
                                ),
                              ]
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
                    order.address.actualAddress,
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
                        order.totalPrice.toString(),
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
                        order.totalPrice.toString(),
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
            SizedBox(
              height: 4,
            ),
            Container(
              decoration: KConstants.defContainerDec,
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Text(
                orderState(),
                style: TextStyle(color: getStateColor()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
