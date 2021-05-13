//
//  AppDelegate.swift
//  eTour
//
//  Created by Penttilä Topi on 6.2.2021.
//

import UIKit
import Flutter
// Used to connect plugins (only if you have plugins with iOS platform code).
import FlutterPluginRegistrant
import CoreBluetooth
import CoreLocation

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    
    let locationManager = CLLocationManager()
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let handler = SwiftStreamHandler()
        locationManager.delegate = handler
        locationManager.requestAlwaysAuthorization()
        let eventChannelName = "etour_event_channel"
        
        if let controller : FlutterViewController = window?.rootViewController as? FlutterViewController {
            let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: controller.binaryMessenger)
            eventChannel.setStreamHandler(handler)
        }
        startMonitoring()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }
    
    func startMonitoring() {
        let localBeaconUUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        
        let uuid = UUID(uuidString: localBeaconUUID)!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "eTour")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
}

class SwiftStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
    private var _eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didenter")
        // Required for background monitoring (if app killed)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let nearestBeacon = beacons.first, (nearestBeacon.proximity == CLProximity.near || nearestBeacon.proximity == CLProximity.immediate) else {
            return
        }
        let firstMajor = nearestBeacon.major
        _eventSink?(firstMajor)
        
    }
    
    @available(iOS 13.0, *)
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print(beacons)
    }
}

