import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductPage extends StatelessWidget {
  static const String routeName = "/ProductPage";
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/arrow_right.svg"),
          onPressed: () {},
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF604FCD),
        title: const Text('Product'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blueGrey.shade100,
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
                      image: AssetImage("assets/icons/product.png"),
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
                    ]))
              ],
            ),
          );
        },
      ),
    );
  }
}
