//
//  IO_UIIMage.swift
//  bahisadam
//
//  Created by ilker özcan on 24/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit

public typealias IO_AsyncUIImage = (_ image: UIImage?) -> Void

extension UIImage {
	
	public func tintedWithLinearGradientColors(colorsArr: [CGColor?]) -> UIImage {
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		let context = UIGraphicsGetCurrentContext()
		context!.translateBy(x: 0, y: self.size.height)
		context!.scaleBy(x: 1.0, y: -1.0)
		
		context!.setBlendMode(CGBlendMode.normal)
		let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
		
		// Create gradient
		
		let colors = colorsArr as CFArray
		let space = CGColorSpaceCreateDeviceRGB()
		let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)
		
		// Apply gradient
		
		context!.clip(to: rect, mask: self.cgImage!)
		context!.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: self.size.height), options: CGGradientDrawingOptions(rawValue: UInt32(0)))
		let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return gradientImage!
	}
	
	public class func getWebImage(imageUrl: String, callback: IO_AsyncUIImage?) -> Void {
	
		if let cacheDirectory = IO_Helpers.getMediaCacheDirectory {
			
			let cacheName = imageUrl.IO_md5()
			let imageFilePath = cacheDirectory + "/\(cacheName!)" + ".cim"
			
			if(FileManager.default.fileExists(atPath: imageFilePath)) {
				
				let fileUrl = URL(fileURLWithPath: imageFilePath)
				let fileData = try? Data(contentsOf: fileUrl)
				let responseImage = UIImage(data: fileData!)
				DispatchQueue.main.async {
					
					if(callback != nil) {
						callback!(responseImage)
					}
				}
			}else{
				
				IO_NetworkHelper.init(downloadFile: imageUrl, displayError: false, completitionHandler: { (success, fileUrl, error, responseCode) in
					
					if(success && fileUrl != nil) {
						
						do {
							
							let fileData = try Data(contentsOf: fileUrl!)
							let responseImage = UIImage(data: fileData)
							responseImage?.storeToLocalCache(cacheName: cacheName!)
							
							DispatchQueue.main.async {
								
								if(callback != nil) {
									callback!(responseImage)
								}
							}
						} catch _ {
						}
					}
				})
				
			}
		}
	}
	
	public func storeToLocalCache(cacheName: String) {
		
		if let cacheDirectory = IO_Helpers.getMediaCacheDirectory {
			
			let imageFilePath = cacheDirectory + "/\(cacheName)" + ".cim"
			if(!FileManager.default.fileExists(atPath: imageFilePath)) {
					
				let imageFileUrl = URL(fileURLWithPath: imageFilePath)
				
				/*imageFileUrl.setResourceValues()
				URL.setResourceValues(&)
				var resourceValues = imageFileUrl.setResourceValues(&imageFileUrl!)!
				resourceValues.isExcludedFromBackup = true*/
					
				if let imageData = UIImagePNGRepresentation(self) {
					
					try? imageData.write(to: imageFileUrl, options: Data.WritingOptions.init(rawValue: 0))
				}
			}
		}
	}
	
	public class func deleteFromCache(imageUrl: String) {
	
		if let cacheDirectory = IO_Helpers.getMediaCacheDirectory {
			
			let cacheName = imageUrl.IO_md5()
			let imageFilePath = cacheDirectory + "/\(cacheName!)" + ".cim"
			try? FileManager.default.removeItem(atPath: imageFilePath)
		}
	}
}
