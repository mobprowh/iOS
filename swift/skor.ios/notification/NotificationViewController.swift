//
//  NotificationViewController.swift
//  notification
//
//  Created by ilker özcan on 10/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var contentLabel: UILabel?
	@IBOutlet var homeTeamName: UILabel?
	@IBOutlet var awayTeamName: UILabel?
	@IBOutlet var goalsArea: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
		
		self.contentLabel?.text = notification.request.content.body
		if let goalData = notification.request.content.userInfo["goalData"] as? [String: String] {
		
			self.homeTeamName?.text = goalData["homeTeamName"]
			self.awayTeamName?.text = goalData["awayTeamName"]
			let scoreString = "\(goalData["homeTeamGoals"]!) - \(goalData["awayTeamGoals"]!)"
			self.goalsArea?.text = scoreString
		}
    }

}
