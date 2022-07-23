import 'package:fashion_customer/views/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/category_model.dart';

class SelectSubCategory extends StatelessWidget {
  final bool isCategry;
  final String category;
  final Function(int) onChange;
  final List<CategoryModel> subcategories;
  const SelectSubCategory(
      {Key? key,
      required this.onChange,
      this.isCategry = false,
      this.category = '',
      this.subcategories = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 50, bottom: 10),
            child: Text('Select Sub Category'),
          ),
          Divider(),
          GridView.count(
            physics: BouncingScrollPhysics(),
            childAspectRatio: width / width * 0.95,
            shrinkWrap: true,
            mainAxisSpacing: 10,
            crossAxisSpacing: 15,
            crossAxisCount: 2,
            children: subcategories
                .map(
                  (e) => InkWell(
                    onTap: () {
                      //  Navigator.pop(context);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SearchPage(
                                    onChange: onChange,
                                    category: category,
                                    selectedSubcategory: e.name,
                                    isCategry: true,
                                    subcategories: subcategories,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey)),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.network(
                            e.imageUrl,
                            height: width * 0.35,
                          ),
                          Spacer(),
                          Text(e.name)
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
