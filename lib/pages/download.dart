import 'dart:developer';
import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/provider/downloaddeleteprovider.dart';
import 'package:dtlearning/provider/downloadprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class Download extends StatefulWidget {
  final String userid;
  const Download({super.key, required this.userid});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  SharedPre sharedpre = SharedPre();
  Constant constant = Constant();
  double? width;
  double? height;

  @override
  initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    final downloadItem = Provider.of<DownloadProvider>(context, listen: false);
    await downloadItem.getdownloadList(widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: colorprimaryDark,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: MyAppbar(
          type: 1,
          startImg: "ic_back.svg",
          backTap: (){
            Navigator.of(context).pop(false);
          },
          startImgcolor: white,
          text: constant.download,
          textcolor: white,
        ),
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, downloadprovider, child) {
          if (downloadprovider.loading) {
            return downloadshimmer();
          } else {
            if (downloadprovider.getdownloadModel.status == 200 &&
                downloadprovider.getdownloadModel.result!.isNotEmpty) {
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
                            downloadprovider.getdownloadModel.result?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                            key: const ValueKey(0),
                            direction: Axis.horizontal,
                            startActionPane: const ActionPane(
                              motion: ScrollMotion(),
                              children: [],
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                // delete Button
                                SlidableAction(
                                  onPressed: (BuildContext context) async {
                                    // Download Delete Api Calling
                                    final downloaddeleteItem =
                                        Provider.of<DownloadDeleteProvider>(
                                            context,
                                            listen: false);
                                    downloaddeleteItem.getdownloaddelete(
                                        widget.userid,
                                        downloadprovider.getdownloadModel
                                                .result?[index].courseId
                                                .toString() ??
                                            "");

                                    if (!downloaddeleteItem.loading) {
                                      log("page Loading...");
                                      Utils.pageLoader();
                                    } else {
                                      log("else");
                                      if (downloaddeleteItem
                                              .downloaddeleteModel.status ==
                                          200) {
                                        Utils().showToast(
                                            "${downloaddeleteItem.downloaddeleteModel.message}");
                                        // ReCall DownloadList Api
                                        setState(() {});
                                        await downloadprovider
                                            .getdownloadList(widget.userid);
                                      } else {
                                        log("status 400");
                                        Utils().showToast(
                                            "${downloaddeleteItem.downloaddeleteModel.message}");
                                      }
                                    }
                                  },
                                  backgroundColor: white,
                                  icon: Icons.delete,
                                  foregroundColor: colorprimaryDark,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 120,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyNetworkImage(
                                        imgWidth: 100,
                                        imgHeight:
                                            MediaQuery.of(context).size.height,
                                        imageUrl: "dfsd${downloadprovider
                                                .getdownloadModel
                                                .result?[index]
                                                .image
                                                .toString() ??
                                            ""}",
                                        fit: BoxFit.fill,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
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
                                                  text: downloadprovider
                                                          .getdownloadModel
                                                          .result?[index]
                                                          .description
                                                          .toString() ??
                                                      "",
                                                  maxline: 2,
                                                  fontwaight: FontWeight.w600,
                                                  fontsize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textalign: TextAlign.left,
                                                  fontstyle: FontStyle.normal),
                                            ),
                                            const SizedBox(height: 8),
                                            MyText(
                                                color: black,
                                                text:
                                                    "${downloadprovider.getdownloadModel.result?[index].duration.toString() ?? ""} mins",
                                                maxline: 2,
                                                fontwaight: FontWeight.w600,
                                                fontsize: 10,
                                                overflow: TextOverflow.ellipsis,
                                                textalign: TextAlign.left,
                                                fontstyle: FontStyle.normal),
                                            const SizedBox(height: 8),
                                            MyText(
                                                color: black,
                                                text:
                                                    "\$ ${downloadprovider.getdownloadModel.result?[index].price.toString() ?? ""}",
                                                fontsize: 12,
                                                fontwaight: FontWeight.w600,
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
      ),
    );
  }

  downloadshimmer() {
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
                              width: width! * 0.40,
                              height: height! * 0.008,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: width! * 0.40,
                              height: height! * 0.008,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: width! * 0.25,
                              height: height! * 0.008,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: width! * 0.25,
                              height: height! * 0.008,
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
