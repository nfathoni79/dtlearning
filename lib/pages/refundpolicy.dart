import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/provider/getpageprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefundPolicy extends StatefulWidget {
  const RefundPolicy({super.key});

  @override
  State<RefundPolicy> createState() => RefundPolicyState();
}

class RefundPolicyState extends State<RefundPolicy> {
  Constant constant = Constant();

  @override
  void initState() {
    super.initState();
    callapi();
  }

  callapi() async {
    final getpageProvider =
        Provider.of<GetPageProvider>(context, listen: false);
    await getpageProvider.getpage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorprimaryDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: MyAppbar(
          type: 1,
          backTap: () {
            Navigator.of(context).pop(false);
          },
          startImg: "ic_back.svg",
          startImgcolor: white,
          text: constant.refandpolicy,
          textcolor: white,
        ),
      ),
      body: Consumer<GetPageProvider>(builder: (context, pageItem, child) {
        if (pageItem.loading) {
          return Utils.pageLoader();
        } else {
          if (pageItem.getpagemodel.status == 200 &&
              pageItem.getpagemodel.result!.isNotEmpty) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    MyText(
                      color: colorAccent,
                      text: pageItem.getpagemodel.result?[3].title.toString() ??
                          "",
                      maxline: 1,
                      fontwaight: FontWeight.w600,
                      fontsize: 16,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 10),
                    MyText(
                      color: colorPrimary,
                      text: pageItem.getpagemodel.result?[3].description
                              .toString() ??
                          "",
                      maxline: 50,
                      fontwaight: FontWeight.w400,
                      fontsize: 12,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const NoData();
          }
        }
      }),
    );
  }
}
