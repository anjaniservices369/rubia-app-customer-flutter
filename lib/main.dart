// @dart = 3.2
// =============================================================================
// WHAT : App entry point. Starts the app, restores the saved login, shows the
//        splash screen and decides the first screen (onboarding, personal
//        details, or home).
// NOTES: Also sets up push notifications and the shared data holders
//        (providers). Everything the customer sees starts from MyApp below.
// =============================================================================
import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';

// import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/providers/earningsProvider.dart';
import 'package:base_project_flutter/providers/riderProvider.dart';
import 'package:base_project_flutter/providers/themeProvider.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/EmergencyContact/EmergencyContacts.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/logiPage/loginPage.dart';
import 'package:base_project_flutter/views/translation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:base_project_flutter/api_services/pushService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'constants/imageConstant.dart';
import 'globalFuctions/globalFunctions.dart';
import 'providers/notifactionProvider.dart';

//

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

// >>> START: main - program start: prepares push, reads the saved login and opens the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The screens are designed for portrait; turning the phone sideways made the login and booking screens overflow.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      options.sendDefaultPii = false;
      options.tracesSampleRate = 0;
    },
    appRunner: _startApp,
  );
}

// >>> START: _startApp - starts app
Future<void> _startApp() async {
  try {
    await PushService.init();
  } catch (error, stackTrace) {
    debugPrint('Push initialization failed: $error\n$stackTrace');
    await Sentry.captureException(error, stackTrace: stackTrace);
  }
  if (!kIsWeb) {
    try {
      channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);
    } catch (error, stackTrace) {
      debugPrint('Notification channel setup failed: $error\n$stackTrace');
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var authCode = sharedPreferences.getString('authCode');
  var checkAuth = '1';
  var checkMail;
  var checkDetails;
  var emergencyContactDetails;
  if (authCode != null) {
    var check = await UserAPI().checkApi(authCode);
    if (check != null && check['status'] == 'OK') {
      // registration is finished only with a name, an email and the mobile number on the account
      final registered = ['email', 'first_name', 'contact_no'].every(
          (k) => (check['detail'][k] ?? '').toString().trim().isNotEmpty);
      if (registered) {
        checkMail = '2';
        checkAuth = '1';
        checkDetails = check['detail']['personal_details'];
        emergencyContactDetails = check['detail']['user_emergency_contacts'];
        sharedPreferences.setInt('USER_ID', check['detail']['id']);
      } else {
        // No email yet: the registration (name, email, then two emergency contacts) is not finished. Resume it instead of opening Home.
        checkMail = null;
        checkDetails = false;
      }
    } else {
      checkAuth = '';
    }
  } else {
    checkAuth = '';
  }
  sharedPreferences.remove('service_type');
  pref.remove('serviceType');
  runApp(
    SentryWidget(
      child: MyApp(
        checkAuth: checkAuth,
        checkMail: checkMail,
        checkDetails: checkDetails,
        emergencyContact: emergencyContactDetails,
        key: MyApp.navigatorKey,
      ),
    ),
  );
}
// <<< END: _startApp - starts app
// <<< END: main - program start: prepares push, reads the saved login and opens the app

// >>> START: MyApp - the root of the app: themes, languages and the first screen
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  const MyApp(
      {required Key key,
      this.checkAuth,
      this.checkMail,
      this.checkDetails,
      this.emergencyContact})
      : super(key: key);
  final checkAuth;
  final checkMail;
  final checkDetails;
  final emergencyContact;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
// <<< END: MyApp - the root of the app: themes, languages and the first screen

// >>> START: _MyAppState - the data and logic behind its screen
class _MyAppState extends State<MyApp> {
  //         checkDetails = check['detail'];
  //         print(checkDetails);

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    // NotificationController.startListeningNotificationEvents();
    // TODO: implement initState
    super.initState();
    // fetchCheck();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // This widget is the root of your application.
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<TripOptionsProvider>(
          create: (context) => TripOptionsProvider(),
        ),
        ChangeNotifierProvider<MyNotifactionProvider>(
          create: (context) => MyNotifactionProvider(),
        ),
        ChangeNotifierProvider<EarningsProvider>(
            create: (context) => EarningsProvider()),
      ],
      child: Sizer(builder: (context, orientation, screenType) {
        return GetMaterialApp(
          color: tPrimaryColor,
          defaultTransition: Transition.native,
          translations: LanguageTranslations(),
          locale: const Locale('en', "US"),
          fallbackLocale: const Locale('en', "US"),
          title: 'Rubia User',
          debugShowCheckedModeBanner: false,
          // Phones on Android 15+ draw apps edge to edge, so the on-screen navigation bar sits on top of the bottom of every
          // screen (buttons such as Next, Cancel Ride and Later were half hidden). Keep the whole app above it, and take the
          // same amount off the keyboard inset so screens with a keyboard still fit.
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            final navBar = mq.viewPadding.bottom;
            if (child == null) return const SizedBox.shrink();
            // The system navigation bar is white with dark icons, the same surface as the app's own bottom bar, so there is no grey band
            // between them (the band under the app used to show the window colour).
            const navStyle = SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: Colors.white,
              systemNavigationBarContrastEnforced: false,
            );
            if (navBar <= 0) return AnnotatedRegion<SystemUiOverlayStyle>(value: navStyle, child: child);
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: navStyle,
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
              padding: EdgeInsets.only(bottom: navBar),
              child: MediaQuery(
                data: mq.copyWith(
                  padding: mq.padding.copyWith(bottom: 0),
                  viewPadding: mq.viewPadding.copyWith(bottom: 0),
                  viewInsets: mq.viewInsets.copyWith(
                      bottom: (mq.viewInsets.bottom - navBar) < 0 ? 0 : mq.viewInsets.bottom - navBar),
                ),
                child: child,
              ),
            ),
              ),
            );
          },
          //suseInheritedMediaQuery: true,
          theme: ThemeData(
            textTheme: GoogleFonts.mulishTextTheme(
              Theme.of(context).textTheme,
            ).apply(bodyColor: tDarkNavyblue, displayColor: tDarkNavyblue),
            iconTheme: IconThemeData(color: tDarkNavyblue),
            colorScheme: ColorScheme.fromSeed(
              seedColor: tDarkNavyblue,
            ).copyWith(onSurface: tDarkNavyblue),
            primarySwatch: Colors.blue,
          ),
          home: ConnectivityWrapper(
            child: AnimatedSplashScreen(
                duration: 1000,
                // Same look as the Partner app's splash: the logo centred at a moderate size on white. (The logo image is a wide, tightly
                // cropped wordmark, so it is given a fixed width; at the old size of 400 it was wider than the screen and off-centre.)
                splash: Center(
                  child: SizedBox(
                    width: 145, // the same size as the logo of the Android 12 system splash, so the two look like one screen
                    child: Image.asset(
                      Images.LOGO,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                splashIconSize: 300,
                nextScreen: (widget.checkAuth == null || widget.checkAuth == '')
                    ? LoginScreen()
                    : (widget.checkDetails == false)
                        ? BottomNavigation(
                            tabIndexId: 0, showRegistrationSheet: true)
                        : (widget.emergencyContact == false)
                            ? EmergencyContact()
                            : BottomNavigation(
                                tabIndexId: 0,
                              ),
                splashTransition: SplashTransition.fadeTransition,
                backgroundColor: Colors.white),
          ),
        );
      }),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _MyAppState - the data and logic behind its screen

// >>> START: ConnectivityWrapper - screen/widget shell (the visible part is in its State class)
class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _ConnectivityWrapperState createState() => _ConnectivityWrapperState();
}
// <<< END: ConnectivityWrapper - screen/widget shell (the visible part is in its State class)

// >>> START: _ConnectivityWrapperState - the data and logic behind its screen
class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  // Assume online until the first real check finishes: defaulting to "none"
  // made every cold start flash the no-internet screen for a moment, before
  // checkConnectivity()'s result (or the stream's first event, which can
  // itself report a stale "none" while the radio is still reconnecting) came
  // back - not because the phone was actually offline.
  ConnectivityResult _connectivityResult = ConnectivityResult.wifi;
  Timer? _offlineDebounce;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_handleResult);
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: checkConnectivity - checks whether the phone is online
  Future<void> checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (mounted) _handleResult(connectivityResult);
    } catch (error, stackTrace) {
      debugPrint('Connectivity check failed: $error\n$stackTrace');
    }
  }
  // <<< END: checkConnectivity - checks whether the phone is online

  // >>> START: _handleResult - applies a connectivity reading, debouncing a drop so a momentary blip (e.g. Wi-Fi reassociating right at
  /**
   * Applies a connectivity reading, debouncing a drop so a momentary blip (e.g. Wi-Fi reassociating right at
   * app launch) does not flash the full-screen no-internet notice; coming back online is applied immediately.
   */
  // >>> START: _handleResult - handles result
  void _handleResult(ConnectivityResult result) {
    _offlineDebounce?.cancel();
    if (result != ConnectivityResult.none) {
      if (mounted) setState(() => _connectivityResult = result);
      return;
    }
    _offlineDebounce = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _connectivityResult = result);
    });
  }
  // <<< END: _handleResult - handles result
  // <<< END: _handleResult

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _offlineDebounce?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return _connectivityResult == ConnectivityResult.none
        ? NoInternetDialog()
        : widget.child;
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _ConnectivityWrapperState - the data and logic behind its screen

// >>> START: NoInternetDialog - screen/widget
class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({Key? key}) : super(key: key);

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBlue,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) Twl.willpopAlert(context);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Image.asset(
                      Images.RLogo,
                      width: 50.h,
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
            // Alert Dialog
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: AlertDialog(
                  backgroundColor: tWhite,
                  insetPadding: EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Text(
                    'No Internet Connection',
                    style: GoogleFonts.mulish(
                      color: tSecondaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: isTab(context) ? 14.sp : 16.sp,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Turn on mobile data or Wi-Fi to access the app.',
                        style: GoogleFonts.mulish(
                          fontSize: isTab(context) ? 9.sp : 13.sp,
                          fontWeight: FontWeight.w400,
                          color: tbrownn,
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    // You can add actions if needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: NoInternetDialog - screen/widget
