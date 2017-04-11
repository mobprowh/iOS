//
//  RootViewController.swift
//  Fonts
//
//  Created by Kim Topley on 9/14/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {
    private var familyNames: [String]!
    private var cellPointSize: CGFloat!
    private var favoritesList: FavoritesList!
    private static let familyCell = "FamilyName"
    private static let favoritesCell = "Favorites"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        familyNames = (UIFont.familyNames() as [String]).sort()
        let preferredTableViewFont =
                UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cellPointSize = preferredTableViewFont.pointSize
        favoritesList = FavoritesList.sharedFavoritesList
        tableView.estimatedRowHeight = cellPointSize
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func fontForDisplay(atIndexPath indexPath: NSIndexPath) -> UIFont? {
        if indexPath.section == 0 {
            let familyName = familyNames[indexPath.row]
            let fontName = UIFont.fontNamesForFamilyName(familyName).first
            return fontName != nil ? UIFont(name: fontName!, size: cellPointSize) : nil
        } else {
            return nil
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return favoritesList.favorites.isEmpty ? 1 : 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return section == 0 ? familyNames.count : 1
    }
    
    override func tableView(tableView: UITableView,
                titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "All Font Families" : "My Favorite Fonts"
    }
    
    override func tableView(tableView: UITableView,
            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // The font names list
            let cell = tableView.dequeueReusableCellWithIdentifier(
                                    RootViewController.familyCell,
                                    forIndexPath: indexPath)
            cell.textLabel?.font = fontForDisplay(atIndexPath: indexPath)
            cell.textLabel?.text = familyNames[indexPath.row]
            cell.detailTextLabel?.text = familyNames[indexPath.row]
            return cell
        } else {
            // The favorites list
            return tableView.dequeueReusableCellWithIdentifier(
                                    RootViewController.favoritesCell,
                                    forIndexPath: indexPath)
        }
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        let listVC = segue.destinationViewController as! FontListViewController
        
        if indexPath.section == 0 {
            // Font names list
            let familyName = familyNames[indexPath.row]
            listVC.fontNames = (UIFont.fontNamesForFamilyName(familyName) as [String]).sort()
            listVC.navigationItem.title = familyName
            listVC.showsFavorites = false
        } else {
            // Favorites list
            listVC.fontNames = favoritesList.favorites
            listVC.navigationItem.title = "Favorites"
            listVC.showsFavorites = true
        }
    }
}
