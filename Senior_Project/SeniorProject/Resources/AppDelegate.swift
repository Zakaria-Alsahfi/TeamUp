//
//  AppDelegate.swift
//  Meetup
//
//  Created by Zakatia Alsahfi on 2/7/18.
//  Copyright © 2018 sahfiza. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import NotificationCenter
import GoogleMaps
import GooglePlaces
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let configuration = ParseClientConfiguration {
            $0.applicationId = PARSE_APP_ID
            $0.clientKey = PARSE_CLIENT_KEY
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        saveInstallationObject()
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//            (granted, error) in
//            print("Permission granted: \(granted)")
//            guard granted else { return }
//            self.getNotificationSettings()
//        }
        
        PFTwitterUtils.initialize(withConsumerKey: "H7r2iI2CK5c07nyAf7zHiZLWL", consumerSecret:"4IxCcYHzDnxAEwtpBzn9hjlg5OiXxwnm8HtIwKXd2H5xrDAbpy")
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
        GMSServices.provideAPIKey("AIzaSyAZwfkx-2Y9NuQOO2AyJidFRDPq6kUUS9A")
        GMSPlacesClient.provideAPIKey("AIzaSyCEVEtNGrmKdbk7LulIeIT4Snx4jazqQkI")
        
        let image = UIImage(named: "Wlcome")
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = UIScreen.main.bounds
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.rootViewController?.view.addSubview(imageView)
        window?.rootViewController?.view.bringSubviewToFront(imageView)
        window?.makeKeyAndVisible()
        if PFUser.current() != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToHomePage") as! UITabBarController
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
        return true
}
    
func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
    func saveInstallationObject(){
        if let installation = PFInstallation.current(){
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully connected your app to Back4App!")
                } else {
                    if let myError = error{
                        print(myError.localizedDescription)
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        if PFUser.current() != nil {
            let currentUser = PFUser.current()!
            currentUser.saveInBackground()
            print("offline")
        }
        
    }
    private func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken as Data)
        installation?.saveInBackground(block: { (succ, error) in
            if error == nil {
                print("DEVICE TOKEN REGISTERED!")
            } else {
                print("\(error!.localizedDescription)")
            }
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        PFPush.handle(userInfo)
        if application.applicationState == .inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(inBackground: userInfo, block: nil)
        }
    }
}

