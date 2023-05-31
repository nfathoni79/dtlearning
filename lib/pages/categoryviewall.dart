import 'package:dtlearning/pages/courselistbycategoryid.dart';
import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/provider/homeprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryViewall extends StatefulWidget {
  final String currencycode;
  const CategoryViewall({super.key, required this.currencycode});

  @override
  State<CategoryViewall> createState() => _CategoryViewallState();
}

class _CategoryViewallState extends State<CategoryViewall> {
  Constant constant = Constant();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: colorprimaryDark,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: MyAppbar(
          backTap: () {
            Navigator.of(context).pop(false);
          },
          startImg: "ic_back.svg",
          text: constant.category,
          startImgcolor: white,
          textcolor: white,
          type: 1,
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, categoryDataProvider, child) {
          if (categoryDataProvider.loading) {
            return categoryShimmer();
          } else {
            if (categoryDataProvider.categoryModel.status == 200 &&
                categoryDataProvider.categoryModel.result!.isNotEmpty) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.all(15),
                color: white,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: categoryDataProvider.categoryModel.result!.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CourelistByCategoryid(
                                currencycode: widget.currencycode,
                                  userid: categoryDataProvider
                                          .categoryModel.result?[index].id
                                          .toString() ??
                                      "",
                                  title: categoryDataProvider
                                          .categoryModel.result?[index].name
                                          .toString() ??
                                      "");
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: MyNetworkImage(
                                imgWidth: 60,
                                imgHeight: 60,
                                fit: BoxFit.fill,
                                imageUrl: categoryDataProvider
                                        .categoryModel.result?[index].image
                                        .toString() ??
                                    ""),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 70,
                            child: MyText(
                                color: colorAccent,
                                text: categoryDataProvider
                                        .categoryModel.result?[index].name
                                        .toString() ??
                                    "",
                                fontsize: 10,
                                fontwaight: FontWeight.w500,
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const NoData();
            }
          }
        },
      ),
    );
  }

  Widget categoryShimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: 18,
          itemBuilder: (BuildContext ctx, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomWidget.circular(height: 60, width: 60),
                const SizedBox(
                  height: 5,
                ),
                CustomWidget.roundrectborder(
                    height: 5, width: MediaQuery.of(context).size.width * 0.15),
              ],
            );
          }),
    );
  }
}
