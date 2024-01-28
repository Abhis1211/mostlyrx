import 'package:flutter/material.dart';
import 'package:mostlyrx/core/viewmodels/startup_view_model.dart';
import 'package:mostlyrx/ui/view/base_widget.dart';
import 'package:mostlyrx/ui/widgets/splash.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<StartUpViewModel>(
        model: StartUpViewModel(),
        onModelReady: (model) {},
        child: const SplashWidget(),
        builder: (context, model, child) => child!);
  }
}
