import 'package:fashion_customer/views/product_details.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          margin: EdgeInsets.all(20),
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xff604FCD),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              "Place Order",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          )),
      backgroundColor: Color(0xffFAFAFF),
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xff604FCD),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
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
                        cartItems[index].image.first,
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
                          cartItems[index].name,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "Price: ${cartItems[index].price}",
                          style: TextStyle(
                              color: Color(0xff604FCC),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.all(8.0),
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
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff604FCD),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      '106 1st Floor Ameen Apartment\nTandel Mohalla Idgah Road\nBhiwandi, Maharashtra 421302',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
