//
//  AppDelegate.swift
//  Tagabout
//
//  Created by Karun Pant on 11/02/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import DropDown
import Crashlytics
import Fabric
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard.init(name: "UserStory", bundle: Bundle.main)
//        if let vc :LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
//            window?.rootViewController = UINavigationController.init(rootViewController: vc)
//            window?.makeKeyAndVisible()
//        }
        
        
        
        if let _ = APIGateway.shared.authToken{
            GeneralUtils.addCrashlyticsUser()
            window?.rootViewController =  LandingViewController.landingViewController()
//            window?.makeKeyAndVisible()
        } else {
            if let vc :LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                window?.rootViewController = UINavigationController.init(rootViewController: vc)
                
            }
        }
        
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(30)
        
        self.registerForPushNotification(application)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .MessagingRegistrationTokenRefreshed,
                                               object: nil)
        
        DropDown.appearance().textColor = UIColor(white: 0.1, alpha: 1)
        DropDown.appearance().textFont = UIFont.init(name: "Avenir", size: 16.0)!
        DropDown.appearance().backgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1.0)
        DropDown.appearance().selectionBackgroundColor = .lightGray
        DropDown.appearance().cellHeight = 38
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0, green: 0/255, blue: 0/255, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        application.statusBarStyle = .lightContent
        
        // Override point for customization after application launch.
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    func registerForPushNotification(_ application:UIApplication){
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {(_, _)  in})
            UNUserNotificationCenter.current().delegate = self
            
        } else {
            let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        InstanceID.instanceID().instanceID(handler: { (instanceIdResult, error) in
            
            if let token = instanceIdResult?.token{
                if UserDefaults.standard.getFcmtoken() != token{
                    UserDefaults.standard.saveFcmtoken(token)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FirebaseInstanceIDRefreshedNotification"), object: nil)
        })
    }
    
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
//        let userInfo = notification.request.content.userInfo
        completionHandler([.alert, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        handleRedirection(userInfo: userInfo)
        completionHandler()
    }
}

