//
//  AppDelegate.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/13/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import UserNotifications
import AlamofireNetworkActivityLogger
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let HUBNAME = "Savior_Notification_Hub"
    let HUBLISTENACCESS = "Endpoint=sb://saviornotificationnamespace.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=F/woC8B08qNEiPLUQzNkfXHr+23ssPp7SWQZEG7Gpgk="

    var nav:UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor(hex:"#4FB7FF", alpha:1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.black
        
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()

        let mainVC:MainVC = MainVC(nibName: "MainVC", bundle: nil)
        self.nav = UINavigationController(rootViewController: mainVC)
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()

        IQKeyboardManager.sharedManager().enable = true

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        MSAppCenter.start("926c293f-9d13-4ede-b7b5-8a09ef620a44", withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        // realm
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        _ = try! Realm()


        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("REGISTER NOTIFICATION \(deviceToken)")
        
        let hub = SBNotificationHub(connectionString: HUBLISTENACCESS, notificationHubPath: HUBNAME)
        var set:Set<String> = []
        
        let realm = try! Realm()
        let items = realm.objects(RealmSavior.self)
        if items.count > 0 {
            for savior in items {
                set.insert(savior.savior_address!)
            }
        }
        print("REGISTER NOTIFICATION \(set)")

        
        //NSSet *set = [NSSet setWithArray:@[@"6001941A4BD7",@"6001941A4AD6"]];
        if set.count != 0 {
            hub!.registerNative(withDeviceToken: deviceToken, tags: set, completion: {(_ error: Error?) -> Void in
                if error != nil {
                    if let anError = error {
                        print("Error registering for notifications: \(anError)")
                    }
                }
                /*  else {
                 [self MessageBox:@"Registration Status" message:@"Registered"];
                 }*/
            })
        }

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error)
        
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {

        print("Recived: \(userInfo)")
        //Parsing userinfo:
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            /*
            var message = info["message"] as! String
            var alert: UIAlertView!
            alert = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            */
            var notification_id = info["id"] as! String
            
            let realm = try! Realm()
            let items = realm.objects(RealmSavior.self).filter("savior_address = '\(notification_id)'")
            if items.count > 0 {
                let savior = items.first!
                let detailVC:DetailVC = DetailVC(nibName: "DetailVC", bundle: nil)
                detailVC.savior = savior
                self.nav.pushViewController(detailVC, animated: true)
            }
        }
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
        NotificationCenter.default.post(name:NSNotification.Name(rawValue:"DeviceAddedEvent"),
                                        object: nil,
                                        userInfo: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

