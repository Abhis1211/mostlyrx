import 'package:flutter/material.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';
import 'package:mostlyrx/ui/terms.dart';
import 'package:mostlyrx/ui/view/auth/login.dart';
import 'package:mostlyrx/ui/view/auth/registre.dart';
import 'package:mostlyrx/ui/view/map_ttn_view.dart';
import 'package:mostlyrx/ui/view/map_view.dart';
import 'package:mostlyrx/ui/view/order_accept.dart';
import 'package:mostlyrx/ui/view/startup_view.dart';
import 'package:mostlyrx/ui/widgets/app_wrapper.dart';
import 'package:mostlyrx/ui/widgets/change_password.dart';
import 'package:mostlyrx/ui/widgets/intro.dart';
import 'package:mostlyrx/ui/widgets/order_details.dart';
import 'package:mostlyrx/ui/widgets/otp_page.dart';
import 'package:mostlyrx/ui/widgets/signature_widget.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/splash':
        // ignore: prefer_const_constructors
        return MaterialPageRoute(builder: (_) => StartUpView());

      case '/intro':
        return MaterialPageRoute(builder: (_) => const IntroWidget());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case '/RegistrePage':
        return MaterialPageRoute(builder: (_) => const RegistrePage());
      case '/terms':
        return MaterialPageRoute(builder: (_) => const Terms());
      case '/forgot_password':
        return MaterialPageRoute(
            builder: (_) => ChangePassword(
                  mail: args as String,
                ));

      case '/home':
        return MaterialPageRoute(
            builder: (_) => AppWrapperWidget(
                  index: args as int?,
                ));

      case '/order_details':
        return MaterialPageRoute(
            builder: (_) => OrderDetailsWidget(args as Order));

      case '/map_view':
        return MaterialPageRoute(builder: (_) => MapView(args as Order));

      case '/signature_pad':
        return MaterialPageRoute(
            builder: (_) => SignaturePadWidget(args as OrdersViewModel));

      case '/in_app_map_view':
        return MaterialPageRoute(
            builder: (_) => MapTTnView(args as MapViewRouteArgs));
      case '/otp':
        return MaterialPageRoute(
            builder: (_) => OtpPage(phoneNumber: args as String));

      case '/order_status_screen':
        List<dynamic> arg = args as List;
        return MaterialPageRoute(
            builder: (_) => OrderStatusScreen(title: arg[0] as String,img:arg[1] as String ,
              orderStatus: arg[2] as int,));

    // If args is not of the correct type, return an error page.
      // You can also throw an exception while in development.
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
