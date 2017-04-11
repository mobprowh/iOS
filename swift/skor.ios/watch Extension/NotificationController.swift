//
//  NotificationController.swift
//  watch Extension
//
//  Created by ilker özcan on 10/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {

	@IBOutlet var notificationText: WKInterfaceLabel!
	@IBOutlet var homeTeamName: WKInterfaceLabel!
	@IBOutlet var awayTeamName: WKInterfaceLabel!
	@IBOutlet var homeTeamGoals: WKInterfaceLabel!
	@IBOutlet var awayTeamGoals: WKInterfaceLabel!
	
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
		
		self.notificationText.setText(notification.request.content.body)
		if let goalData = notification.request.content.userInfo["goalData"] as? [String: String] {
			
			self.homeTeamName.setText(goalData["homeTeamName"])
			self.awayTeamName.setText(goalData["awayTeamName"])
			self.homeTeamGoals.setText("\(goalData["homeTeamGoals"]!)")
			self.awayTeamGoals.setText("\(goalData["awayTeamGoals"]!)")
		}
		
        completionHandler(.custom)
    }
}
