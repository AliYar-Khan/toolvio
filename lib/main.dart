import 'package:toolivo/utils/routes/routes.dart';
import 'package:toolivo/utils/routes/routes_name.dart';
import 'package:toolivo/view_model/customer_view_model.dart';
import 'package:toolivo/view_model/invoicing_view_model.dart';
import 'package:toolivo/view_model/language_view_model.dart';
import 'package:toolivo/view_model/login_view_model.dart';
import 'package:toolivo/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  final String locale = sp.getString("locale") ?? 'de';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomerViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => InvoicingViewModel(),
        ),
      ],
      child: MyApp(locale: locale),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String locale;
  const MyApp({super.key, required this.locale});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageViewModel>(
      builder: (context, provider, child) {
        return MaterialApp(
          locale: provider.appLocale ?? Locale(locale),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('de'), // German
          ],
          title: 'Toolvia',
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoutes,
        );
      },
    );
  }
}
