import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/cart_controller.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/offer_model.dart';
import 'package:fashion_customer/model/order_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/select_address_sheet.dart';
import 'package:fashion_customer/utils/spHelper.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:fashion_customer/views/custom_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

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
      couponModel: couponModel,
      products: cartController.cartItems,
      pushToken: controller.userModel.pushToken,
      orderDocId: '',
      address: controller.seletedAddress ?? controller.userModel.address.first,
      userName: controller.userModel.name,
      userPhone: controller.userModel.number,
      totalPrice: widget.totalAmount,
      deliveryDate: Timestamp.now(),
      totalDiscountPrice: couponDiscount,
      orderId: '',
      orderState: OrderState.placed,
      createdAt: Timestamp.now(),
      cancellationReason: '',
      cancelledByUser: false);

  CouponModel? couponModel;
  double couponDiscount = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
                            couponModel: couponModel,
                            totalDiscountPrice: couponDiscount,
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

                      if (couponModel != null) {
                        await FirebaseFirestore.instance
                            .collection('coupons')
                            .doc(couponModel!.couponCode)
                            .update({
                          'usedBy': FieldValue.arrayUnion(
                              [controller.userModel.number])
                        });
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(58),
          child: CustomAppBar(
            isaction: [],
            isCenterTitle: true,
            title: "CheckOut",
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
        /* AppBar(
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
        ), */
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!orderPlaced)
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: height * 0.1, maxHeight: height * 0.5),
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
                                      cartController.cartItems[index].name
                                          .toTitleCase(),
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
                                    ],
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Quantity: ${cartController.cartItems[index].quantity}",
                                      style: TextStyle(
                                          color: Color(0xff604FCC),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                          text: 'Color: ',
                                          children: [
                                            TextSpan(
                                              text: cartController
                                                  .cartItems[index].colorName,
                                              style: TextStyle(
                                                  color: Color(cartController
                                                      .cartItems[index].color)),
                                            ),
                                          ],
                                          style: TextStyle(
                                              color: KConstants.kPrimary100,
                                              fontWeight: FontWeight.bold)),
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
              Column(
                children: [
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
                    width: width,
                    decoration: defContainerDec,
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
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
                        Text(
                          "Rabia Masjid, Mangal Bazaar Slap, Bhiwandi",
                          style: TextStyle(
                              fontSize: height * 0.015,
                              color: Colors.grey,
                              letterSpacing: 1),
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
                  if (!orderPlaced)
                    Container(
                      decoration: KConstants.defContainerDec,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          if (couponModel == null)
                            Text('Select Coupon')
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Coupon Applied',
                                    style: TextStyle(
                                        color: KConstants.kPrimary100)),
                                Text(couponModel!.couponCode,
                                    style: TextStyle(
                                        color: KConstants.kPrimary100)),
                              ],
                            ),
                          Spacer(),
                          if (couponModel == null)
                            TextButton(
                              onPressed: () async {
                                await showModalBottomSheet(
                                    context: context,
                                    builder: (c) {
                                      return SelectCouponBottomSheet(
                                        user: controller.userModel.number,
                                        onSelected: (p0) {
                                          setState(() {
                                            if (widget.totalAmount >=
                                                p0.minPrice) {
                                              couponModel = p0;
                                              if (p0.isByPercent) {
                                                couponDiscount =
                                                    widget.totalAmount *
                                                        p0.couponDiscount /
                                                        100;
                                              } else {
                                                couponDiscount =
                                                    p0.couponDiscount;
                                              }
                                            } else {
                                              couponModel = null;
                                              couponDiscount = 0;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Coupon cannot be applied'),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                      );
                                    });
                                setState(() {});
                              },
                              child: Text(
                                'Select',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: KConstants.kPrimary100,
                                ),
                              ),
                            )
                          else
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  couponModel = null;
                                  couponDiscount = 0;
                                });
                              },
                              child: Image.asset(
                                'Icons/remove.png',
                                height: 24,
                                width: 24,
                                color: Colors.red,
                              ),
                            ),
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
                        if (couponModel != null) ...[
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
                                (couponDiscount).toString(),
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
                              (widget.totalAmount - couponDiscount).toString(),
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
                ],
              ),
              if (orderPlaced)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Continue Shopping'),
                      SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<QuerySnapshot<ProductModel>>(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .orderBy("orderCount")
                              .withConverter<ProductModel>(
                                  fromFirestore: (snapshot, options) =>
                                      ProductModel.fromMap(snapshot.data()!),
                                  toFirestore: (product, options) =>
                                      product.toMap())
                              .limit(6)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return AnimationLimiter(
                                child: CustomGridView(
                                    products: snapshot.data!.docs
                                        .map((e) => e.data())
                                        .toList()),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          })
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class SelectCouponBottomSheet extends StatelessWidget {
  final Function(CouponModel) onSelected;
  final String user;
  static const String routeName = "SelectCouponBottomSheet";
  SelectCouponBottomSheet(
      {Key? key, required this.onSelected, required this.user})
      : super(key: key);

  final CollectionReference<CouponModel> _couponCollection =
      FirebaseFirestore.instance.collection('coupons').withConverter(
          fromFirestore: (snapshot, options) =>
              CouponModel.fromMap(snapshot.data()!),
          toFirestore: (document, options) => document.toMap());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot<CouponModel>>(
        stream: _couponCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Coupons Available'),
              );
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs
                  .where((element) =>
                      element.data().isActive &&
                      (element.data().isSingleUse
                          ? !element.data().usedBy.contains(user)
                          : true) &&
                      (element.data().forUsers.isEmpty
                          ? true
                          : element.data().forUsers.contains(user)))
                  .map((el) {
                CouponModel e = el.data();
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: KConstants.kBorderColor)),
                    //borderRadius: BorderRadius.circular(10)
                  ),
                  child: ExpansionTile(
                    title: Text(e.couponCode),
                    subtitle: Text(e.couponDescription),
                    children: [
                      ListTile(
                        title: Text('Discount'),
                        subtitle: Text(e.isByPercent
                            ? '${e.couponDiscount}%'
                            : '${e.couponDiscount}'),
                      ),
                      ListTile(
                        title: Text('Min Price'),
                        subtitle: Text(e.minPrice.toString()),
                      ),
                      ListTile(
                        title: Text('Select Coupon'),
                        onTap: () {
                          Navigator.pop(context);
                          onSelected(e);
                        },
                      )
                    ],
                  ),
                );
              }).toList(),
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
