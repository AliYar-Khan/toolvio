import 'package:toolvio/utils/routes/routes_name.dart';
import 'package:toolvio/view/add_customer.dart';
import 'package:toolvio/view/add_task.dart';
import 'package:toolvio/view/create_invoice_selects_tasks.dart';
import 'package:toolvio/view/list_customer.dart';
import 'package:toolvio/view/list_tasks.dart';
import 'package:toolvio/view/login_screen.dart';
import 'package:toolvio/view/print_invoice_selected_tasks.dart';
import 'package:toolvio/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:toolvio/view/home_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
      case RoutesName.addtask:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AddTask());

      case RoutesName.addcustomer:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AddCustomer());

      case RoutesName.tasklist:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TaskList());

      case RoutesName.customerlist:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CustomerList());

      case RoutesName.createInvoice:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const CreateInvoiceSelectTasks());

      case RoutesName.printInvoice:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const PrintInvoiceSelectedTasks());

      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
    }
  }
}
