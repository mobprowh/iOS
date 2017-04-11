//
//  IO_Common.swift
//  IO Helpers
//
//  Created by ilker özcan on 28/08/15.
//  Copyright (c) 2015 ilkerozcan. All rights reserved.
//
//

import Foundation

#if os(iOS)
import UIKit
#endif

#if os(iOS)
private let Device = UIDevice.current
private let iosVersion = NSString(string: Device.systemVersion).doubleValue
#elseif os(tvOS)
private let Device = UIDevice.current
private let tvosVersion = NSString(string: Device.systemVersion).doubleValue
#endif
private let AppBundle = Bundle.main

/// Helpers class
public class IO_Helpers: NSObject {
	
	/// Return bundle id
	public static let bundleID = AppBundle.bundleIdentifier!
	
#if os(iOS)
	/// Is iOS 10
	public static let iOS10 = iosVersion >= 10
	/// Is iOS 9
	public static let iOS9 = iosVersion >= 9 && iosVersion < 10
	/// Is iOS 8
	public static let iOS8 = iosVersion >= 8 && iosVersion < 9
	/// Is iOS 7
	public static let iOS7 = iosVersion >= 7 && iosVersion < 8
	
	/// Returns device uuid
	public static let deviceUUID = Device.identifierForVendor!.uuidString
#elseif os(tvOS)
	/// Is tvOS 10
	public static let tvOS10 = tvosVersion >= 10
	/// Is tvOS 9
	public static let tvOS9 = tvosVersion >= 9 && tvosVersion < 10
#endif
	
	/// Returns application name
	public static let applicationName = AppBundle.infoDictionary!["CFBundleName"] as! String
	
	/// Returns application version
	public static let applicationVersion = (AppBundle.infoDictionary!["CFBundleShortVersionString"] as! String) + " (" + (AppBundle.infoDictionary!["CFBundleVersion"] as! String) + ")"
	
#if os(iOS)
	/// Returns device name
	public static let deviceName = Device.name
	/// Returns device model
	public static let devicModel = Device.model
	/// Returns device version
	public static let deviceVersion = "\(iosVersion)"
	/// Returns device os
	public static let deviceOS = "iOS"
#elseif os(tvOS)
	/// Returns device name
	public static let deviceName = Device.name
	/// Returns device model
	public static let devicModel = Device.model
	/// Returns device version
	public static let deviceVersion = "\(tvosVersion)"
	/// Returns device os
	public static let deviceOS = "tvOS"
#endif
	
	public static let preferedLanguage = Locale.preferredLanguages.first
	public static let deviceLocale = Locale.current.languageCode
	
	/// Get error message (title, message, cancel button title)
	public static func getErrorMessageFromCode(_ errorCode : Int, bundle: Bundle? = nil) -> (String?, String?, String?) {
		
		let selectedBundle = (bundle != nil) ? bundle! : AppBundle
		
		if let helpersBundle = selectedBundle.path(forResource: "IO_IOS_Helpers", ofType: "bundle") {
			if let helperResourcesBundle = Bundle(path: helpersBundle) {
			
				if let errorCodesPath = helperResourcesBundle.path(forResource: "ErrorMessages", ofType: "plist") {
				
					let dictionary = NSDictionary(contentsOfFile: errorCodesPath)
					let errorData: NSDictionary	= dictionary?.object(forKey: String(errorCode)) as! NSDictionary
					return (errorData.object(forKey: "title") as? String, errorData.object(forKey: "message") as? String, errorData.object(forKey: "cancelButtonTitle") as? String);
				}else{
					NSLog("\n-------------\nWarning!\n-------------\nPlist ErrorMessages could not exists in the IO_IOS_Helpers bundle!\n")
					abort()
				}
			}else{
				NSLog("\n-------------\nWarning!\n-------------\nBundle IO_IOS_Helpers could not exists!\n")
				abort()
			}
		}else{
			NSLog("\n-------------\nWarning!\n-------------\nBundle IO_IOS_Helpers could not exists!\n")
			abort()
		}
	}
	
	/// Return media cache directory
	public static var getMediaCacheDirectory : String? {
		
		get {
			
			let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
			
			if paths.count > 0 {
				
				let cacheDirectory = paths[0]
				
				let CacheDirectoryName = IO_Helpers.getSettingValue("cacheDirectoryName")
				let mediaCachePath = NSString(string: cacheDirectory).appendingPathComponent(CacheDirectoryName)
				
				if(!FileManager.default.fileExists(atPath: mediaCachePath)) {
					
					do {
						try FileManager.default.createDirectory(atPath: mediaCachePath, withIntermediateDirectories: true, attributes: nil)
					} catch _ {
					}
				}
				
				return mediaCachePath as String
			}else{
				return nil
			}
		}
	}
	
	/// Return media cache directory
	public static var getDownloadsDirectory : String? {
		
		get {
			
			let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
			
			if paths.count > 0 {
				
				let downloadDirectory = paths[0]
				
				let DownloadDirectoryName = IO_Helpers.getSettingValue("downloadDirectoryName")
				let downloadDirPath = NSString(string: downloadDirectory).appendingPathComponent(DownloadDirectoryName)
				
				if(!FileManager.default.fileExists(atPath: downloadDirPath)) {
					
					do {
						try FileManager.default.createDirectory(atPath: downloadDirPath, withIntermediateDirectories: true, attributes: nil)
					} catch _ {
					}
				}
				
				return downloadDirPath as String
			}else{
				return nil
			}
		}
	}
	
#if os(iOS)
	/// Get screen resolution (CGFloat, CGFloat)
	public static func getResolution() -> (CGFloat, CGFloat) {
		
		return (UIScreen.main.bounds.width, UIScreen.main.bounds.height);
	}
#endif
	
	/// gerate random alphanumeric string
	public static func generateRandomAlphanumeric(_ characterCount: Int) -> String {
		
		let characterSet	= "123456789abcdefghijkmnpqrstuvyz"
		var randomString	= ""
		
		for _ in 0..<characterCount {
			
			let randomNumber = IO_Helpers.randomInt(0, max: characterSet.characters.count - 1)
			let endIdx = randomNumber + 1
			let _startIdx = characterSet.characters.index(characterSet.startIndex, offsetBy: randomNumber)
			let _endIdx = characterSet.characters.index(characterSet.startIndex, offsetBy: endIdx)
			let rangeString = Range<String.Index>(_startIdx..<_endIdx)
			let selectedCharacter = characterSet.substring(with: rangeString)
			randomString	+= selectedCharacter
		}
		
		return randomString
	}
	
	/// Generate random integer
	public static func randomInt(_ min: Int, max:Int) -> Int {
		var min = min, max = max
        
        if(max < min)
        {
            // swap
            let temp = min
            min = max
            max = temp
        }
        else if(max == min)
        {
            return min 
        }
        
        let diff = abs(max - min)
        
		return min + Int(arc4random_uniform(UInt32(diff)))
	}
	
	/// Convert radians to degrees for location
	public static func mathDegrees(_ radians : Double) -> Double {
		return (radians * (180.0 / Double(M_PI)))
	}
	
	/// Convert degrees to radians for location
	public func mathRadians(_ degrees : Double) ->Double {
		return (degrees / (180.0 * Double(M_PI)))
	}
	
	/// Convert miles to kilometers
	public func convertMilesToKilemoters(_ miles: Double) -> Double {
		return miles * 1.60934
	}
	
	/// Get setting value from Settings.plist
	public static func getSettingValue(_ settingKey: String, bundle: Bundle? = nil) -> String {
		
		let selectedBundle = (bundle != nil) ? bundle! : AppBundle
		
		if let helpersBundle = selectedBundle.path(forResource: "IO_IOS_Helpers", ofType: "bundle") {
			
			if let helperResourcesBundle = Bundle(path: helpersBundle) {
			
				if let plistPath = helperResourcesBundle.path(forResource: "Settings", ofType: "plist") {
				
					let dictionary = NSDictionary(contentsOfFile: plistPath)
					let settingValue: String = dictionary?.object(forKey: settingKey) as! String
					return settingValue
				}else{
					NSLog("\n-------------\nWarning!\n-------------\nPlist ErrorMessages could not exists in the IO_IOS_Helpers bundle!\n")
					abort()
				}
			}else{
				NSLog("\n-------------\nWarning!\n-------------\nBundle IO_IOS_Helpers could not exists!\n")
				abort()
			}
		}else{
			NSLog("\n-------------\nWarning!\n-------------\nBundle IO_IOS_Helpers could not exists!\n")
			abort()
		}
	}
	
	public static func getTimeAgoString(dateDiff: Int) -> Dictionary<String, Int> {
		
		var retval = Dictionary<String, Int>()
		
		if(dateDiff > 59) {
			
			let elapsedMinutes = Int(dateDiff) / 60
			
			if(elapsedMinutes > 59) {
				
				let elapsedHours	= Int(elapsedMinutes) / 60
				
				if(elapsedHours > 24) {
					
					let elapsedDays = Int(elapsedHours) / 24
					retval["days"] = elapsedDays
					retval["hours"] = Int(elapsedDays) % 24
					retval["minutes"] = Int(retval["hours"]!) % 60
					retval["seconds"] = 0
				}else{
					retval["days"] = 0
					retval["hours"] = elapsedHours
					retval["minutes"] = Int(elapsedMinutes) % 60
					retval["seconds"] = Int(dateDiff) % 60
				}
			}else{
				retval["days"] = 0
				retval["hours"] = 0
				retval["minutes"] = elapsedMinutes
				retval["seconds"] = Int(dateDiff) % 60
			}
			
		}else{
			retval["days"] = 0
			retval["hours"] = 0
			retval["minutes"] = 0
			retval["seconds"] = dateDiff
		}
		
		return retval
	}
}

