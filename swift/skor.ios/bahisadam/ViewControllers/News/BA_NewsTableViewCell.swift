//
//  BA_NewsTableViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 11/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_NewsTableViewCell: UITableViewCell {

	@IBOutlet var newsTitle: UILabel!
	@IBOutlet var newsContent: UILabel!
	@IBOutlet var newsDate: UILabel!
	
	var newsData: BA_NewsData!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func configureCell(newsData: BA_NewsData) {
		
		self.newsData = newsData
		
		self.newsTitle.text = self.newsData.title
		self.newsContent.text = self.newsData.summary
		
		if let currentNewsDate = self.newsData.newsDate {
			
			self.newsDate.text = currentNewsDate
		}else{
			self.newsDate.text = ""
		}
	}
}
