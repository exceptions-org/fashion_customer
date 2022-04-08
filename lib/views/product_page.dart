import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = "/ProductPage";
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Image.asset(
        //     "Icons/Arrow.png",
        //     color: Color(0XFF604FCD),
        //   ),
        //   onPressed: () {},
        // ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Product',
          style: TextStyle(color: Color(0XFF604FCD)),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0XFFC8DFEF),
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("Icons/product.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "NameOfProduct",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "Rs. 1000",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF604FCD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    /* if (cartItems.any(
                        (element) => element.productId == cartItems[index])) {
                      CartModel check = cartItems.firstWhere(
                          (element) => element.productId == cartItems[index]);
                      int ind = cartItems.indexOf(check);
                      cartItems[ind].quantity;
                      cartItems[ind].price + cartItems[ind].price;
                    } */
                    // cartItems.add(
                    //   CartModel(
                    //     image: "", //cartItems[index].image,
                    //     name: "NameOfProduct",
                    //     price: "233",
                    //     quantity: "2",
                    //     productId: "1",
                    //     color: Colors.green.value,
                    //   ),
                    // );

                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Added to Cart"),
                        duration: Duration(milliseconds: 200),
                      ),
                    );
                  },
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
