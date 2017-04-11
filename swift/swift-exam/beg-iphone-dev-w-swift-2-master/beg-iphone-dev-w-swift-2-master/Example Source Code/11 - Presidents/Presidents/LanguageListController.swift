//
//  LanguageListController.swift
//  Presidents
//
//  Created by Kim Topley on 10/16/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class LanguageListController: UITableViewController {
    weak var detailViewController: DetailViewController? = nil
    fileprivate let languageNames: [String] = ["English", "French", "German", "Spanish"]
    fileprivate let languageCodes: [String] = ["en", "fr", "de", "es"]
 
    override func viewDidLoad() {
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = false
        preferredContentSize = CGSize(width: 320, height: CGFloat(languageCodes.count * 44))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return languageCodes.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                for: indexPath)
    
        // Configure the cell...
        cell.textLabel!.text = languageNames[indexPath.row]
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
            didSelectRowAt indexPath: IndexPath) {
        detailViewController?.languageString = languageCodes[indexPath.row]
        dismiss(animated: true, completion: nil)
    }
}
