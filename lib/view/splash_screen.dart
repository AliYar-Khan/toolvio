import 'package:toolvio/utils/routes/routes_name.dart';
import 'package:toolvio/view_model/invoicing_view_model.dart';
import 'package:toolvio/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkPermissions() async {
    bool status = await Permission.storage.isGranted;
    if (!status) {
      await Permission.storage.request();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LoginViewModel loginViewModel =
          Provider.of<LoginViewModel>(context, listen: false);
      InvoicingViewModel invoicingViewModel =
          Provider.of<InvoicingViewModel>(context, listen: false);
      checkPermissions();
      loginViewModel.checkSession().then((value) => {
            if (value)
              {
                invoicingViewModel
                    .getAllInvoices(context)
                    .then((value) => invoicingViewModel.getFilteredInvoices()),
                Navigator.of(context).pushNamed(RoutesName.home)
              }
            else
              {Navigator.of(context).pushNamed(RoutesName.login)}
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF9FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/toolivo_icon.png',
              width: 147,
              height: 112,
            ),
            const SizedBox(height: 5),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
