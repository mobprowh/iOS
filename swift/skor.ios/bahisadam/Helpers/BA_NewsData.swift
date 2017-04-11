//
//  BA_NewsData.swift
//  bahisadam
//
//  Created by ilker özcan on 11/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit

fileprivate let cellHeight: CGFloat = 60.0
fileprivate let fontSize: CGFloat = 10

struct BA_NewsData {
	
	let id: String
	let title: String
	let summary: String
	let updateDate: Date?
	let link: String
	
	private var _isNew = false
	private var _stringHeight: CGFloat = -1.0
	
	var isNew: Bool {
		
		get {
			return self._isNew
		}
		
		set {
			
			self._isNew = newValue
		}
	}
	
	var newsDate: String? {
		
		get {
			
			guard self.updateDate != nil else {
				
				return nil
			}
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd'.'MM'.'yyyy' 'HH':'mm"
			return dateFormatter.string(from: updateDate!)
		}
	}
	
	init(id: String, title: String, summary: String, updateDate: String, link: String) {
		
		self.id = id
		self.title = title
		self.summary = summary
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXXXX"
		//dateFormatter.timeZone = TimeZone(identifier: "UTC")
		
		self.updateDate = dateFormatter.date(from: updateDate)
		self.link = link
		
		_isNew = true
	}
	
	mutating func calculateStringHeight(width: CGFloat) -> CGFloat {
		
		if(self._stringHeight == -1.0) {
			
			let font = UIFont.systemFont(ofSize: fontSize)
			let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
			let boundingBox = self.summary.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
			self._stringHeight = (boundingBox.height + 10.0 + cellHeight)
		}
		
		return self._stringHeight
	}
}
