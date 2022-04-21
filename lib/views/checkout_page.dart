import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/cart_controller.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/order_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/product_card.dart';
import 'package:fashion_customer/utils/select_address_sheet.dart';
import 'package:fashion_customer/utils/spHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../model/product_model.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount;
  const CheckoutPage({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final UserController controller = getIt<UserController>();
  bool orderPlaced = false;
  BoxDecoration defContainerDec = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: KConstants.kBorderColor),
  );

  CartController cartController = getIt<CartController>();

  late OrderModel orderModel = OrderModel(
      deliveredDate: Timestamp.now(),
      products: cartController.cartItems,
      pushToken: controller.userModel.pushToken,
      orderDocId: '',
      address: controller.seletedAddress ?? controller.userModel.address.first,
      userName: controller.userModel.name,
      userPhone: controller.userModel.number,
      totalPrice: widget.totalAmount,
      deliveryDate: Timestamp.now(),
      totalDiscountPrice: 0,
      orderId: '',
      orderState: OrderState.placed,
      createdAt: Timestamp.now(),
      cancellationReason: '',
      cancelledByUser: false);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (!orderPlaced) {
          return true;
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (c) => BottomNavigation()),
              (route) => false);
          return true;
        }
      },
      child: Scaffold(
        bottomNavigationBar: orderPlaced
            ? Container(
                decoration: defContainerDec,
                height: kBottomNavigationBarHeight * 2,
                width: media.size.width,
                child: Row(
                  children: [
                    Spacer(),
                    SizedBox(
                      width: media.size.width * 0.5,
                      child: InkWell(
                        onTap: () async {
                          Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                  builder: (c) => BottomNavigation()),
                              (route) => false);
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          height: 60,
                          decoration: BoxDecoration(
                            color: KConstants.kPrimary100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'Icons/Home.png',
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                decoration: defContainerDec,
                height: kBottomNavigationBarHeight * 2,
                width: media.size.width,
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: media.size.width * 0.5,
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (c) {
                            return WillPopScope(
                              onWillPop: () async {
                                return false;
                              },
                              child: AlertDialog(
                                content: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 4.5,
                                  width:
                                      MediaQuery.of(context).size.height / 4.5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: CircularProgressIndicator(
                                          color: KConstants.kPrimary100,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        'Placing Order',
                                        style: TextStyle(
                                            color: KConstants.kPrimary100,
                                            fontSize: 25),
                                      )
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            );
                          });
                      QuerySnapshot orders = await FirebaseFirestore.instance
                          .collection('orders')
                          .get();
                      DocumentReference ref = await FirebaseFirestore.instance
                          .collection('orders')
                          .add({});
                      await ref.update(orderModel
                          .copyWith(
                            products: cartController.cartItems,
                            orderDocId: ref.id,
                            address: controller.seletedAddress ??
                                controller.userModel.address.first,
                            userName: controller.userModel.name,
                            userPhone: controller.userModel.number,
                            totalPrice: widget.totalAmount,
                            deliveryDate: Timestamp.now(),
                            totalDiscountPrice: 0,
                            orderId: 'FASHIO${orders.docs.length + 1}',
                            orderState: OrderState.placed,
                            createdAt: Timestamp.now(),
                          )
                          .toMap());
                      List<String>? tokens = await SPHelper().getAdminToken();

                      if (tokens != null) {
                        for (var token in tokens) {
                          KConstants.sendFCMMessage(
                              'New Order', 'New Order Received', token);
                        }
                      }

                      await FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        for (var item in cartController.cartItems) {
                          DocumentReference reference = FirebaseFirestore
                              .instance
                              .collection('products')
                              .doc(item.productId);
                          transaction.update(reference, {
                            'orderCount': FieldValue.increment(1),
                          });
                        }
                      });

                      Navigator.pop(context);
                      cartController.clearCart();
                      setState(() {
                        orderPlaced = true;
                      });
                      /*  Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: (c) => BottomNavigation()),
                          (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Order Placed Successfully',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: KConstants.kPrimary100,
                          duration: Duration(seconds: 1),
                        ),
                      ); */
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      height: 60,
                      decoration: BoxDecoration(
                        color: KConstants.kPrimary100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        backgroundColor: Color(0xffFAFAFF),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: KConstants.kPrimary100,
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            orderPlaced ? 'Order Placed' : 'Checkout',
            style: TextStyle(
              color: KConstants.kPrimary100,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!orderPlaced)
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
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
                                  cartController.cartItems[index].image.first,
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
                                    cartController.cartItems[index].name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    "Price: ${cartController.cartItems[index].price}",
                                    style: TextStyle(
                                        color: Color(0xff604FCC),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (cartController
                                          .cartItems[index].selectedSize !=
                                      '') ...[
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "Selected Size: ${cartController.cartItems[index].selectedSize}",
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
              )
            else
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.asset(
                      'Icons/check_1.png',
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      'Your Order has been placed successfully',
                      style: TextStyle(
                          color: Color(0xff058F13),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    )
                  ],
                ),
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
                      if (!orderPlaced)
                        TextButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                                context: context,
                                builder: (c) {
                                  return SelectAddressSheet();
                                });
                            setState(() {});
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: KConstants.kPrimary100,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    controller.seletedAddress == null
                        ? controller.userModel.address.first.actualAddress
                        : controller.seletedAddress!.actualAddress,
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
                        widget.totalAmount.toString(),
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
                        widget.totalAmount.toString(),
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
            if (orderPlaced)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Continue Shopping'),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot<ProductModel>>(
                            stream: FirebaseFirestore.instance
                                .collection('products')
                                .orderBy("orderCount")
                                .withConverter<ProductModel>(
                                    fromFirestore: (snapshot, options) =>
                                        ProductModel.fromMap(snapshot.data()!),
                                    toFirestore: (product, options) =>
                                        product.toMap())
                                .limit(10)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return AnimationLimiter(
                                  child: GridView.count(
                                    shrinkWrap: true,
                                    childAspectRatio: 1 / 1.1,
                                    physics: BouncingScrollPhysics(),
                                    crossAxisCount: 2,
                                    children: snapshot.data!.docs
                                        .mapIndexed((i, element) =>
                                            AnimationConfiguration
                                                .staggeredGrid(
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    columnCount: 2,
                                                    position: i,
                                                    child: ScaleAnimation(
                                                      child: ProductCard(
                                                          data: element.data()),
                                                    )))
                                        .toList(),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
