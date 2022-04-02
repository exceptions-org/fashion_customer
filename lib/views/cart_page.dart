import 'package:fashion_customer/model/cart_model.dart';
import 'package:fashion_customer/views/checkout.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:fashion_customer/views/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({Key? key}) : super(key: key);

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  int addItem = 0;

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
        title: Text("Cart Page", style: TextStyle(color: Color(0XFF604FCD))),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cartItems.length,
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
                          child: Image.network(cartItems[index].image.first),
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
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      addItem++;
                                      /* cartItems[index].price +
                                          cartItems[index].price; */
                                    });
                                  },
                                  child: Image.asset(
                                    "Icons/add.png",
                                    height: 20,
                                    color: Color(0XFF604FCD),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text("$addItem"),
                                // Text(cartItems[index].productId),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      addItem--;
                                    });
                                  },
                                  child: Image.asset(
                                    "Icons/remove.png",
                                    height: 20,
                                    color: Color(0XFF604FCD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )

                    /* ListTile(
                    title: Text(cartItems[index].name),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price: ${cartItems[index].price}"),
                        SizedBox(width: 20),
                        Text("Quantity: ${cartItems[index].quantity}"),
                        SizedBox(width: 20),
                        IconButton(
                            onPressed: () {
                              cartItems.remove(cartItems[index]);
                              setState(() {});
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                    leading: Text(cartItems[index].productId),
                  ); */
                    ;
              },
            ),
          ),
          Spacer(),
          Container(
            height: 50,
            width: double.maxFinite,
            color: Color(0XFF604FCD),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Container(
                    height: 40,
                    width: 2,
                    color: Colors.grey.withOpacity(.3),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => Checkout()));
                    },
                    child: Text(
                      "CheckOut",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
