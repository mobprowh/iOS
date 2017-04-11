//
//  BA_DateTime.swift
//  bahisadam
//
//  Created by ilker özcan on 21/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

private let dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z'"

public func BA_DateFormat(date: Date?) -> String? {
	
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = dateFormat
	dateFormatter.timeZone = TimeZone(identifier: "UTC")
	
	if(date == nil) {
		
		return dateFormatter.string(from: Date())
	}else{
		return dateFormatter.string(from: date!)
	}
}

public func BA_DateFormat(string: String) -> Date? {
	
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = dateFormat
	dateFormatter.timeZone = TimeZone(identifier: "UTC")
	
	return dateFormatter.date(from: string)
}

public func BA_getStartDate(date: Date?) -> Date {
	
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T03:00:00.000Z'"
	//dateFormatter.timeZone = TimeZone(identifier: "UTC")
	
	let dateStr: String
	if(date == nil) {
		dateStr = dateFormatter.string(from: Date())
	}else{
		dateStr = dateFormatter.string(from: date!)
	}
	
	let dateFormatter2 = DateFormatter()
	dateFormatter2.dateFormat = dateFormat
	let date = dateFormatter2.date(from: dateStr)
	return date!
}
