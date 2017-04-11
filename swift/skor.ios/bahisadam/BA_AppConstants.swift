//
//  BA_AppConstants.swift
//  bahisadam
//
//  Created by ilker özcan on 10/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

struct BA_AppConstants {
	
	static let OpenRootVCNotification = NSNotification.Name(rawValue: "com.bahisadam.notifications.openRootVC")
	static let OpenWebVCNotification = NSNotification.Name(rawValue: "com.bahisadam.notifications.openWebVC")
    static let OpenMatchNotification = NSNotification.Name(rawValue: "com.bahisadam.notifications.openMatch")
	
	static var isDeviceRegistered: Bool {
		
		get {
			
			return UserDefaults.standard.bool(forKey: "com.bahisadam.register.isDeviceRegistered")
		}
		
		set {
			
			UserDefaults.standard.set(newValue, forKey: "com.bahisadam.register.isDeviceRegistered")
		}
	}
	
	static var userName: String? {
		
		get {
			
			return UserDefaults.standard.string(forKey: "com.bahisadam.register.userName")
		}
		
		set {
			
			UserDefaults.standard.set(newValue, forKey: "com.bahisadam.register.userName")
		}
	}
	
	static var password: String? {
		
		get {
			
			return UserDefaults.standard.string(forKey: "com.bahisadam.register.password")
		}
		
		set {
			
			UserDefaults.standard.set(newValue, forKey: "com.bahisadam.register.password")
		}
	}
}
