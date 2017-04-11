//
//  BA_MatchDetailSegmentCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 06/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

class BA_MatchDetailSegmentCollectionViewCell: UICollectionViewCell {

	@IBOutlet var segmentControl: UISegmentedControl!
    
    @IBOutlet var homeTeamView: UIView!
    @IBOutlet var homeTeamFormView: BA_TeamForm!
    @IBOutlet var homeTeamNameLabel: UILabel!
    @IBOutlet var homeTeamLogo: UIImageView!
    
    @IBOutlet var awayTeamView: UIView!
    @IBOutlet var awayTeamFormView: BA_TeamForm!
    @IBOutlet var awayTeamNameLabel: UILabel!
    @IBOutlet var awayTeamLogo: UIImageView!
    
    @IBOutlet var bothTeamView: UIView!
    @IBOutlet var bothHomeTeamFormView: BA_TeamForm!
    @IBOutlet var bothHomeTeamNameLabel: UILabel!
    @IBOutlet var bothAwayTeamFormView: BA_TeamForm!
    @IBOutlet var bothAwayTeamNameLabel: UILabel!
    @IBOutlet var bothHomeTeamLogo: UIImageView!
    @IBOutlet var bothAwayTeamLogo: UIImageView!
	
	private var delegate: BA_MatchDetailSegmentControlDelegate?
	private var section: Int!
	
	/*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	*/

	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	func setupCell(segmentCount: Int, segmentTexts: [String], selectedIdx: Int, segmentsEnabled: [Bool], section: Int, delegate: BA_MatchDetailSegmentControlDelegate) {
		
		self.section = section
		self.segmentControl.removeAllSegments()
		
		for i in 0..<segmentCount {
			
			self.segmentControl.insertSegment(withTitle: segmentTexts[i], at: i, animated: false)
		}
		
		self.segmentControl.selectedSegmentIndex = selectedIdx
		
		for k in 0..<segmentCount {
			
			self.segmentControl.setEnabled(segmentsEnabled[k], forSegmentAt: k)
		}
		
		self.delegate = delegate
	}
    
    func setupCell(homeTeam: BA_Team, awayTeam: BA_Team, selectedIdx: Int, section: Int, delegate: BA_MatchDetailSegmentControlDelegate) {
        
        self.section = section
        self.segmentControl.removeAllSegments()
        
        self.segmentControl.insertSegment(withTitle: homeTeam.teamName, at: 0, animated: false)
        self.segmentControl.insertSegment(withTitle: "Karşılıklı", at: 1, animated: false)
        self.segmentControl.insertSegment(withTitle: awayTeam.teamName, at: 2, animated: false)
        
        self.segmentControl.selectedSegmentIndex = selectedIdx
        
        let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
        if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
            self.homeTeamLogo.isHidden = !isLogo
            self.awayTeamLogo.isHidden = !isLogo
            self.bothHomeTeamLogo.isHidden = !isLogo
            self.bothAwayTeamLogo.isHidden = !isLogo
            self.homeTeamFormView.isHidden = isLogo
            self.awayTeamFormView.isHidden = isLogo
            self.bothHomeTeamFormView.isHidden = isLogo
            self.bothAwayTeamFormView.isHidden = isLogo
            
            if isLogo {
                UIImage.getWebImage(imageUrl: homeTeam.teamLogoURLString) { (responseImage) in
                    
                    self.homeTeamLogo.image = responseImage
                    self.bothHomeTeamLogo.image = responseImage
                }
                UIImage.getWebImage(imageUrl: awayTeam.teamLogoURLString) { (responseImage) in
                    
                    self.awayTeamLogo.image = responseImage
                    self.bothAwayTeamLogo.image = responseImage
                }
            }
            
        } else {
            self.homeTeamLogo.isHidden = true
            self.awayTeamLogo.isHidden = true
            self.bothHomeTeamLogo.isHidden = true
            self.bothAwayTeamLogo.isHidden = true
            self.homeTeamFormView.isHidden = false
            self.awayTeamFormView.isHidden = false
            self.bothHomeTeamFormView.isHidden = false
            self.bothAwayTeamFormView.isHidden = false
        }
        
        homeTeamFormView.setTeamFormColors(leftFormColor: homeTeam.color1, rightFormColor: homeTeam.color2)
        homeTeamNameLabel.text = homeTeam.teamName
        awayTeamFormView.setTeamFormColors(leftFormColor: awayTeam.color1, rightFormColor: awayTeam.color2)
        awayTeamNameLabel.text = awayTeam.teamName
        
        bothHomeTeamFormView.setTeamFormColors(leftFormColor: homeTeam.color1, rightFormColor: homeTeam.color2)
        bothHomeTeamNameLabel.text = homeTeam.teamName
        bothAwayTeamFormView.setTeamFormColors(leftFormColor: awayTeam.color1, rightFormColor: awayTeam.color2)
        bothAwayTeamNameLabel.text = awayTeam.teamName
        
        switch selectedIdx {
        case 0:
            awayTeamView.isHidden = true
            bothTeamView.isHidden = true
            homeTeamView.isHidden = false
        case 1:
            awayTeamView.isHidden = true
            bothTeamView.isHidden = false
            homeTeamView.isHidden = true
        case 2:
            awayTeamView.isHidden = false
            bothTeamView.isHidden = true
            homeTeamView.isHidden = true
        default:
            homeTeamView.isHidden = true
            awayTeamView.isHidden = true
            bothTeamView.isHidden = true
        }
        
        self.delegate = delegate
    }
	
	@IBAction func segmentChanged(_ sender: UISegmentedControl) {
		
		guard self.delegate != nil else {
			
			return
		}
        
        switch sender.selectedSegmentIndex {
        case 0:
            awayTeamView.isHidden = true
            bothTeamView.isHidden = true
            homeTeamView.isHidden = false
        case 1:
            awayTeamView.isHidden = true
            bothTeamView.isHidden = false
            homeTeamView.isHidden = true
        case 2:
            awayTeamView.isHidden = false
            bothTeamView.isHidden = true
            homeTeamView.isHidden = true
        default:
            homeTeamView.isHidden = true
            awayTeamView.isHidden = true
            bothTeamView.isHidden = true
        }
		
		self.delegate!.matchDetailSegmentChanged(selectedIdx: sender.selectedSegmentIndex, section: self.section, invalidate: true)
	}
	
}
