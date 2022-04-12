import 'package:fashion_customer/views/checkout.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({Key? key}) : super(key: key);

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFF),
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            "Icons/Arrow.png",
            color: Color(0XFF604FCD),
          ),
          onPressed: () {},
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Cart Page", style: TextStyle(color: Color(0XFF604FCD))),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: cartItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0XFFC8D5EF))),
                    //color: Colors.grey,
                    width: double.infinity,
                    //margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffC8DFEF))),
                          height: 120,
                          width: 140,
                          // color: Colors.blue,
                          child: Image.network(cartItems[index].image.first),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItems[index].name,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Price: ${cartItems[index].price}",
                                style: TextStyle(
                                    fontSize: 14, color: Color(0XFF604FCD)),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    double singleProdPrice =
                                        cartItems[index].price /
                                            cartItems[index].quantity;

                                    setState(() {
                                      cartItems[index].quantity++;
                                      cartItems[index].price = cartItems[index]
                                              .price +
                                          singleProdPrice; /* cartItems[index].price +
                                          cartItems[index].price; */
                                    });
                                  },
                                  child: Image.asset(
                                    "Icons/add.png",
                                    height: 25,
                                    color: Color(0XFF604FCD),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${cartItems[index].quantity}",
                                  style: TextStyle(fontSize: 18),
                                ),
                                // Text(cartItems[index].productId),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    if (cartItems[index].quantity > 1) {
                                      double singleProdPrice =
                                          cartItems[index].price /
                                              cartItems[index].quantity;
                                      setState(() {
                                        cartItems[index].quantity--;
                                        cartItems[index].price =
                                            cartItems[index].price -
                                                singleProdPrice;
                                      });
                                    } else {
                                      cartItems.removeAt(index);
                                      setState(() {});
                                    }
                                  },
                                  child: Image.asset(
                                    "Icons/remove.png",
                                    height: 25,
                                    color: Color(0XFF604FCD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
