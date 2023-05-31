import 'dart:developer';
import 'package:dtlearning/pages/bottombar.dart';
import 'package:dtlearning/provider/addtransectionprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:dtlearning/widget/paymentmethod.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout extends StatefulWidget {
  final String? coursedetail, discountamount, userid, couponid;
  const Checkout(
      {super.key,
      required this.coursedetail,
      required this.discountamount,
      required this.userid,
      required this.couponid});

  @override
  State<Checkout> createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  SharedPre sharedpre = SharedPre();
  Constant constant = Constant();
  late ProgressDialog prDialog;
  String username = "";
  String email = "";
  String number = "";

  @override
  initState() {
    super.initState();
    prDialog = ProgressDialog(context);
    _getdata();
  }

  _getdata() async {
    username = await sharedpre.read("fullname") ?? "";
    email = await sharedpre.read("email") ?? "";
    number = await sharedpre.read("number") ?? "";
    log("username ==>$username");
    log("email ==>$email");
    log("number ==>$number");
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
            type: 1,
            startImg: "ic_back.svg",
            startImgcolor: white,
            text: "Checkout",
            textcolor: white,
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: white,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            checkoutText(),
            paymentMethods(),
          ]),
        ),
      ),
    );
  }

  Widget checkoutText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        MyText(
          color: colorAccent,
          text: "Payment Method",
          maxline: 1,
          fontwaight: FontWeight.w500,
          fontsize: 16,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal,
        ),
        const SizedBox(
          height: 5,
        ),
        MyText(
          color: gray,
          text: "Choose a payment Methods to pay",
          maxline: 1,
          fontwaight: FontWeight.w500,
          fontsize: 12,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal,
        ),
        const SizedBox(
          height: 10,
        ),
        MyText(
          color: colorprimaryDark,
          text: "Pay with",
          maxline: 1,
          fontwaight: FontWeight.w500,
          fontsize: 14,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal,
        ),
      ],
    );
  }

  Widget paymentMethods() {
    return Column(
      children: [
        const SizedBox(height: 15),
        // InkWell(
        //   onTap: () async {},
        //   child: const PaymentMethod(
        //       paymenticon: "ic_paypal.svg", methodname: "Paypal"),
        // ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {
            final Razorpay razorpay = Razorpay();
            var options = {
              'key': constant.razorpaykey,
              'amount': double.parse(widget.discountamount.toString()) * 100,
              'name': username.toString(),
              'description': 'Course Payment',
              'retry': {'enabled': true, 'max_count': 1},
              'send_sms_hash': true,
              'prefill': {
                'contact': number.toString(),
                'email': email.toString()
              },
              'external': {
                'wallets': ['paytm']
              }
            };

            razorpay.on(
                Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
            razorpay.on(
                Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
            razorpay.on(
                Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
            razorpay.open(options);
          },
          child: const PaymentMethod(
              paymenticon: "ic_razerpay.svg", methodname: "RazorPay"),
        ),
        const SizedBox(height: 15),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return const Bottombar();
        //         },
        //       ),
        //     );
        //   },
        //   child: const PaymentMethod(
        //       paymenticon: "ic_paytm.svg", methodname: "Paytm"),
        // ),
        const SizedBox(height: 15),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return const Bottombar();
        //         },
        //       ),
        //     );
        //   },
        //   child:
        //       const PaymentMethod(paymenticon: "ic_upi.svg", methodname: "Upi"),
        // ),
        const SizedBox(height: 15),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return const Bottombar();
        //         },
        //       ),
        //     );
        //   },
        //   child: const PaymentMethod(
        //       paymenticon: "ic_flutterwave.svg", methodname: "FlutterWave"),
        // ),
        const SizedBox(height: 15),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return const Bottombar();
        //         },
        //       ),
        //     );
        //   },
        //   child: const PaymentMethod(
        //       paymenticon: "ic_payU.svg", methodname: "PayUMoney"),
        // ),
      ],
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    failDilog(context, "Payment Failed", "Try Again", "");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    addtranscation(response.paymentId.toString());
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
      context,
      "External Wallet Selected",
      "${response.walletName}",
    );
  }

  addtranscation(paymentid) async {
    final transectionItem =
        Provider.of<AddtransectionProvider>(context, listen: false);
    Utils.showProgress(context, prDialog);
    await transectionItem.getaddtransection(
        // Course Detail
        widget.coursedetail,
        // Userid passing
        widget.userid,
        // Payment type
        "1",
        // Coupon id
        "1",
        // Currency code
        "INR",
        // Final Amount
        widget.discountamount,
        // assign Couponid
        "1",
        // payment Id
        paymentid.toString());

    if (transectionItem.loading) {
      Utils.pageLoader();
    } else {
      if (transectionItem.addtransectionModel.status == 200) {
        Utils()
            .showToast(transectionItem.addtransectionModel.message.toString());
        prDialog.hide();
      } else {
        Utils()
            .showToast(transectionItem.addtransectionModel.message.toString());
        prDialog.hide();
      }
    }

    if (!mounted) {}
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Bottombar();
        },
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Bottombar();
            },
          ),
        );
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void failDilog(
      BuildContext context, String title, String message, String paymementId) {
    Widget continueButton = ElevatedButton(
      child: const Text("Retry"),
      onPressed: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Bottombar();
            },
          ),
        );
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
