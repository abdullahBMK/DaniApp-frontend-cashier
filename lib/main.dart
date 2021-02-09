// import 'package:deliveryboy/src/models/setting.dart';
// import 'package:dynamic_theme/dynamic_theme.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:global_configuration/global_configuration.dart';

// import 'src/helpers/app_config.dart' as config;
// // import 'config/app_config.dart' as config;
// import 'generated/i18n.dart';
// import 'route_generator.dart';
// import 'src/repository/settings_repository.dart' as settingRepo;

// FirebaseAnalytics analytics = FirebaseAnalytics();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await GlobalConfiguration().loadFromAsset("configurations");
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
// //  /// Supply 'the Controller' for this application.
// //  MyApp({Key key}) : super(con: Controller(), key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DynamicTheme(
//         defaultBrightness: Brightness.light,
//         data: (brightness) {
//           if (brightness == Brightness.light) {
//             return ThemeData(
//               fontFamily: 'Poppins',
//               primaryColor: Colors.white,
//               floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
//               brightness: brightness,
//               accentColor: config.Colors().mainColor(1),
//               focusColor: config.Colors().accentColor(1),
//               hintColor: config.Colors().secondColor(1),
//               // accentColor: config.Colors().mainColor(1),
//               // dividerColor: config.Colors().accentColor(0.05),
//               // focusColor: config.Colors().accentColor(1),
//               // hintColor: config.Colors().secondColor(1),
//               textTheme: TextTheme(
//                 headline: TextStyle(fontSize: 20.0, color: config.Colors().secondColor(1)),
//                 display1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
//                 display2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
//                 display3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
//                 display4: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1)),
//                 subhead: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),
//                 title: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainColor(1)),
//                 body1: TextStyle(fontSize: 12.0, color: config.Colors().secondColor(1)),
//                 body2: TextStyle(fontSize: 14.0, color: config.Colors().secondColor(1)),
//                 caption: TextStyle(fontSize: 12.0, color: config.Colors().accentColor(1)),
//               ),
//             );
//           } else {
//             return ThemeData(
//               fontFamily: 'Poppins',
//               primaryColor: Color(0xFF252525),
//               brightness: Brightness.dark,
//               floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
//               scaffoldBackgroundColor: Color(0xFF2C2C2C),
//               accentColor: config.Colors().mainDarkColor(1),
//               hintColor: config.Colors().secondDarkColor(1),
//               focusColor: config.Colors().accentDarkColor(1),
//               textTheme: TextTheme(
//                 headline: TextStyle(fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
//                 display1:
//                     TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().secondDarkColor(1)),
//                 display2:
//                     TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().secondDarkColor(1)),
//                 display3:
//                     TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1)),
//                 display4:
//                     TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(1)),
//                 subhead:
//                     TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1)),
//                 title: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainDarkColor(1)),
//                 body1: TextStyle(fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
//                 body2: TextStyle(fontSize: 14.0, color: config.Colors().secondDarkColor(1)),
//                 caption: TextStyle(fontSize: 12.0, color: config.Colors().secondDarkColor(0.6)),
//               ),
//             );
//           }
//         },
//         themedWidgetBuilder: (context, theme) {
//           return ValueListenableBuilder(
//             valueListenable: settingRepo.setting,
//               builder: (context, Setting _setting, _) {
//               // valueListenable: settingRepo.locale,
//               // builder: (context, Locale value, _) {
//                 // print(value);
//                  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//                 _firebaseMessaging.configure(
//                   onMessage: (Map<String, dynamic> message) async {
//                     // showDialog(
//                     //   context: scaffoldKey.currentContext,
//                     //   builder: (context) => AlertDialog(
//                     //     content: ListTile(
//                     //       title: Text(message['notification']['title']),
//                     //       subtitle: Text(message['notification']['body']),
//                     //     ),
//                     //     actions: <Widget>[
//                     //       FlatButton(
//                     //         child: Text('Ok'),
//                     //         onPressed: () => Navigator.of(context).pop(),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // );
//                     print("onMessage: $message");
//                   },
//                   onLaunch: (Map<String, dynamic> message) async {
//                     print("onLaunch: $message");
//                   },
//                   onResume: (Map<String, dynamic> message) async {
//                     print("onResume: $message");
//                   },
//                 );
//                 return MaterialApp(
//                   title: 'Delivery Boy',
//                   initialRoute: '/Splash',
//                   onGenerateRoute: RouteGenerator.generateRoute,
//                   debugShowCheckedModeBanner: false,
//                   locale: Locale('en', ''),
//                   localizationsDelegates: [
//                     S.delegate,
//                     GlobalMaterialLocalizations.delegate,
//                     GlobalWidgetsLocalizations.delegate,
//                   ],
//                   supportedLocales: S.delegate.supportedLocales,
//                   localeListResolutionCallback: S.delegate.listResolution(fallback: const Locale('en', '')),
//                   navigatorObservers: [
//                     FirebaseAnalyticsObserver(analytics: analytics),
//                   ],
//                   theme: theme,
//                 );
//               });
//         });
//   }
// }

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'generated/i18n.dart';
import 'route_generator.dart';
import 'src/controllers/controller.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  runApp(MyApp());
}

class MyApp extends AppMVC {
  // This widget is the root of your application.
//  /// Supply 'the Controller' for this application.
  MyApp({Key key}) : super(con: Controller(), key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) {
          if (brightness == Brightness.light) {
            return ThemeData(
              fontFamily: 'ProductSans',
              primaryColor: Colors.white,
              floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
              brightness: brightness,
              accentColor: config.Colors().mainColor(1),
              dividerColor: config.Colors().accentColor(0.05),
              focusColor: config.Colors().accentColor(1),
              hintColor: config.Colors().secondColor(1),
              textTheme: TextTheme(
                headline: TextStyle(fontSize: 22.0, color: config.Colors().secondColor(1)),
                display1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1)),
                display2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1)),
                display3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                display4: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1)),
                subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),
                title: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1)),
                body2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1)),
                caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().accentColor(1)),
              ),
            );
          } else {
            return ThemeData(
              fontFamily: 'ProductSans',
              primaryColor: Color(0xFF252525),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Color(0xFF2C2C2C),
              accentColor: config.Colors().mainDarkColor(1),
              hintColor: config.Colors().secondDarkColor(1),
              focusColor: config.Colors().accentDarkColor(1),
              textTheme: TextTheme(
                headline: TextStyle(fontSize: 22.0, color: config.Colors().secondDarkColor(1)),
                display1:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1)),
                display2:
                    TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1)),
                display3:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1)),
                display4:
                    TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(1)),
                subhead:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1)),
                title: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1)),
                body1:
                    TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1)),
                body2:
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1)),
                caption:
                    TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(0.6)),
              ),
            );
          }
        },
        themedWidgetBuilder: (context, theme) {
          return ValueListenableBuilder(
              valueListenable: settingRepo.setting,
              builder: (context, Setting _setting, _) {
                final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
                _firebaseMessaging.subscribeToTopic('wamyada');
                _firebaseMessaging.configure(
                  onMessage: (Map<String, dynamic> message) async {
                    print("splash screen onMessage: $message");
                  },
                  onLaunch: (Map<String, dynamic> message) async {
                    print("splash screen onLaunch: $message");
                  },
                  onResume: (Map<String, dynamic> message) async {
                    print(" splash screen  onResume: $message");
                  },
                  // onBackgroundMessage: myBackgroundMessageHandler,
                );
                return MaterialApp(
                  title: 'SoolzApp',
                  initialRoute: '/Splash',
                  onGenerateRoute: RouteGenerator.generateRoute,
                  debugShowCheckedModeBanner: false,
                  locale: Locale('en', ''),
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  localeListResolutionCallback: S.delegate.listResolution(fallback: const Locale('en', '')),
                  theme: theme,
                );
              });
        });
  }
}
