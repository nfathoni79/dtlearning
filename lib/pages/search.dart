import 'dart:developer';

import 'package:dtlearning/model/coursemodel.dart';
import 'package:dtlearning/pages/cart.dart';
import 'package:dtlearning/pages/categoryviewall.dart';
import 'package:dtlearning/pages/courselistbycategoryid.dart';
import 'package:dtlearning/pages/detail.dart';
import 'package:dtlearning/pages/login.dart';
import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/provider/searchprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  TextEditingController searchControler = TextEditingController();
  Constant constant = Constant();
  List<Result>? searchList;
  SharedPre sharedpre = SharedPre();
  String? userid, currencycode;

  @override
  void initState() {
    super.initState();
    getdata();
    callapi();
  }

  getdata() async {
    userid = await sharedpre.read("userid") ?? "";
    currencycode = await sharedpre.read("currency") ?? "";
    log("userid ==>$userid");
  }

  void callapi() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    await searchProvider.getbrowseCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
                color: black,
                text: constant.search,
                maxline: 1,
                fontwaight: FontWeight.w500,
                fontsize: 16,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
            const Spacer(),
            InkWell(
              onTap: () {
                if (userid!.isEmpty || userid == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Login();
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Cart(
                          userid: userid.toString(),
                        );
                      },
                    ),
                  );
                }
              },
              child: Container(
                width: 25,
                height: 40,
                alignment: Alignment.centerRight,
                child: MySvg(
                  width: 20,
                  height: 20,
                  imagePath: "ic_cart.svg",
                  color: black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            searchbar(),
            const SizedBox(height: 10),
            searchControler.text.isEmpty
                ? Column(
                    children: [
                      topsearchSection(),
                      browserCategory(),
                    ],
                  )
                : manualSearchlist(),
          ],
        ),
      ),
    );
  }

// Search Bar
  Widget searchbar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 45,
      child: TextFormField(
        obscureText: false,
        keyboardType: TextInputType.text,
        controller: searchControler,
        onChanged: (value) async {
          setState(() {});
          final searchProvider =
              Provider.of<SearchProvider>(context, listen: false);
          await searchProvider.getSearchCourse(searchControler.text.toString());
        },
        textInputAction: TextInputAction.done,
        cursorColor: colorPrimary,
        style: GoogleFonts.montserrat(
            fontSize: 16,
            fontStyle: FontStyle.normal,
            color: colorPrimary,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {},
            icon: MySvg(
              imagePath: "ic_search.svg",
              width: 20,
              height: 20,
              color: colorprimaryDark,
            ),
          ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(width: 1, color: lightgray),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(width: 1, color: lightgray),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(width: 1, color: lightgray),
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(width: 1, color: lightgray)),
          hintText: constant.searchbarhint,
          hintStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontStyle: FontStyle.normal,
              color: colorAccent,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

// Top search Text With List
  Widget topsearchSection() {
    return Consumer<SearchProvider>(builder: (context, searchProvider, child) {
      if (searchProvider.loading) {
        return Utils.pageLoader();
      } else {
        if (searchProvider.browsecategoryModel.status == 200 &&
            searchProvider.browsecategoryModel.result!.isNotEmpty) {
          return Column(
            children: [
              const SizedBox(height: 15),
              // Text
              MyText(
                  color: colorAccent,
                  text: constant.topsearch,
                  fontsize: 16,
                  overflow: TextOverflow.ellipsis,
                  maxline: 1,
                  fontwaight: FontWeight.w600,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: -1,
                    direction: Axis.vertical,
                    children: searchProvider.browsecategoryModel.result!
                        .map(
                          (element) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CourelistByCategoryid(
                                      currencycode: currencycode!,
                                      userid: element.id.toString(),
                                      title: element.name.toString(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: 130,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25)),
                                  border:
                                      Border.all(width: 1, color: lightgray)),
                              margin: const EdgeInsets.all(5),
                              child: MyText(
                                  color: colorAccent,
                                  text: element.name.toString(),
                                  fontsize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  maxline: 1,
                                  fontwaight: FontWeight.w600,
                                  textalign: TextAlign.center,
                                  fontstyle: FontStyle.normal),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  // browser Category GridView
  Widget browserCategory() {
    return Consumer<SearchProvider>(builder: (context, searchProvider, child) {
      if (searchProvider.loading) {
        return browserCategoryShimmer();
      } else {
        if (searchProvider.browsecategoryModel.status == 200 &&
            searchProvider.browsecategoryModel.result!.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              MyText(
                  color: colorAccent,
                  text: constant.browsecategory,
                  fontsize: 14,
                  fontwaight: FontWeight.w600,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 1,
                    color: lightgray,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CategoryViewall(
                              currencycode: currencycode!,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 70,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1, color: lightgray)),
                      child: MyText(
                          color: colorAccent,
                          text: constant.viewall,
                          fontsize: 10,
                          fontwaight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 70,
                    height: 1,
                    color: lightgray,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                alignment: Alignment.centerLeft,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemCount:
                        searchProvider.browsecategoryModel.result?.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CourelistByCategoryid(
                                  currencycode: currencycode!,
                                  userid: searchProvider
                                          .browsecategoryModel.result?[index].id
                                          .toString() ??
                                      "",
                                  title: searchProvider.browsecategoryModel
                                          .result?[index].name
                                          .toString() ??
                                      "",
                                );
                              },
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: MyNetworkImage(
                                  imgWidth: 60,
                                  imgHeight: 60,
                                  fit: BoxFit.fill,
                                  imageUrl: searchProvider.browsecategoryModel
                                          .result?[index].image
                                          .toString() ??
                                      ""),
                            ),
                            const SizedBox(height: 5),
                            MyText(
                                color: colorAccent,
                                text: searchProvider
                                        .browsecategoryModel.result?[index].name
                                        .toString() ??
                                    "",
                                fontsize: 12,
                                fontwaight: FontWeight.w500,
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget browserCategoryShimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        CustomWidget.roundrectborder(
          height: 15,
          width: MediaQuery.of(context).size.width * 0.40,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 1,
              color: lightgray,
            ),
            const SizedBox(
              width: 10,
            ),
            CustomWidget.roundrectborder(
                height: 15, width: MediaQuery.of(context).size.width * 0.20),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 70,
              height: 1,
              color: lightgray,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          alignment: Alignment.centerLeft,
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: 6,
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CustomWidget.circular(height: 60, width: 60),
                      const SizedBox(height: 5),
                      CustomWidget.roundrectborder(
                          height: 15,
                          width: MediaQuery.of(context).size.width * 0.15),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  manualSearchlist() {
    return Consumer<SearchProvider>(
      builder: (context, searchprovider, child) {
        if (searchprovider.loading) {
          return manualSearchlistShimmer();
        } else {
          if (searchprovider.getsearchcourseModel.status == 200 &&
              searchprovider.getsearchcourseModel.result!.isNotEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          searchprovider.getsearchcourseModel.result?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Detail(
                                      currencycode: currencycode,
                                      id: searchprovider.getsearchcourseModel
                                              .result?[index].id
                                              .toString() ??
                                          "");
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: lightgray,
                                  blurRadius: 5,
                                  offset: Offset(0.1, 0.1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyNetworkImage(
                                    imgWidth: 100,
                                    imgHeight:
                                        MediaQuery.of(context).size.height,
                                    imageUrl: searchprovider
                                            .getsearchcourseModel
                                            .result?[index]
                                            .image
                                            .toString() ??
                                        "",
                                    fit: BoxFit.fill,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: MyText(
                                              color: colorprimaryDark,
                                              text: searchprovider
                                                      .getsearchcourseModel
                                                      .result?[index]
                                                      .name
                                                      .toString() ??
                                                  "",
                                              maxline: 2,
                                              fontwaight: FontWeight.w600,
                                              fontsize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                        ),
                                        const SizedBox(height: 8),
                                        MyText(
                                            color: black,
                                            text:
                                                "${searchprovider.getsearchcourseModel.result?[index].duration.toString() ?? ""} mins",
                                            maxline: 2,
                                            fontwaight: FontWeight.w500,
                                            fontsize: 10,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                        const SizedBox(height: 5),
                                        MyText(
                                            color: black,
                                            text:
                                                "$currencycode ${searchprovider.getsearchcourseModel.result?[index].price.toString() ?? ""}",
                                            fontsize: 12,
                                            fontwaight: FontWeight.w500,
                                            maxline: 2,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  manualSearchlistShimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: lightgray,
                        blurRadius: 5,
                        offset: Offset(0.1, 0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomWidget.rectangular(
                        width: 100,
                        height: MediaQuery.of(context).size.height,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.40,
                              height:
                                  MediaQuery.of(context).size.height * 0.007,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.40,
                              height:
                                  MediaQuery.of(context).size.height * 0.007,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height:
                                  MediaQuery.of(context).size.height * 0.007,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height:
                                  MediaQuery.of(context).size.height * 0.008,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
