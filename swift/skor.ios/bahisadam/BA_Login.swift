//
//  BA_Login.swift
//  bahisadam
//
//  Created by ilker özcan on 08/01/2017.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit
import BahisadamLive
import MBProgressHUD

protocol BA_LoginDelegate {
	
	func loginCanceled()
}

class BA_Login: NSObject, UIAlertViewDelegate {
	
	private enum ALERT_VIEW_TYPES: Int {
		
		case ASK = -1
		case REGISTER = 0
		case LOGIN = 1
		case REGISTER_STEP2 = 2
		case EXISTS = 3
		case ERROR = 4
	}
	private var currentAlertviewType: ALERT_VIEW_TYPES = .EXISTS
	
	private var isDeviceRegistered = false
	private var temporaryUserName: String?
	private var temporaryPassword: String?
	private var temporaryEmail: String?
	private var temporaryPasswordValidate: String?
	private var currentHud: MBProgressHUD?
	var loginDelegate: BA_LoginDelegate?
    var favorites: [String]?
	
	public var IsDeviceLogin: Bool {
	
		get {
			
			return self.isDeviceRegistered
		}
	}
	
	override init() {
		
		super.init()
		
		self.isDeviceRegistered = BA_AppConstants.isDeviceRegistered
		
		if(!self.isDeviceRegistered) {
			
			self.askLoginOrRegister()
		}else{
			sendDeviceDataToServer()
		}
	}
	
	init(withDelegate: BA_LoginDelegate) {
		
		super.init()
		
		self.loginDelegate = withDelegate
		self.isDeviceRegistered = BA_AppConstants.isDeviceRegistered
		
		if(!self.isDeviceRegistered) {
			
			self.askLoginOrRegister()
		}else{
			sendDeviceDataToServer()
		}
	}
	
	public func askLoginOrRegister() {
		
		currentAlertviewType = .ASK
		let alertView = UIAlertView(title: "SkorAdam", message: "Uygulamanın bütün özelliklerini kullanabilmek için giriş yapmanız veya kayıt olmanız gerekmektedir.", delegate: self, cancelButtonTitle: "İptal", otherButtonTitles: "SkorAdam Kaydol", "Giriş Yap")
		alertView.show()
	}
	
	public func sendDeviceDataToServer() {
		
		var postData = Dictionary<String, AnyObject>()
		
		var deviceInfo = Dictionary<String, AnyObject>()
		deviceInfo["deviceToken"] = BA_AppDelegate.BA_temporaryDeviceToken as AnyObject
		deviceInfo["bundleId"] = IO_Helpers.bundleID as AnyObject
		deviceInfo["appVersion"] = IO_Helpers.applicationVersion as AnyObject
		deviceInfo["deviceName"] = IO_Helpers.deviceName as AnyObject
		deviceInfo["devicModel"] = IO_Helpers.devicModel as AnyObject
		deviceInfo["deviceVersion"] = IO_Helpers.deviceVersion as AnyObject
		deviceInfo["deviceOS"] = IO_Helpers.deviceOS as AnyObject
		deviceInfo["deviceId"] = IO_Helpers.deviceUUID as AnyObject
		
		postData["deviceInfo"] = deviceInfo as AnyObject
		
		if(currentAlertviewType == .LOGIN) {
			
			postData["username"] = self.temporaryUserName as AnyObject
			postData["password"] = self.temporaryPassword as AnyObject
			
			if let window = UIApplication.shared.keyWindow {
				
				let lastView = window.subviews.last
				currentHud = MBProgressHUD.showAdded(to: lastView, animated: true)
				currentHud?.show(true)
			}
				
			IO_NetworkHelper(postJSONRequest: BA_Server.AuthLogin, postData: postData) { (status, data, error, responseCode) in
				
				#if DEBUG
					print("AuthLogin status \(status) \(responseCode)")
				#endif
				
				if(!status) {
					
					self.currentHud?.hide(true)
					let alertView: UIAlertView
					if(error != nil) {
						
						alertView = UIAlertView(title: "HATA!", message: error, delegate: nil, cancelButtonTitle: "Tamam")
						
					}else{
						
						alertView = UIAlertView(title: "HATA!", message: "Bir hata oluştu lütfen daha sonra tekrar deneyiniz.", delegate: nil, cancelButtonTitle: "Tamam")
					}
					alertView.show()
				}else{
					
					if let responseData = data as? [String : AnyObject] {
						
						let statusCode = responseData["isSuccess"] as? Bool ?? false
						let errorMessage = responseData["error"] as? String ?? ""
						
						if(!statusCode) {
							
							self.currentHud?.hide(true)
							self.currentAlertviewType = .ERROR
							let alertView = UIAlertView(title: "HATA!", message: errorMessage, delegate: self, cancelButtonTitle: "Tamam")
							alertView.show()
						}else{
							
							BA_AppConstants.isDeviceRegistered = true
							BA_AppConstants.userName = self.temporaryUserName
							BA_AppConstants.password = self.temporaryPassword
							self.isDeviceRegistered = true
							UserDefaults.standard.synchronize()
							self.deviceLogin(deviceToken: BA_AppDelegate.BA_temporaryDeviceToken)
						}
					}
				}
				
			}
			
		}else if(currentAlertviewType == .REGISTER || currentAlertviewType == .REGISTER_STEP2) {
			
			postData["username"] = self.temporaryUserName as AnyObject
			postData["password"] = self.temporaryPassword as AnyObject
			postData["email"] = self.temporaryEmail as AnyObject
			
			if let window = UIApplication.shared.keyWindow {
				
				let lastView = window.subviews.last
				currentHud = MBProgressHUD.showAdded(to: lastView, animated: true)
				currentHud?.show(true)
			}
			
			IO_NetworkHelper(postJSONRequest: BA_Server.AuthRegister, postData: postData) { (status, data, error, responseCode) in
				
				#if DEBUG
					print("AuthRegister status \(status) \(responseCode)")
				#endif
				
				if(!status) {
					
					self.currentHud?.hide(true)
					let alertView: UIAlertView
					if(error != nil) {
						
						alertView = UIAlertView(title: "HATA!", message: error, delegate: nil, cancelButtonTitle: "Tamam")
						
					}else{
						
						alertView = UIAlertView(title: "HATA!", message: "Bir hata oluştu lütfen daha sonra tekrar deneyiniz.", delegate: nil, cancelButtonTitle: "Tamam")
					}
					alertView.show()
				}else{
					
					if let responseData = data as? [String : AnyObject] {
						
						let statusCode = responseData["isSuccess"] as? Bool ?? false
						let errorMessage = responseData["error"] as? String ?? ""
						
						if(!statusCode) {
							
							self.currentHud?.hide(true)
							self.currentAlertviewType = .ERROR
							let alertView = UIAlertView(title: "HATA!", message: errorMessage, delegate: self, cancelButtonTitle: "Tamam")
							alertView.show()
						}else{
							
							BA_AppConstants.isDeviceRegistered = true
							BA_AppConstants.userName = self.temporaryUserName
							BA_AppConstants.password = self.temporaryPassword
							self.isDeviceRegistered = true
							UserDefaults.standard.synchronize()
							self.deviceLogin(deviceToken: BA_AppDelegate.BA_temporaryDeviceToken)
						}
					}
				}
			}
			
		}else{
			
			deviceLogin(deviceToken: BA_AppDelegate.BA_temporaryDeviceToken)
		}
	}
	
	func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
		
		if(currentAlertviewType == .ASK) {
			
			if(buttonIndex == 0) {
				
				guard self.loginDelegate != nil else {
					return
				}
				self.loginDelegate?.loginCanceled()
				return
				
			}else if(buttonIndex == 1) {
				
				currentAlertviewType = .REGISTER
				let inputAlertView = UIAlertView(title: "SkorAdam Üyelik", message: "", delegate: self, cancelButtonTitle: "İptal", otherButtonTitles: "Kaydet")
				inputAlertView.alertViewStyle = UIAlertViewStyle.loginAndPasswordInput
				
				inputAlertView.textField(at: 0)?.placeholder = "Kullanıcı Adı"
				inputAlertView.textField(at: 1)?.placeholder = "Şifre"
				
				inputAlertView.show()
			}else if(buttonIndex == 2) {
				
				currentAlertviewType = .LOGIN
				let inputAlertView = UIAlertView(title: "SkorAdam Giriş", message: "", delegate: self, cancelButtonTitle: "İptal", otherButtonTitles: "Kaydet")
				inputAlertView.alertViewStyle = UIAlertViewStyle.loginAndPasswordInput
				inputAlertView.show()
			}
		} else if(currentAlertviewType == .LOGIN) {
			
			if(buttonIndex == 0) {
				
				guard self.loginDelegate != nil else {
					return
				}
				self.loginDelegate?.loginCanceled()
				return
			}else{
			
				self.temporaryUserName = alertView.textField(at: 0)?.text
				self.temporaryPassword = alertView.textField(at: 1)?.text
				
				if(temporaryUserName == nil || temporaryPassword == nil) {
					
					currentAlertviewType = .ERROR
					let errorAlertView = UIAlertView(title: "HATA!", message: "Kullanıcı adı veya şifre boş olamaz", delegate: self, cancelButtonTitle: "Tamam")
					errorAlertView.show()
					return
				}
				
				if(temporaryUserName!.characters.count < 2 || temporaryPassword!.characters.count < 2) {
					
					currentAlertviewType = .ERROR
					let errorAlertView = UIAlertView(title: "HATA!", message: "Kullanıcı adı veya şifre çok kısa", delegate: self, cancelButtonTitle: "Tamam")
					errorAlertView.show()
					return
				}
				
				sendDeviceDataToServer()
			}
			
		}else if(currentAlertviewType == .REGISTER) {
			
			if(buttonIndex == 0) {
				
				guard self.loginDelegate != nil else {
					return
				}
				self.loginDelegate?.loginCanceled()
				return
			}else{
				self.temporaryUserName = alertView.textField(at: 0)?.text
				self.temporaryPassword = alertView.textField(at: 1)?.text
				
				if(temporaryUserName == nil || temporaryPassword == nil) {
					
					currentAlertviewType = .ERROR
					let errorAlertView = UIAlertView(title: "HATA!", message: "Kullanıcı adı veya şifre boş olamaz", delegate: self, cancelButtonTitle: "Tamam")
					errorAlertView.show()
					return
				}
				
				if(temporaryUserName!.characters.count < 2 || temporaryPassword!.characters.count < 2) {
					
					currentAlertviewType = .ERROR
					let errorAlertView = UIAlertView(title: "HATA!", message: "Kullanıcı adı veya şifre çok kısa", delegate: self, cancelButtonTitle: "Tamam")
					errorAlertView.show()
					return
				}
				
				currentAlertviewType = .REGISTER_STEP2
				let inputAlertView = UIAlertView(title: "SkorAdam Üyelik", message: "", delegate: self, cancelButtonTitle: "Kaydet")
				inputAlertView.alertViewStyle = UIAlertViewStyle.loginAndPasswordInput
				inputAlertView.textField(at: 0)?.placeholder = "E-Mail Adresiniz"
				inputAlertView.textField(at: 1)?.placeholder = "Şifre (tekrar)"
				
				inputAlertView.show()
			}
			
		}else if(currentAlertviewType == .REGISTER_STEP2) {
			
			self.temporaryEmail = alertView.textField(at: 0)?.text
			self.temporaryPasswordValidate = alertView.textField(at: 1)?.text
			
			if(temporaryEmail == nil) {
				
				currentAlertviewType = .ERROR
				let errorAlertView = UIAlertView(title: "HATA!", message: "E-Posta adresi boş olamaz", delegate: self, cancelButtonTitle: "Tamam")
				errorAlertView.show()
				return
			}
			
			if(temporaryEmail!.characters.count < 6) {
				
				currentAlertviewType = .ERROR
				let errorAlertView = UIAlertView(title: "HATA!", message: "Geçersiz E-Posta adresi", delegate: self, cancelButtonTitle: "Tamam")
				errorAlertView.show()
				return
			}
			
			if(temporaryPasswordValidate! != temporaryPassword!) {
				
				currentAlertviewType = .ERROR
				let errorAlertView = UIAlertView(title: "HATA!", message: "Şifre ve şifre (tekrar) alanları birbirini tutmuyor.", delegate: self, cancelButtonTitle: "Tamam")
				errorAlertView.show()
				return
			}
			
			sendDeviceDataToServer()
			
		}else if(currentAlertviewType == .ERROR) {
			
			currentAlertviewType = .ASK
			askLoginOrRegister()
		}
	}
	
	private func deviceLogin(deviceToken: String) {
		
		var postData = Dictionary<String, AnyObject>()
		postData["deviceId"] = IO_Helpers.deviceUUID as AnyObject
		postData["deviceToken"] = deviceToken as AnyObject
		
		IO_NetworkHelper(postJSONRequest: BA_Server.DeviceLogin, postData: postData) { (status, data, error, responseCode) in
			
            self.favorites = data?["favorites"] as? [String]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserStateChanged"), object: nil)
            
			#if DEBUG
				print("DeviceLogin status \(status) \(responseCode)")
			#endif
			self.currentHud?.hide(true)
		}
	}
}
