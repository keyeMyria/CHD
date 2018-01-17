//
//  AppDelegate.swift
//  tabView
//
//  Created by CenSoft on 27/11/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if !UserDefaults.standard.bool(forKey: "isLoggedInSkipped") {
            setupLoginNavigationController(application)
        } else {
            setupTabBarController()
        }
        ReachabilityManager.shared.startMonitoring()
        
        //Google Analytics
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
        }
        gai.tracker(withTrackingId: "UA-111629190-1") // UA-111629190-1  company Account    //UA-111609419-1 my account
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            // 2
            let aps = notification["aps"] as! [String: AnyObject]
            
            // 3
           // (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
        }

        return true
    }
    
    func setupLoginNavigationController(_ application: UIApplication) {
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        let navCtrl = UINavigationController()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let introScreen = IntroCollectionViewController(collectionViewLayout: layout)
        navCtrl.viewControllers = [introScreen]
        
    

        
        self.window?.rootViewController = navCtrl
        self.window?.makeKeyAndVisible()
        
    }
    
    func setupTabBarController() {
        let nav1 = UINavigationController()
        let first = FirstViewController(nibName: nil, bundle: nil)
        nav1.viewControllers = [first]
        
        let second = SecondViewController(nibName: nil, bundle: nil)
        let nav2 = UINavigationController()
        nav2.viewControllers = [second]
        
        let third = ThirdViewController(nibName: nil, bundle: nil)
        let nav3 = UINavigationController()
        nav3.viewControllers = [third]
        
        let icon1 = UITabBarItem(title: "Home", image: UIImage(named: "icons8-home.png"), selectedImage: UIImage(named: "icons8-home.png"))
        let icon2 = UITabBarItem(title: "News", image: UIImage(named: "icons8-news.png"), selectedImage: UIImage(named: "icons8-news.png"))
        let icon3 = UITabBarItem(title: "Notification", image: UIImage(named: "icons8-appointment_reminders.png"), selectedImage: UIImage(named: "icons8-appointment_reminders.png"))
        
        nav1.tabBarItem = icon1
        nav2.tabBarItem = icon2
        nav3.tabBarItem = icon3
        
        let tabs = UITabBarController()
        tabs.viewControllers = [nav1, nav2, nav3]
        
        self.window!.rootViewController = tabs;
        self.window?.makeKeyAndVisible();
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
    }

    

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        // println("Recived: \(userInfo)")
        //Parsing userinfo:
        //        var temp : NSDictionary = userInfo as NSDictionary
        //        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        //        {
        //            var alertMsg = info["alert"] as! String
        //            var alert: UIAlertView!
        //            alert = UIAlertView(title: "", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
        //            alert.show()
        //        }
        
        
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        let alertMsg = aps["alert"] as! String
        let urlLink = aps["link_url"] as! String
        
        
        let userDefaults = UserDefaults.standard
       // var arrayOfNotication = userDefaults.array(forKey: "notifications")
        //if arrayOfNotication == nil
       // {
           // arrayOfNotication = NSMutableArray.init() as! [NotificationItem];
//            let notification = NotificationItem.init(titleString: alertMsg, url_Link: urlLink)
//            arrayOfNotication?.append(notification);
      //  }else
       // {
        
         //   arrayOfNotication?.append(notification);
       // }
        
        //let notificationData = NSKeyedArchiver.archivedData(withRootObject: arrayOfNotication ?? "")
        
        userDefaults.set(alertMsg, forKey:"title")
        userDefaults.set(urlLink, forKey: "url")
        userDefaults.synchronize()
        (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        ReachabilityManager.shared.stopMonitoring()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ReachabilityManager.shared.startMonitoring()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

