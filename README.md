![Static Badge](https://img.shields.io/badge/License-BSD_3_Clause-green) ![Pub Version](https://img.shields.io/pub/v/flutter_fx?color=blue) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/crianpiro/flutter_fx?label=bug)





This package is a suite of widgets, tools, extensions. With state management & navigation management strategies for flutter.

## Features

* [Fx State](#fxstate): To perform and listen changes in the UI.
* [Fx Navigation](#fxnavigation): To navigate easily.
* [Fx Suite](#fxsuite): To speed up the development, use tools and components.

---
## Getting started

## :collision: FxState

This feature was born from the need to update the states in your application in a simpler way, I have used many state managers in flutter but I have always thought the things could be simpler. A way to just use a class to define all the logic, set all the mutable variables and states in the pages and then simply listen to the states from different widgets in the pages.

### Usage

First, let's define a class to allocate all our states or mutable variables. We use the `Fx<T>` type to define a mutable variable, then we initialize the variable with the `T` type and convert it to `Fx<T>` by using the `toFx` extension.

```dart
import 'package:flutter_fx/flutter_fx.dart';

class HomeController {
  static final Fx<int>  currentTab = 0.toFx;
}
```

Now all we need to do is to use the `FxBuilder` in the parts we want to update according to the changes of the variables/states and listen to it using the `fxContext` of the `FxBuilder`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_fx/flutter_fx.dart';


class HomeScreen extends StatelessWidget {
  static const String path = "/homeScreen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FxScreen(
      screenBuilder: (context, paddings) => Center(
        child: FxBuilder(
          builder: (fxContext) {
            switch (HomeController.currentTab.listen(fxContext)) {
              case 1:
                return const CreatePatientTab();
              case 0:
              default:
                return const PatientsList();
            }
          },
        ),
      ),
      bottomNavigationBar: FxBuilder(builder: (fxContext) {
        return BottomNavigationBar(
            backgroundColor: AppColors.secondaryBackground,
            currentIndex: HomeController.currentTab.listen(fxContext),
            onTap: (value) => HomeController.changeTabIndex(value),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: "Patients",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Create patient",
              ),
            ]);
      }),
    );
  }
}

```

Now to update the variable/state we just need to call the `value` setter and the `FxState` will notify the widgets that are listening to this variable and update their state.

```dart
import 'package:flutter_fx/flutter_fx.dart';

class HomeController {
  static final Fx<int>  currentTab = 0.toFx;

  void changeTabIndex(int newIndex){
    currentTab.value = newIndex;
  }
}
```

#### Other types

```dart
// Using the Fx<T> definition and toFx extension
Fx<int> myInt = 0.toFx;
// Using the Fx<T> definition and toFx extension
Fx<String> myString = "Hello".toFx;
// Using the Fx<T> definition and toFx extension
Fx<Map<String,int>> myString = <String,int>{}.toFx;
// Using the Fx<T> definition and toFx extension
Fx<List<String>> myString = <String>[].toFx;
// Using the FxString type definition and toFx extension
FxString myFxString = "Hello".toFx;
// Using the FxInt type definition and toFx extension
FxInt myFxInt = 0.toFx;
// Using the FxBool type definition and the Fx constructor.
FxBool myBool = Fx(false);
// Using the Fx<T> type definition and the FxNullable class to support nullable types.
Fx<bool?> myNullableBool = FxNullable<bool?>.setNull();

```


## :collision: FxNavigation

This feature allows you to navigate without using the context. It also allows you to use custom transitions when navigating.

### Usage

To use the `FxNavigation` you need to use `FxApp` that uses [MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html) and therefore you can set some of the properties for `Material`.

The `FxApp` requires two arguments, the `initialRoute` so the app knows which will be the first route pushed into the stack, and the `routeBuilder` where you can define which widget to build in case of a specific path.

```dart
FxApp(
    initialRoute: "/",
    routeBuilder: (String path){
        switch (path) {
            case HomeScreen.path:
                return const HomeScreen();
            case "/":
            case SplashScreen.path:
            default:
                return const SplashScreen();
        }
    },
)
```

Later, to navigate within your application you can just use the `FxRouter` and send arguments to customize the transitions which the page will be pushed.

```dart
FxRouter.goToAndReplace(HomeScreen.path,
    arguments: NavigationArguments(
        payload: "Coming from SplashScreen",
        curve: Curves.easeInOut,
        barrierColor: Colors.transparent,
        routeTransition: RouteTransition.animated,
        transitionDirection: TransitionDirection.rightToLeft,
      ));
```

## :collision: FxSuite

This feature was born from the need to have in new projects the single basic characteristics that almost every application has. Have a look at the few components available I am sure you will find them useful.

### FxScreen
This component is focused on simplify the way a UI screen is built. It allows you to have customize easily backgrounds, overlays, screenPaddings, etc.

:bulb: **Tip:** To have full control over the screen customization in android there are two important things to do.

* First, you must add or edit `android/app/src/main/res/values/styles.xml` and `android/app/src/main/res/values-night/styles.xml` files in your project.

  :eight_spoked_asterisk: You can also save this step and use the plugin [mobile_window_features](https://pub.dev/packages/mobile_window_features) by  [merakidevelop.com.co](merakidevelop.com.co)

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
        
        <!-- Start of the section to add -->
        <item name="android:navigationBarColor">#00000000</item>
        <item name="android:statusBarColor">#00000000</item>
        <item name="android:windowTranslucentNavigation">true</item>
        <item name="android:enforceNavigationBarContrast">false</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>
        <!-- End of the section to add -->
        
        <item name="android:windowSplashScreenBackground">#171717</item>
        <item name="android:windowSplashScreenAnimatedIcon">@drawable/launch_background</item>
    </style>
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
```

* Second, you must use the `WidgetsFlutterBinding.ensureInitialized` function and enable the edge to edge mode for Android in flutter before running your app.

```dart
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    runApp(const MyApp());
}
```

### Usage

Import the library

```dart
import 'package:flutter_fx/flutter_fx.dart';
```

Return the [FxScreen](https://pub.dev/documentation/flutter_fx/latest/flutter_fx/FxScreen-class.html) in your page

```dart
import 'package:flutter/services.dart';
import 'package:flutter_fx/flutter_fx.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FxScreen(
      /// required
      screenBuilder: (context, paddings) => 
      /// By default the encapsulateScreen property is true, therefore the screen will be encapsulated 
      /// into paddings that will keep the content away from the navigation and status bars.
      /// However if you need to achieve something and customize the way you use the screen 
      /// paddings you can use the paddings parameter from the screenBuilder function.

      /// You can now put the widgets in the screen builder without worrying about anything else
      const MyScreenContent(),
      /// By using the uiOverlayStyle property you can customize the status bar and navigation bar look like.
      /// uiOverlayStyle: SystemUiOverlayStyle(
      ///  statusBarColor: Colors.transparent,
      ///  statusBarIconBrightness: Brightness.light,
      ///  statusBarBrightness: Brightness.light,
      ///  systemNavigationBarColor: Colors.transparent,
      ///  systemNavigationBarIconBrightness: Brightness.light,
      /// ),
      uiOverlayStyle: SystemUiOverlayStyle.dark,
      /// You can add a background to the screen using the screenBackgroundBuilder
      screenBackgroundBuilder: (context, paddings) =>
      /// Same as the screenBuilder, you can use the paddings parameter to customize the way you use the screen paddings
      Image.asset(
        "custom_background.png",
      ),
      /// You can add a overlay to the screen using the screenOverlayBuilder. 
      /// I use it to show a loading indicator while performing operations
      screenOverlayBuilder: (context) => const CircularProgressIndicator(),
    );
  }
}
```

### FxComponents

* [**FxButton**](https://pub.dev/documentation/flutter_fx/latest/flutter_fx/FxButton-class.html) is a [FilledButton](https://api.flutter.dev/flutter/material/FilledButton-class.html) with a default style, wrapped with paddings to simplify separation between components. It allows full customization.

```dart
FxButton(          
    content: "Press me",
    ///required
    onPressedF: (){}
)
```

* [**FxTextField**](https://pub.dev/documentation/flutter_fx/latest/flutter_fx/FxTextField-class.html) is a [TextField](https://api.flutter.dev/flutter/material/TextField-class.html) with a default style wrapped with paddings to facilitate the separation of fields in forms. It allows full customization.

```dart
FxTextField(
    label: "Text field"
    ///required
    inputController: textController
)
```

* [**FxTextButton**](https://pub.dev/documentation/flutter_fx/latest/flutter_fx/FxTextButton-class.html) is a [TextButton](https://api.flutter.dev/flutter/material/TextButton-class.html) with a default style using `shrinkWrap` as `tapTargetSize`.

```dart
FxTextButton(
    ///required
    textContent: "Content", 
    ///required
    onPressedF: (){}
),
```

### FxExtensions

* **FxScaleSize** allows to scale the size taking into account the size of viewport in which the design was created.

To set the size of the viewport that applies to you set the following before your `runApp` method:

```dart
FxScaleSize.viewportWidth = 500 // Your viewport width
FxScaleSize.viewportHeight = 1200 // Your viewport height
```

### FxValidators

This feature is just a copy of some validators I used at some point, Soon I will improve them and add some more of the most used ones.

* validateEmail
* validateUsernameText
* validateText
* compareText
* validatePhoneNumber
* validateDouble
* validatePositiveDouble
* validatePositiveInt
* validateNCFSequence
* validateMinorThan
* validateGreaterThan

#### Usage

Import the library
```dart
import 'package:flutter_fx/flutter_fx.dart';
```
Use the validator   
```dart
final String? error = FxValidators.validateEmail("hola@as.co");
```

---

This package is under constant development because was born from my need to centralize the tools and strategies I like to use in different flutter projects.

If you find it useful and want to contribute please feel free to create an issue. Also if you feel you need something that is not still in the package and you would like me to prioritize or if you find a bug.

---

## :heavy_exclamation_mark: :mega: :soon: Roadmap 

* :white_square_button: Support more customization in the navigation transitions.
* :white_square_button: `FxPage` widget to support the controller based page and simplify the way to use `FxState`.
* :white_square_button: Support more `Material` properties in the `FxApp`.
* :white_square_button: Support operations with the `Fx<T>` and improve the way the structures can be updated.
* :white_square_button: Include more `FxComponents`.
* :white_square_button: Improve the `FxValidators`.
* :white_square_button: Package snippets to speed up the development.
* :white_square_button: `FxKeyState` to allow a state management based on specific keys.
* :white_square_button: Performance report, advantages and disadvantages.


