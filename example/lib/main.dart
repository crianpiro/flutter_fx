import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fx/flutter_fx.dart';

FutureOr<void> main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await ErrorHandler.initialize();
    // await Preferences.initPreferences();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // FlutterError.onError =
    //     (FlutterErrorDetails details) => ErrorHandler.handleError(details);
    runApp(FxApp(
      initialRoute: "/",
      routeBuilder: (route) {
        switch (route) {
          case "main":
            return Scaffold(
              backgroundColor: Colors.red,
            );
          case "/":
          default:
            return const MainPage();
        }
      },
    ));
  }, ((error, stack) {
    // ErrorHandler.handleException(error, stack);
  }));
}

class MainPageController {
  static Fx<String> text = "data".toFx;
  static FxString text2 = "NO DATA".toFx;

  static void changeState() {
    text.value = "new data ${Random().nextDouble().toString()}";
    text2.value = "new data ${Random().nextDouble().toString()}";
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {

    ViewArguments asdd = ViewArguments();
    
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FxBuilder(builder: (fxContext) {
            return Text(MainPageController.text.listen(fxContext));
          }),
          FxBuilder(builder: (fxContext) {
            return Text(MainPageController.text2.listen(fxContext));
          }),
          ElevatedButton(
              onPressed: () {
                MainPageController.changeState();
                // FxRouter.goTo("main",
                //     arguments: NavigationArguments(
                //         transitionDirection: TransitionDirection.bottomToTop));
              },
              child: Text("Change state"))
        ],
      ),
    );
  }
}
