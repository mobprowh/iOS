//
//  PlayerTableViewCell.swift
//  bahisadam
//
//  Created by andrey on 3/18/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

protocol PlayerTableViewCellDelegate {
    
    func playerTableCellTapped(playerId: String)
    
}

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImg: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var teamImg: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var goals: UILabel!
    
    private var playerImgUrl:String!
    private var teamImgUrl:String!
    private var playerId:String!
    
    private var delegate: PlayerTableViewCellDelegate?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    
    func setupCell(playerData: BA_Players, delegate: PlayerTableViewCellDelegate) {
        
        
        self.playerImgUrl = playerData.playerImageUrl
        self.teamImgUrl = playerData.teamSheildUrl
        self.playerId = playerData.playerId
        
        self.playerName.text = playerData.name
        self.teamName.text = playerData.teamName
        self.goals.text = playerData.total
        
        self.delegate = delegate
        
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(cellTapGestureTapped(sender:)))
        self.contentView.addGestureRecognizer(self.tapGestureRecognizer!)
        
        UIImage.getWebImage(imageUrl: self.playerImgUrl) { (responseImage) in
                
                self.playerImg.image = responseImage
            
        }
        
        UIImage.getWebImage(imageUrl: self.teamImgUrl) { (responseImage) in
            
            self.teamImg.image = responseImage
            
        }
        
        /*
        let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
        if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
            self.teamLogo.isHidden = !isLogo
            //self.teamFormView.isHidden = isLogo
            
            teamLogo.image = nil
            
            
            if isLogo {
                UIImage.getWebImage(imageUrl: teamData.teamLogoURLString) { (responseImage) in
                    
                    self.teamLogo.image = responseImage
                }
                
            }
            
        }
        */
        
        
        
        
    }
    
    /**
     * @TODO: update delegate method
     */
    
    public func cellTapGestureTapped(sender: UITapGestureRecognizer?) -> Void {
        
        guard self.delegate != nil else {
            return
        }
        
        self.delegate?.playerTableCellTapped(playerId: self.playerId)
    }

}
