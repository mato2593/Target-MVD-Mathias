//
//  AppDelegate.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import MBProgressHUD
import GoogleMaps
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static let shared: AppDelegate = {
    guard let appD = UIApplication.shared.delegate as? AppDelegate else {
      return AppDelegate()
    }
    return appD
  }()
  var window: UIWindow?
  var spinner: MBProgressHUD!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    // -Facebook
    FBSDKSettings.setAppID(ConfigurationManager.getValue(for: "FacebookKey"))
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    
    // -GoogleMaps
    GMSServices.provideAPIKey(ConfigurationManager.getValue(for: "GoogleMapsKey")!)
    
    IQKeyboardManager.sharedManager().enable = true
    spinner = UIHelper.initSpinner()
    
    if UserDataManager.userHasToken() {
      let vc = UIStoryboard.instantiateInitialViewController()
      self.window?.rootViewController = vc
    }
    
    // -OneSignal
    let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
    
    OneSignal.initWithLaunchOptions(launchOptions,
                                    appId: "95d62317-4dd4-4d36-8575-f9a556fbf1d0",
                                    handleNotificationAction: nil,
                                    settings: onesignalInitSettings)
    
    OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
    
    // Recommend moving the below line to prompt for push after informing the user about
    //   how your app will use them.
    OneSignal.promptForPushNotifications(userResponse: { accepted in
      print("User accepted notifications: \(accepted)")
    })
    
    // Sync hashed email if you have a login system or collect it.
    //   Will be used to reach the user at the most optimal time of day.
    if let user = UserDataManager.getUserObject() {
      OneSignal.syncHashedEmail(user.email)
    }
    
    return true
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when 
    // the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}
