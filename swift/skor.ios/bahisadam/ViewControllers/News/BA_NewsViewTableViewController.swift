//
//  BA_NewsViewTableViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 11/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import MBProgressHUD
import BahisadamLive
import SafariServices

class BA_NewsViewTableViewController: UITableViewController, XMLParserDelegate {

	fileprivate let newsApiUrl = "http://www.ntv.com.tr/spor.rss"
	
	private var firstDataLoaded = false
	private var progmaticallyRefresh = false
	private var isFirstLoad = true
	private var currentRowCount = 0
	private var newsData = [BA_NewsData]()
	
	private var currentElement: Dictionary<String, String>?
	
    override func viewDidLoad() {
		
		self.isFirstLoad = true
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
		
		self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
		
		if(isFirstLoad) {
			
			isFirstLoad = false
		}else{
			
			self.progmaticallyRefresh = true
			self.tableView?.setContentOffset(CGPoint(x: 0, y: (-1 * (self.refreshControl?.frame.size.height)!)), animated: true)
			self.refreshControl?.beginRefreshing()
			self.handleRefresh(refreshControl: nil)
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		return self.currentRowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "ba_news_tableview_cell", for: indexPath) as? BA_NewsTableViewCell {
			
			// Configure the cell...
			cell.configureCell(newsData: self.newsData[indexPath.row])
			return cell
		}

		return UITableViewCell()
    }

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return self.newsData[indexPath.row].calculateStringHeight(width: tableView.bounds.size.width)
	}

    // Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		print("editingStyle \(editingStyle.rawValue)")
		/*
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        } 
		*/
    }
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let btnDetail = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Detay", handler: { (UITableViewRowAction, IndexPath) -> Void in
			
			if let requestUrl = URL(string: self.newsData[indexPath.row].link) {
				
				if #available(iOS 9.0, *) {
				
				
					let safari = SFSafariViewController(url: requestUrl)
					self.present(safari, animated: true, completion: nil)
				
				}else{
					UIApplication.shared.openURL(requestUrl)
				}
			}
		})
		
		return [btnDetail]
	}

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	public func handleRefresh(refreshControl: UIRefreshControl?) {
		
		self.loadData(withoutHud: true)
	}
	
	private func loadData(withoutHud noHud: Bool = false) {
		
		if(!noHud) {
			
			MBProgressHUD.showAdded(to: self.view, animated: false)
		}
		
		IO_NetworkHelper(getAnyRequest: self.newsApiUrl, accept: "application/rss+xml", completitionHandler: { (status, data, error, statusCode) in
		
			if(status) {
				
				if let dataVal = data as? Data {
					
					let xmlParser = XMLParser(data: dataVal)
					xmlParser.delegate = self
					xmlParser.parse()
				}
				
				if(self.progmaticallyRefresh) {
					
					self.refreshControl?.endRefreshing()
				}
			}
			
			if(!noHud) {
				MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
			}else{
				self.refreshControl?.endRefreshing()
			}
		})
	}

	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
		
		if(elementName == "entry") {
			
			currentElement = Dictionary<String, String>()
			currentElement!["currentParse"] = elementName
		
		}else if(currentElement != nil) {
			
			currentElement!["currentParse"] = elementName
			
			if(elementName == "link") {
				currentElement![elementName] = attributeDict["href"]
			}else{
				currentElement![elementName] = ""
			}
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		
		guard currentElement != nil else {
			
			return
		}
		
		let currentParse = (currentElement!["currentParse"])!
		currentElement![currentParse] = "\((currentElement![currentParse])!)\(string)"
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		
		guard currentElement != nil else {
			
			return
		}
		
		if(elementName == "entry") {
		
			let index = self.newsData.index { (data) -> Bool in
				
				if(data.id == currentElement!["id"]) {
					return true
				}
				
				return false
			}
			
			if(index == nil) {
				
				let newsData = BA_NewsData(id: (currentElement!["id"])!, title: (currentElement!["title"])!, summary: (currentElement!["summary"])!, updateDate: (currentElement!["published"])!, link: (currentElement!["link"])!)
				self.newsData.append(newsData)
			}
			
			currentElement = nil
		}
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		
		if currentRowCount == 0 {
			
			self.currentRowCount = newsData.count
			self.tableView.reloadData()
			
			for i in 0..<self.currentRowCount {
				
				self.newsData[i].isNew = false
			}
			
		}else{
			
			let tmpNewsData = self.newsData.sorted(by: { (data1, data2) -> Bool in
				
				let data1TimeInterval: TimeInterval
				let data2TimeInterval: TimeInterval
				
				if let tmpData1TimeInterval = data1.updateDate?.timeIntervalSince1970 {
					
					data1TimeInterval = tmpData1TimeInterval
				}else{
					data1TimeInterval = 0
				}
				
				if let tmpData2TimeInterval = data2.updateDate?.timeIntervalSince1970 {
					
					data2TimeInterval = tmpData2TimeInterval
				}else{
					data2TimeInterval = 0
				}
				
				if(data1TimeInterval < data2TimeInterval) {
					
					return false
				}
				
				return true
			})
			
			self.newsData = tmpNewsData
			var currentIndexPath = [IndexPath]()
			
			for i in 0..<self.newsData.count {
				
				if(self.newsData[i].isNew) {
					
					self.currentRowCount += 1
					currentIndexPath.append(IndexPath(row: i, section: 0))
					self.newsData[i].isNew = false
				}
			}
			
			if(currentIndexPath.count > 0) {
				
				self.tableView.beginUpdates()
				self.tableView.insertRows(at: currentIndexPath, with: UITableViewRowAnimation.fade)
				self.tableView.endUpdates()
			}
		}
	}
}
