//
//  ScoreTableViewCell.swift
//  bahisadam
//
//  Created by anton on 3/16/17.
//

import UIKit
import BahisadamLive

protocol ScoreTableViewCellDelegate {
    
    func teamTableCellTapped(teamId: Int)
    
}

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posNum: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamFormView: BA_TeamForm!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var omNum: UILabel!
    @IBOutlet weak var gNum: UILabel!
    @IBOutlet weak var bNum: UILabel!
    @IBOutlet weak var mNum: UILabel!
    @IBOutlet weak var ptsNum: UILabel!
    
    private var delegate: ScoreTableViewCellDelegate?
    private var teamId: Int!
    public var color1: UIColor!
    public var color2: UIColor!
    
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    
    func setupCell(standingData: BA_Standings, teamData: BA_Team, delegate: ScoreTableViewCellDelegate) {
        
        
        self.posNum.text = String(standingData.groupCode)
        self.teamName.text = standingData.teamName
        self.omNum.text = String(standingData.standingOM)
        self.gNum.text = String(standingData.standingG)
        self.bNum.text = String(standingData.standingB)
        self.mNum.text = String(standingData.standingM)
        self.ptsNum.text = String(standingData.standingPTS)
        
        self.teamId = Int(standingData.teamId)
        self.delegate = delegate
        
        color1 = teamData.color1
        color2 = teamData.color2
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(cellTapGestureTapped(sender:)))
        self.contentView.addGestureRecognizer(self.tapGestureRecognizer!)
        
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
         
            } else {
            self.teamLogo.isHidden = true
            self.teamFormView.isHidden = false
         }
         
         
         self.teamFormView.setTeamFormColors(leftFormColor: color1, rightFormColor: color2)
        */
        self.teamLogo.isHidden = false
        self.teamFormView.isHidden = true
        self.teamLogo.image = nil
        let logoUrlString: String = teamData.teamLogoURLString
        UIImage.getWebImage(imageUrl: logoUrlString) { (responseImage) in
            
            self.teamLogo.image = responseImage
        }
        
    }
    
    /**
     * @TODO: update delegate method
     */
    
    public func cellTapGestureTapped(sender: UITapGestureRecognizer?) -> Void {
        
        guard self.delegate != nil else {
            return
        }
        
        self.delegate?.teamTableCellTapped(teamId: self.teamId)
    }
    
}
