//
//  AppDelegate.swift
//  SportLook
//
//  Created by Terminator on 24/02/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        setupParse(application, didFinishLaunchingWithOptions: launchOptions)

        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary{
            //Received a push notification
            println("Push notification content:\n\(notification)\n")

            if isNotificationAnInvite(notification as [NSObject : AnyObject]){
                //Show Event Info
                if let eventId: String = notification["eventId"] as? String{
                    showEventInfo(eventId)
                } else{
                    //This means an 'eventId' was not sent
                }
            } else {
                //Show Chat
                if let eventId: String = notification["eventId"] as? String{
                    StructEventInfo.shouldPresentChat = true
                    showEventInfo(eventId)
                }
            }
        } else{
            //No push notification received
            handleFirstScreen()
        }

        self.window!.makeKeyAndVisible()
        setNavigationBarStyle()
        FBLoginView.self
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var wasHandled : Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        return wasHandled
    }
    
    func handleFirstScreen(){
        
        if shouldClearUserLoggedToken(){
            KeychainHandler.clearUserLoggedInfo()
        }
        
        if let userLoggedToken = KeychainHandler.getUserLoggedToken() as String? {
            //User logged in. There is a token saved
            
            //Show tabBarController
            let controller = SportLookTabBarController()
            self.window!.rootViewController = controller
        } else {
            //Show HomeScreen
            
            let controller = HomeViewController()
            var navController: UINavigationController = UINavigationController(rootViewController: controller)
            self.window!.rootViewController = navController
        }
    }
    
    func shouldClearUserLoggedToken() -> Bool {

        //NSUserDefaults gets cleared when the app is uninstalled
        //Keychain doesn't get cleared
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let alreadyRunOnce = defaults.boolForKey("alreadyRunOnce")
        if(!alreadyRunOnce)
        {
            defaults.setBool(true, forKey: "alreadyRunOnce")
            return true
        } else {
            return false
        }
    }
    
    func setNavigationBarStyle(){

        UINavigationBar.appearance().barTintColor = UIColor.COLOR_NAVBAR_BACKGROUND//background
        UINavigationBar.appearance().tintColor = UIColor.COLOR_NAVBAR_BACK_BUTTON//back button
//        UINavigationBar.appearance().shadowImage = //white line below nav bar
        
        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.COLOR_NAVBAR_TITLE, NSFontAttributeName: UIFont(name: UIFont.QUICKSAND_BOLD, size: 18)!]
        
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes//custom title
        
    }

    //MARK: Parse methods
    
    func setupParse(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?){
        
        Parse.setApplicationId("tGMCT7Mk9XmYTJihqxWI88AlPAAqBJAP7Ktkd3NX", clientKey: "3KOlQsDrF6cUMK1m19MAjeKtesFMc3tDK4dPf02f")
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        resetAppBadge()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        println("Push notification content:\n\(userInfo)\n")
        
        if application.applicationState == UIApplicationState.Active{
            //Application was foreground
            resetAppBadge()
            
            if isNotificationAnInvite(userInfo){
                //Show alert for the invite
                
                let alert = SCLAlertView()
                alert.addButton("Check it out", action: { () -> Void in
                    if let eventId: String = userInfo["eventId"] as? String{
                        self.showEventInfo(eventId)
                    } else{
                        println("didn't find any eventId")
                    }
                })
                let message = getMessageSentFromNotification(userInfo)
                alert.showInfo("Hey there!", subTitle: message, closeButtonTitle: "Ignore for now")
            } else{
                //Do nothing, because it would be bad user experience
            }
        } else{
            //Application was background
            
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            
            if isNotificationAnInvite(userInfo){

                //Show Event Info
                if let eventId: String = userInfo["eventId"] as? String{
                    showEventInfo(eventId)
            } else{
                //This means an 'eventId' was not sent
                }
            } else {
                //Show Chat
                if let eventId: String = userInfo["eventId"] as? String{
                    StructEventInfo.shouldPresentChat = true
                    showEventInfo(eventId)
                }
            }
        }
    }
    
    //MARK: Helper methods
    
    func showEventInfo(eventId: String){
        
        let tabController = SportLookTabBarController()
        tabController.selectedIndex = 1 //MyEvents screen
        StructMyEvents.shouldPushEvent = true
        StructMyEvents.eventToPush = eventId.toInt()!

        self.window!.rootViewController = tabController
    }
    
    func isNotificationAnInvite(userInfo: [NSObject : AnyObject]) -> Bool{
        
        if let isForInvite: Bool = userInfo["isForInvite"] as? Bool{
            if isForInvite {
                return true
            }
            return false
        }
        return false
    }
    
    func getMessageSentFromNotification(userInfo: [NSObject : AnyObject]) -> String{
        
        if let aps = userInfo["aps"] as? Dictionary<String, AnyObject> {
            if  let message = aps["alert"] as? String {
                return message
            }
        }
        return "You received an invite!"
    }
    
    func resetAppBadge(){
        let currentInstallation = PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0
            currentInstallation.saveInBackgroundWithBlock { (succeded, error) -> Void in
                if error != nil {
                    currentInstallation.saveEventually()
                }
            }
        }
    }
}

