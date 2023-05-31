import 'package:dtlearning/pages/splash.dart';
import 'package:dtlearning/provider/addtransectionprovider.dart';
import 'package:dtlearning/provider/cartprovider.dart';
import 'package:dtlearning/provider/contectusprovider.dart';
import 'package:dtlearning/provider/coursedetailsprovider.dart';
import 'package:dtlearning/provider/courselistbycategoryidprovider.dart';
import 'package:dtlearning/provider/courselistbytutoridprovider.dart';
import 'package:dtlearning/provider/deletecartprovider.dart';
import 'package:dtlearning/provider/deletewishlistprovider.dart';
import 'package:dtlearning/provider/downloaddeleteprovider.dart';
import 'package:dtlearning/provider/downloadprovider.dart';
import 'package:dtlearning/provider/generalprovider.dart';
import 'package:dtlearning/provider/getpageprovider.dart';
import 'package:dtlearning/provider/homeprovider.dart';
import 'package:dtlearning/provider/mycourseprovider.dart';
import 'package:dtlearning/provider/profileprovider.dart';
import 'package:dtlearning/provider/searchprovider.dart';
import 'package:dtlearning/provider/wishlistprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => CourseDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CartlistProvider()),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
        ChangeNotifierProvider(create: (_) => DownloadDeleteProvider()),
        ChangeNotifierProvider(create: (_) => DeletewishlistProvider()),
        ChangeNotifierProvider(create: (_) => DeleteCartProvider()),
        ChangeNotifierProvider(create: (_) => MyCourseProvider()),
        ChangeNotifierProvider(create: (_) => GetPageProvider()),
        ChangeNotifierProvider(create: (_) => ContectUsProvider()),
        ChangeNotifierProvider(create: (_) => AddtransectionProvider()),
        ChangeNotifierProvider(create: (_) => CourselistByTutoridProvider()),
        ChangeNotifierProvider(create: (_) => CourselistByCategoryidProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //  theme: ThemeModel().lightmode,
      // darkTheme: ThemeModel().darkmode,
      home: Splash(),
    );
  }
}
