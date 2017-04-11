//
//  ViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 19/07/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import WebKit
import BahisadamLive

class BA_WebViewController: UIViewController, WKNavigationDelegate {
	
	private var webView: WKWebView?
	private var pageLoaded = false
	private var lastBackItemIdx = -1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
	func loadWebview() {
		
		if(self.webView == nil) {
			
			webView = WKWebView()
			if #available(iOS 9.0, *) {
				webView?.customUserAgent = "bahisadam-ios/" + IO_Helpers.applicationVersion
			} else {
				// Fallback on earlier versions
			}
			webView?.navigationDelegate = self
			self.view = webView
			
			let nsUrl = URL(string: BA_Server.InitialWebviewUrl)
			var request: URLRequest!
			
			if #available(iOS 9.0, *) {
				
				request = URLRequest(url: nsUrl!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 90)
			}else{
				
				request = URLRequest(url: nsUrl!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 90)
				request.addValue("bahisadam-ios/" + IO_Helpers.applicationVersion, forHTTPHeaderField: "User-Agent")
			}
			request.addValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
			request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
			
			let _ = webView?.load(request)
			webView?.allowsBackForwardNavigationGestures = true
		}
	}
	
	func loadUrl(url: String) {
		
		if(self.view != nil) {
			self.view.alpha = 0
		}
		
		if(!self.pageLoaded) {
			
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150), execute: {
				
				self.loadUrl(url: url)
			})
		}else{
			
			self.webView?.evaluateJavaScript("window.showBlockUI();", completionHandler: { (response, error) in
				
				self.webView?.evaluateJavaScript("window.location.href = \"\(url)\"", completionHandler: { (response, error) in
					
					if(error != nil) {
						print("evaluateJavaScript \(error?.localizedDescription)")
					}else{
						
						if let backList = self.webView?.backForwardList.backList {
							
							self.lastBackItemIdx = backList.count
						}else{
							self.lastBackItemIdx = -1
						}
					}
					
				})
				
				DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
					
					if(self.view != nil) {
						self.view.alpha = 1
					}
				})
			})
		}
	}
	
	func setNavbarTitle(title: String) {
		
		if let tabBarVC = self.tabBarController {
			
			tabBarVC.navigationItem.title = title
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		pageLoaded = true
	}
	
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		
	}
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		
	}
	
	func goBack() -> Bool {
		
		if(self.webView!.canGoBack) {
			
			if let backItem = self.webView?.backForwardList.backItem {
				
				if let backItemIdx = self.webView?.backForwardList.backList.index(of: backItem) {
					
					if (backItemIdx != self.lastBackItemIdx) {
						
						let _ = self.webView?.goBack()
						return true
					}
				}
			}
			
			return false
		}else{
			return false
		}
	}
}
