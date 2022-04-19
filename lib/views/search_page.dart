import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/product_card.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = "/SearchPage";
  final bool isCategry;
  final String category;
  final Function(int) onChange;
  const SearchPage(
      {Key? key,
      required this.onChange,
      this.isCategry = false,
      this.category = ''})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = TextEditingController();
  CollectionReference productRefs =
      FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: KConstants.kPrimary100,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: !widget.isCategry
            ? null
            : IconButton(
                icon: Image.asset("Icons/Arrow.png"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        actions: [
          IconButton(
            icon: Image.asset(
              "Icons/Bag.png",
              color: Colors.white,
            ),
            onPressed: () {
              if (widget.isCategry) {
                Navigator.of(context).pop();
              }
              widget.onChange(2);
            },
          ),
        ],
        bottom: PreferredSize(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            //height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Image.asset(
                  "Icons/Search.png",
                  color: Colors.white60,
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: width * 0.7,
                  child: TextField(
                    onChanged: (value) {
                      print(value);
                      setState(() {});
                    },
                    controller: search,
                    decoration: InputDecoration(
                      hintText: "search footwear, dress & dresses",
                      hintStyle: TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                /* const Text(
                  "search footwear, dress & dresses",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white60,
                    // fontWeight: FontWeight.bold,
                  ),
                ), */
              ],
            ),
            // color: Colors.grey,
          ),
          preferredSize: const Size.fromHeight(kToolbarHeight * 1.4),
        ),
        title: widget.isCategry ? Text(widget.category) : const Text('Explore'),
      ),
      body: StreamBuilder<QuerySnapshot<ProductModel>>(
        stream: productRefs
            .withConverter<ProductModel>(
                fromFirestore: (snapshot, options) =>
                    ProductModel.fromMap(snapshot.data()!),
                toFirestore: (product, options) => product.toMap())
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("something went wrong"),
            );
          }
          // if (snapshot.data!.docs.isEmpty) {
          //   return Center(child: Text("No such Product Found"));
          // }
          if (snapshot.hasData && snapshot.data != null) {
            // var productLength = snapshot.data!.docs.length;
            if (snapshot.data!.docs.isEmpty) {
              return Text(
                "No such Product Found",
                style: TextStyle(fontSize: 50),
              );
            }
            if (snapshot.data!.docs
                .where((element) => element
                    .data()
                    .name
                    .toLowerCase()
                    .contains(search.text.toLowerCase()))
                .isEmpty) {
              return Center(
                child: Text(
                  "${search.text} not found",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            return GridView.count(
              physics: BouncingScrollPhysics(),
              childAspectRatio: 1 / 1.1,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: (widget.isCategry
                      ? snapshot.data!.docs
                          .where((element) =>
                              element.data().category.name == widget.category)
                          .where((element) => element
                              .data()
                              .name
                              .toLowerCase()
                              .contains(search.text.toLowerCase()))
                          .map((e) => e.data())
                      : snapshot.data!.docs
                          .where((element) => element
                              .data()
                              .name
                              .toLowerCase()
                              .contains(search.text.toLowerCase()))
                          .map((e) => e.data()))
                  .map((data) => ProductCard(data: data))
                  .toList(), /* (context, index) {
                ProductModel data = snapshot.data.docs[index].data();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetails(productModel: data),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blueGrey.shade100,
                        // width: 1,
                      ),
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    margin: const EdgeInsets.all(10),
                    // padding: const EdgeInsets.all(8),
                    height: 200,
                    width: 162,
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          width: 142,
                          // padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top: 10, left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: NetworkImage(
                                  data.images.first.images.first),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            data.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Rs. ${data.prices.first.colorPrice.first.price}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: KConstants.kPrimary100,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        /* Container(
                      height: 50,
                      width: 162,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          "NameOfProduct",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ), */
                      ],
                    ),
                  ),
                );
              } */
              // itemCount: productLength,
            );
          }
          return const Center(child: Text('Loading...'));
        },
      ),
      /* body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blueGrey.shade100,
                // width: 1,
              ),
              // color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            margin: const EdgeInsets.all(10),
            // padding: const EdgeInsets.all(8),
            height: 200,
            width: 162,
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: 142,
                  // padding: const EdgeInsets.only(left: 10),
                  margin: const EdgeInsets.only(top: 10, left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    image: const DecorationImage(
                      image: AssetImage("assets/icons/product.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "NameOfProduct",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Rs. 1000",
                    style: TextStyle(
                      fontSize: 16,
                      color: KConstants.kPrimary100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                /* Container(
                    height: 50,
                    width: 162,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        "NameOfProduct",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ), */
              ],
            ),
          );
        },
        itemCount: 10,
      ), */
    );
  }
}
