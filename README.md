# eTour iOS app
eTour iOS app. Integrated to Flutter module. Basically handles the iBeacon discovery.

## Overview

All the logic happens inside AppDelegate. Besides running the FlutterViewController (the flutter module), the app requests the location permission, registers the Flutter event channel ```etour_event_channel```, and starts monitoring iBeacon with the UUID ```B9407F30-F5F8-466E-AFF9-25556B57FE6D``` which is currently hardcoded.

## Integration to the Flutter module

These instructions follow the guidelines from official Flutter docs, if you run into any problems refer to this link: 
https://flutter.dev/docs/development/add-to-app/ios/project-setup

1. Follow instructions on the [Flutter module repo](https://github.com/Beacon-eTour/eTour-flutter) to run that.
2. Clone this repo. Note that the project is setup so that this project and the Flutter module should live in the same root folder like this:
```some/path/
├── eTour-flutter/
│   └── .ios/
│       └── Flutter/
│         └── podhelper.rb
└── eTour-ios/
    └── Podfile
```
3. Install Xcode (if you don't have that yet)
4. The project uses CocoaPods as dependency manager, if you don't have that, refer to the [installation instructions](https://cocoapods.org/). 
5. Run ``pod install`` on the ETouriOS folder
6. Open eTour.xcworkspace on Xcode
7. Run the app on Xcode
