import 'package:fixitjo_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';
import 'package:fixitjo_app/screens/dashboard_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Gemini.init(apiKey: 'AIzaSyBL95VJKxe_IbB_YFQC84VRVW4FhYNNGrk');

  runApp(
    ChangeNotifierProvider(create: (_) => AppLanguage(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguage>(
      builder: (context, lang, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FixItJo',

          locale: lang.locale,

          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: lang.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },

          theme: ThemeData(primarySwatch: Colors.blue),

          home: const DashboardPage(),
        );
      },
    );
  }
}
