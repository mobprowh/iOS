//
//  IO_Json.swift
//  IO Helpers
//
//  Created by ilker özcan on 01/03/15.
//  Copyright (c) 2015 ilkerozcan. All rights reserved.
//

import Foundation

/// Json encoder/decoder
public struct IO_Json {
	
	/// Object to JSON string
	public static func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
		
		//var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
		let options: JSONSerialization.WritingOptions?  = (prettyPrinted) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
		
		if JSONSerialization.isValidJSONObject(value) {
			
			if let data = try? JSONSerialization.data(withJSONObject: value, options: options!) {
				
				return NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
			}
		}
		
		return ""
	}
	
	/// JSON to array
	public static func JSONParseArray(jsonString: String) -> [AnyObject] {
		
		if let data = jsonString.data(using: String.Encoding.utf8) {
			
			if let array = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))  as? [AnyObject] {
				return array
			}
		}
		return [AnyObject]()
	}
	
	/// JSON to object
	public static func JSONParseDictionary(jsonString: String) -> [String: AnyObject] {
		
		if let data = jsonString.data(using: String.Encoding.utf8) {
			
			if let dictionary = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))  as? [String: AnyObject] {
				
				return dictionary
			}
		}
		return [String: AnyObject]()
	}
}
