//
//  AppDelegate.swift
//  bahisadam
//
//  Created by ilker özcan on 19/07/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import BahisadamLive
import UserNotifications
import Dispatch
import Firebase

import Fabric
import Crashlytics

@UIApplicationMain
class BA_AppDelegate: UIResponder, UIApplicationDelegate, FIRMessagingDelegate {

	var window: UIWindow?
	public static var BA_temporaryDeviceToken: String = ""
	public static var Ba_LoginData: BA_Login?
    
    var remoteConfig: FIRRemoteConfig?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		IO_NetworkHelper.deviceIsConnectedToInternet { (status) in
		
			if(!status) {
				
				let alertMessage = IO_Helpers.getErrorMessageFromCode(9002)
				let alertview = UIAlertView(title: alertMessage.0, message: alertMessage.1, delegate: nil, cancelButtonTitle: alertMessage.2)
				alertview.show()
			}
		}
		Fabric.with([Crashlytics.self])
		let _ = BA_Database(databaseName: IO_Helpers.getSettingValue("databaseName"), databaseResourceName: IO_Helpers.getSettingValue("databaseResourcesName"))
		
		if #available(iOS 10.0, *) {
			
			UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { (granted, error) in
				// Do something here
			}
			application.registerForRemoteNotifications()
            
            FIRMessaging.messaging().remoteMessageDelegate = self
			
		}else{
			
			self.registerForPushes()
		}
        
        FIRApp.configure()
        
        remoteConfig = FIRRemoteConfig.remoteConfig()
        let remoteConfigSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
        remoteConfig?.configSettings = remoteConfigSettings!
        remoteConfig?.setDefaultsFromPlistFileName("RemoteConfigDefaults")
        
        remoteConfig?.fetch { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig?.activateFetched()
                
                print("value = \(self.remoteConfig?["is_ios_logo_enabled"].boolValue)")
                
            } else {
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
        }
		
        Fabric.with([Crashlytics.self])
        
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
		
		DispatchQueue.main.async {
			
			BA_Socket.sharedInstance.Disconnect()
		}
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		
		DispatchQueue.main.async {
			
			BA_Socket.sharedInstance.Connect()
            self.connectToFcm()
		}
	}
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                
            }
        }
    }

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
		
		if let urlHost = url.host {
			
			if(urlHost == "openLiveTab") {
				
				NotificationCenter.default.post(name: BA_AppConstants.OpenRootVCNotification, object: nil, userInfo: ["selectedTab": 2])
				
			}else if(urlHost == "openMatchDetail") {
				
				let matchYear = Int(url.pathComponents[1])
				let matchId = url.pathComponents[2]
				
				NotificationCenter.default.post(name: BA_AppConstants.OpenWebVCNotification, object: nil, userInfo: ["matchYear": matchYear ?? 2017, "matchId": matchId])
			}
		}
		
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		let deviceTokenTrimmed = deviceTokenString.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
		let deviceTokenReplaced = deviceTokenTrimmed.replacingOccurrences(of: " ", with: "")
			
		#if DEBUG
			print("Device token string: \(deviceTokenString) \n trimmed: \(deviceTokenTrimmed) \n replaced \(deviceTokenReplaced)\n")
		#endif
		
		if(!BA_AppConstants.isDeviceRegistered) {
			
			BA_AppDelegate.BA_temporaryDeviceToken = deviceTokenReplaced
		}else{
			
			BA_AppDelegate.Ba_LoginData = BA_Login()
		}
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/SkorAdam")
	}
	
	func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
		//register to receive notifications
		application.registerForRemoteNotifications()
	}
	
	func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
		// Tells the app delegate to perform the custom action specified by a push notification.
		if(identifier == "declineAction")
		{
			// pass
		}else if(identifier == "answerAction") {
			
			// pass
		}
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		// Sent to the delegate when Apple Push Service cannot successfully complete the registration process.
		print("Failed to get token, error: \(error.localizedDescription)")
		
		if(!BA_AppConstants.isDeviceRegistered) {
			
			BA_AppDelegate.BA_temporaryDeviceToken = ""
		}else{
			
			BA_AppDelegate.Ba_LoginData = BA_Login()
		}
	}
	
	internal func registerForPushes() {
			
		// register device for apple remote push notification service
		let userNotificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.badge, UIUserNotificationType.alert], categories: nil)
		UIApplication.shared.registerUserNotificationSettings(userNotificationSettings)
	}
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        handlePush(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handlePush(userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func handlePush(userInfo: [AnyHashable:Any]) {
        if UIApplication.shared.applicationState != .active, let matchId = userInfo["match_id"] as? String {
            NotificationCenter.default.post(name: BA_AppConstants.OpenMatchNotification, object: nil, userInfo: ["matchId": matchId, "type": userInfo["type"] as Any])
        }
    }
}

@available(iOS 10, *)
extension BA_AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        handlePush(userInfo: userInfo)
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handlePush(userInfo: userInfo)
        print(userInfo)
        
        completionHandler()
    }
}

