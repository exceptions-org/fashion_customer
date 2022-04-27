import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/model/category_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/product_card.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

enum SortBy {
  priceHighToLow,
  priceLowToHigh,
  newest,
  oldest,
  aToZ,
  popularity,
  rating
}

String getSorting(SortBy sortBy) {
  switch (sortBy) {
    case SortBy.priceHighToLow:
      return 'Price: High To Low';
    case SortBy.priceLowToHigh:
      return 'Price: Low To High';
    case SortBy.newest:
      return 'Newest';
    case SortBy.oldest:
      return 'Oldest';
    case SortBy.aToZ:
      return 'A to Z';
    case SortBy.popularity:
      return 'Popularity';
    case SortBy.rating:
      return 'Rating';
    default:
      return '';
  }
}

class SearchPage extends StatefulWidget {
  static const String routeName = "/SearchPage";
  final bool isCategry;
  final String category;
  final Function(int) onChange;
  final List<CategoryModel> subcategories;
  const SearchPage(
      {Key? key,
      required this.onChange,
      this.isCategry = false,
      this.category = '',
      this.subcategories = const []})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = TextEditingController();
  CollectionReference productRefs =
      FirebaseFirestore.instance.collection('products');

  List<String> subcategories = [];
  SortBy? sortBy;

  List<String> categories = [];

  double minPrice = 100;
  double maxPrice = 10000;
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
              ],
            ),
            // color: Colors.grey,
          ),
          preferredSize: const Size.fromHeight(kToolbarHeight * 1.6),
        ),
        title: widget.isCategry ? Text(widget.category) : const Text('Explore'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Spacer(),
                TextButton.icon(
                    onPressed: () {
                      SortBy? sortBy = this.sortBy;
                      List<String> filterCategories = this.categories;
                      double minPrice = this.minPrice;
                      double maxPrice = this.maxPrice;
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return StatefulBuilder(builder: (context, s) {
                              return Stack(
                                children: [
                                  Container(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                              'Sort By',
                                              style: TextStyle(
                                                color: KConstants.txtColor100,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Divider(
                                            color: Color(0xffC7D4EE),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ...SortBy.values.map(
                                            (e) => RadioListTile<SortBy>(
                                              groupValue: sortBy,
                                              onChanged: (value) {
                                                setState(() {
                                                  sortBy = value;
                                                });
                                                s(() {});
                                              },
                                              value: e,
                                              title: Text(
                                                getSorting(e),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                              'Filter By',
                                              style: TextStyle(
                                                color: KConstants.txtColor100,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Divider(
                                            color: Color(0xffC7D4EE),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if (!widget.isCategry)
                                            StreamBuilder<
                                                    QuerySnapshot<
                                                        FetchCategoryModel>>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('admin')
                                                    .doc('categories')
                                                    .collection('categories')
                                                    .withConverter(
                                                        fromFirestore: (snapshot,
                                                                options) =>
                                                            FetchCategoryModel
                                                                .fromMap(snapshot
                                                                    .data()!),
                                                        toFirestore:
                                                            (FetchCategoryModel
                                                                        v,
                                                                    s) =>
                                                                v.toMap())
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot.data != null) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: snapshot
                                                          .data!.docs
                                                          .map((e) =>
                                                              CheckboxListTile(
                                                                  value: filterCategories
                                                                      .contains(e
                                                                          .data()
                                                                          .category
                                                                          .name),
                                                                  title: Text(
                                                                    e
                                                                        .data()
                                                                        .category
                                                                        .name,
                                                                  ),
                                                                  onChanged:
                                                                      (v) {
                                                                    if (v ??
                                                                        false) {
                                                                      filterCategories.add(e
                                                                          .data()
                                                                          .category
                                                                          .name);
                                                                    } else {
                                                                      filterCategories.remove(e
                                                                          .data()
                                                                          .category
                                                                          .name);
                                                                    }
                                                                    s(() {});
                                                                  }))
                                                          .toList(),
                                                    );
                                                  }
                                                  return Container();
                                                })
                                          else
                                            ...widget.subcategories
                                                .map((e) => CheckboxListTile(
                                                      value: filterCategories
                                                          .contains(e.name),
                                                      title: Text(e.name),
                                                      onChanged: (v) {
                                                        if (v ?? false) {
                                                          filterCategories
                                                              .add(e.name);
                                                        } else {
                                                          filterCategories
                                                              .remove(e.name);
                                                        }
                                                        s(() {});
                                                      },
                                                    )),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                              'Price Range',
                                              style: TextStyle(
                                                color: KConstants.txtColor100,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Divider(
                                            color: Color(0xffC7D4EE),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RangeSlider(
                                              activeColor:
                                                  KConstants.kPrimary100,
                                              values: RangeValues(
                                                  minPrice, maxPrice),
                                              onChanged: (v) {
                                                setState(() {
                                                  minPrice = v.start;
                                                  maxPrice = v.end;
                                                });
                                                s(() {});
                                              },
                                              min: 100,
                                              max: 10000,
                                              divisions: 100000 ~/ 100,
                                              labels: RangeLabels(
                                                  '${minPrice.toInt()}',
                                                  '${maxPrice.toInt()}')),
                                          SizedBox(
                                            height: kBottomNavigationBarHeight,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: KConstants.kPrimary100),
                                          onPressed: () {
                                            setState(() {
                                              this.sortBy = sortBy;
                                              this.categories =
                                                  filterCategories;
                                              this.minPrice = minPrice;
                                              this.maxPrice = maxPrice;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Apply')),
                                    ),
                                  ),
                                ],
                              );
                            });
                          });
                    },
                    icon: Image.asset(
                      'Icons/filter.png',
                      color: KConstants.txtColor100,
                      height: 24,
                      width: 24,
                    ),
                    label: Text(
                      'Filter',
                      style: TextStyle(
                        color: KConstants.txtColor100,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: StreamBuilder<QuerySnapshot<ProductModel>>(
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

                    List<ProductModel> products = [];

                    if (widget.isCategry) {
                      products = snapshot.data!.docs
                          .where((element) => element
                              .data()
                              .name
                              .toLowerCase()
                              .contains(search.text.toLowerCase()))
                          .where((element) =>
                              element.data().category.name.toLowerCase() ==
                              widget.category.toLowerCase())
                          .map((e) => e.data())
                          .toList();
                    } else {
                      List<ProductModel> searches = snapshot.data!.docs
                          .where((element) => element
                              .data()
                              .name
                              .toLowerCase()
                              .contains(search.text.toLowerCase()))
                          .map((e) => e.data())
                          .toList();
                      products = searches;
                    }

                    if (categories.isNotEmpty) {
                      if (widget.isCategry)
                        products = products
                            .where((element) =>
                                categories.contains(element.subCategory.name))
                            .toList();
                      else
                        products = products
                            .where((element) =>
                                categories.contains(element.category.name))
                            .toList();
                    }
                    products = products
                        .where((element) =>
                            double.parse(element
                                    .prices.first.colorPrice.first.price) >=
                                minPrice &&
                            double.parse(element
                                    .prices.first.colorPrice.first.price) <=
                                maxPrice)
                        .toList();
                    if (sortBy != null) {
                      switch (sortBy) {
                        case SortBy.aToZ:
                          products.sort((a, b) => a.name.compareTo(b.name));
                          break;
                        case SortBy.priceHighToLow:
                          products.sort((a, b) => double.parse(
                                  b.prices.first.colorPrice.first.price)
                              .compareTo(double.parse(
                                  a.prices.first.colorPrice.first.price)));
                          break;
                        case SortBy.priceLowToHigh:
                          products.sort((a, b) => double.parse(
                                  a.prices.first.colorPrice.first.price)
                              .compareTo(double.parse(
                                  b.prices.first.colorPrice.first.price)));
                          break;
                        case SortBy.popularity:
                          products.sort(
                              (a, b) => b.orderCount.compareTo(a.orderCount));
                          break;
                        case SortBy.newest:
                          products.sort(
                              (a, b) => b.createdAt.compareTo(a.createdAt));
                          break;
                        case SortBy.oldest:
                          products.sort(
                              (a, b) => a.createdAt.compareTo(b.createdAt));
                          break;
                        case SortBy.rating:
                          products.sort((a, b) =>
                              b.averageRating.compareTo(a.averageRating));
                          break;
                        default:
                      }
                    }
                    if (products.isEmpty) {
                      return Text(
                        "No such Product Found",
                        style: TextStyle(fontSize: 50),
                      );
                    }
                    return GridView.count(
                      physics: BouncingScrollPhysics(),
                      childAspectRatio: 1 / 1.2,
                      shrinkWrap: true,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      crossAxisCount: 2,
                      children: products
                          .map((data) => ProductCard(data: data))
                          .toList(), /* (context, index) {
                        ProductModel data = snapshot.data.docs[index].data();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
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
            ),
          ),
        ],
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
