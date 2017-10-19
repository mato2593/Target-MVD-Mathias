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
import Pushwoosh
import SwiftyJSON
import JSQMessagesViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PushNotificationDelegate {
  
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
    
    PushNotificationManager.push().delegate = self
    
    // set default Pushwoosh delegate for iOS10 foreground push handling
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = PushNotificationManager.push().notificationCenterDelegate
    }
    
    // track application open statistics
    PushNotificationManager.push().sendAppOpen()
    
    return true
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    PushNotificationManager.push().handlePushRegistration(deviceToken as Data!)
    
    if let token = PushNotificationManager.push().getPushToken() {
      UserAPI.updatePushToken(token: token)
    }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    PushNotificationManager.push().handlePushRegistrationFailure(error)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    PushNotificationManager.push().handlePushReceived(userInfo)
    completionHandler(UIBackgroundFetchResult.noData)
  }
  
  func onPushAccepted(_ pushManager: PushNotificationManager!, withNotification pushNotification: [AnyHashable : Any]!, onStart: Bool) {
    if let pushBody = pushNotification["u"] as? String {
      let json = JSON(parseJSON: pushBody)
      
      if json["title"].string != nil {
        processNewMatchNotification(json)
      } else if json["text"].string != nil {
        processNewMessageNotification(json)
      }
    }
  }
  
  func processNewMatchNotification(_ json: JSON) {
    let chatViewController = UIStoryboard.instantiateViewController(ChatViewController.self)
    chatViewController?.match = MatchConversation.parse(fromPushNotification: json)
    
    if let navigationController = window?.rootViewController as? UINavigationController {
      navigationController.viewControllers.last?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
      navigationController.pushViewController(chatViewController!, animated: true)
    }
  }
  
  func processNewMessageNotification(_ json: JSON) {
    let message = JSQMessage.parse(fromJSON: json)
    let matchId = json["match_conversation"].intValue
    
    MatchesAPI.match(matchId, success: { match in
      let chatViewController = UIStoryboard.instantiateViewController(ChatViewController.self)
      chatViewController?.match = match
      
      if let navigationController = self.window?.rootViewController as? UINavigationController {
        navigationController.viewControllers.last?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController.pushViewController(chatViewController!, animated: true)
      }
    }, failure: { error in
      print(error.domain)
    })
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
