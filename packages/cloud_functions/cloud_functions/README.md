# Cloud Functions Plugin for Flutter

A Flutter plugin to use the [Cloud Functions for Firebase API](https://firebase.google.com/docs/functions/callable)

[![pub package](https://img.shields.io/pub/v/cloud_functions.svg)](https://pub.dev/packages/cloud_functions)

For Flutter plugins for other Firebase products, see [README.md](https://github.com/FirebaseExtended/flutterfire/blob/master/README.md).

## Setup

To use this plugin:

1. Using the [Firebase Console](http://console.firebase.google.com/), add an Android app to your project:
Follow the assistant, download the generated google-services.json file and place it inside android/app. Next,
modify the android/build.gradle file and the android/app/build.gradle file to add the Google services plugin
as described by the Firebase assistant. Ensure that your `android/build.gradle` file contains the
`maven.google.com` as [described here](https://firebase.google.com/docs/android/setup#add_the_sdk).
1. Using the [Firebase Console](http://console.firebase.google.com/), add an iOS app to your project:
Follow the assistant, download the generated GoogleService-Info.plist file, open ios/Runner.xcworkspace
with Xcode, and within Xcode place the file inside ios/Runner. Don't follow the steps named
"Add Firebase SDK" and "Add initialization code" in the Firebase assistant.
1. Add `cloud_functions` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Usage

```dart
import 'package:cloud_functions/cloud_functions.dart';
```

Getting an instance of the callable function:

```dart
final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'YOUR_CALLABLE_FUNCTION_NAME',
);
```

Calling the function:

```dart
dynamic resp = await callable.call();
```

Calling the function with parameters:

```dart
dynamic resp = await callable.call(<String, dynamic>{
    'YOUR_PARAMETER_NAME': 'YOUR_PARAMETER_VALUE',
});
```

## Getting Started

See the `example` directory for a complete sample app using Cloud Functions for Firebase.

## Issues and feedback

Please file FlutterFire specific issues, bugs, or feature requests in our [issue tracker](https://github.com/FirebaseExtended/flutterfire/issues/new).

Plugin issues that are not specific to Flutterfire can be filed in the [Flutter issue tracker](https://github.com/flutter/flutter/issues/new).

To contribute a change to this plugin,
please review our [contribution guide](https://github.com/FirebaseExtended/flutterfire/blob/master/CONTRIBUTING.md)
and open a [pull request](https://github.com/FirebaseExtended/flutterfire/pulls).
