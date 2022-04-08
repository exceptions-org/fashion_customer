// ignore_for_file: unused_local_variable

import 'package:fashion_customer/model/order_model.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  get index => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            "Icons/Arrow.png",
            color: Color(0XFF604FCD),
          ),
          onPressed: () {},
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Checkout", style: TextStyle(color: Color(0XFF604FCD))),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: cartItems.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          width: 140,
                          // color: Colors.blue,
                          child: Image.asset("Icons/product.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cartItems[index].name),
                              SizedBox(height: 10),
                              Text("Price: ${cartItems[index].price}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(),
                  ],
                );
              },
            ),
          ),
          Text("Total Price"),
        ],
      ),
      floatingActionButton: MaterialButton(
        minWidth: 100,
        color: Color(0XFF604FCD),
        onPressed: () {
          OrderModel orderModel = OrderModel(
            orderId: "123",
            orderName: "orderName",
            orderPrice: 123,
            orderQuantity: "orderQuantity",
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Order Placed"),
              duration: Duration(milliseconds: 200),
            ),
          );
        },
        child: Text(
          "Order Placed",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
