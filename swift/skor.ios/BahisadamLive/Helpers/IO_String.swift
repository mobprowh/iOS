//
//  IO_String.swift
//  ioshelpers
//
//  Created by ilker özcan on 23/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

#if os(iOS)
import CommonCryptoiOS
#elseif os(tvOS)
import CommonCryptoTVOS
#endif

/// String extension
extension String {
	
	/// Check string is e-mail
	public func IO_isEmail() -> Bool {
		let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
		return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
	}
	
	/// md5 and trim extension for string
	public func IO_md5() -> String! {
		
		let str = self.cString(using: String.Encoding.utf8)
		let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
		
		let digestLen = Int(CC_MD5_DIGEST_LENGTH)
		let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
		
		CC_MD5(str!, strLen, result)
		
		let hash = NSMutableString()
		for i in 0..<digestLen {
			hash.appendFormat("%02x", result[i])
		}
		
		result.deinitialize()
		
		return String(format: hash as String)
	}
	
	/// Trim whitespace from string
	public func IO_condenseWhitespace() -> String {
		let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.characters.isEmpty})
		
		return components.joined(separator: "")
	}
}
