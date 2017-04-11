//
//  BA_WhoWinsResultCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 28/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_WhoWinsResultCollectionViewCell: UICollectionViewCell {
	
    private var delegate: BA_WhoWinsCellCollectionViewCellDelegate?
    
    @IBOutlet weak var team1ProgressContainer: UIView!
    @IBOutlet weak var team1ButtonContainer: UIView!
    @IBOutlet weak var drawProgressContainer: UIView!
    @IBOutlet weak var drawButtonContainer: UIView!
    @IBOutlet weak var team2ProgressContainer: UIView!
    @IBOutlet weak var team2ButtonContainer: UIView!
    
	@IBOutlet var team1ProgressView: BA_CircleProgressView!
	@IBOutlet var drawProgressView: BA_CircleProgressView!
	@IBOutlet var team2ProgressView: BA_CircleProgressView!
	
	@IBOutlet var team1Name: UILabel!
	@IBOutlet var team2Name: UILabel!
	
	@IBOutlet var team1Percent: UILabel!
	@IBOutlet var team2Percent: UILabel!
	@IBOutlet var drawPercent: UILabel!
    
    @IBOutlet var team1Button: UIButton!
    @IBOutlet var team2Button: UIButton!
    @IBOutlet var drawButton: UIButton!
	
	var team1VoteCount = 0
	var team2VoteCount = 0
	var drawVoteCount = 0

    enum TappedButton {
        case no
        case team1
        case draw
        case team2
    }
    
    var buttonTapped = TappedButton.no
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addMask(to: team1ProgressContainer)
        addMask(to: team1ButtonContainer)
        addMask(to: drawProgressContainer)
        addMask(to: drawButtonContainer)
        addMask(to: team2ProgressContainer)
        addMask(to: team2ButtonContainer)
        
    }
	
    func setupCell(matchDetailData: UnsafeMutablePointer<BA_MatchDetailData>?, isVoted: Bool, delegate: BA_WhoWinsCellCollectionViewCellDelegate) {
        
        self.delegate = delegate
        
        self.team1Name.text = matchDetailData?.pointee.homeTeamName
        self.team2Name.text = matchDetailData?.pointee.awayTeamName
        
        if buttonTapped == .no {
            team1ButtonContainer.isHidden = isVoted
            drawButtonContainer.isHidden = isVoted
            team2ButtonContainer.isHidden = isVoted
            team1ProgressContainer.isHidden = !isVoted
            drawProgressContainer.isHidden = !isVoted
            team2ProgressContainer.isHidden = !isVoted
        }
        
        if isVoted {
            
            team1VoteCount = matchDetailData?.pointee.homeTeamForecast ?? 0
            team2VoteCount = matchDetailData?.pointee.awayTeamForecast ?? 0
            drawVoteCount = matchDetailData?.pointee.drawForecast ?? 0
            
            if(team1VoteCount != 0 || team2VoteCount != 0 || drawVoteCount != 0) {
                
                self.calculateVotes(voteTeam: "")
            }
        }
    }
	
	func calculateVotes(voteTeam: String) {
		
		if(voteTeam == "home") {
			
			team1VoteCount += 1
		} else if(voteTeam == "draw") {
			
			drawVoteCount += 1
		} else if(voteTeam == "away") {
			
			team2VoteCount += 1
		}
		
		let sumOfVotes = Double(team1VoteCount + team2VoteCount + drawVoteCount)
		let team1PercentDbl = Double(team1VoteCount) / sumOfVotes
		let team2PercentDbl = Double(team2VoteCount) / sumOfVotes
		let drawPercentDbl = Double(drawVoteCount) / sumOfVotes
		
		let team1RiseValue = team1PercentDbl / 8
		let team2RiseValue = team1PercentDbl / 8
		let drawRiseValue = drawPercentDbl / 8
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
		
            self.setupPercentTexts(team1PercentVal: team1PercentDbl, drawPercentVal: drawPercentDbl, team2PercentVal: team2PercentDbl, team1RiseValue: team1RiseValue, drawRiseValue: drawRiseValue, team2RiseValue: team2RiseValue, team1CurrentPercent: 0, drawCurrentPercent: 0, team2CurrentPercent: 0, currentDuration: 0)
            
            let progressAnimationDuration = 0.8
            
            switch self.buttonTapped {
            case .no:
                self.team1ProgressView.setProgress(progress: team1PercentDbl, animationduration: progressAnimationDuration)
                self.drawProgressView.setProgress(progress: drawPercentDbl, animationduration: progressAnimationDuration)
                self.team2ProgressView.setProgress(progress: team2PercentDbl, animationduration: progressAnimationDuration)
            case .team1:
                UIView.transition(from: self.team1ButtonContainer, to: self.team1ProgressContainer, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                    self.team1ProgressView.setProgress(progress: team1PercentDbl, animationduration: progressAnimationDuration)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + progressAnimationDuration, execute: {
                        UIView.transition(from: self.team2ButtonContainer, to: self.team2ProgressContainer, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                            self.team2ProgressView.setProgress(progress: team2PercentDbl, animationduration: progressAnimationDuration)
                        })
                        UIView.transition(from: self.drawButtonContainer, to: self.drawProgressContainer, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                            self.drawProgressView.setProgress(progress: drawPercentDbl, animationduration: progressAnimationDuration)
                        })
                    })
                })
            case .draw:
                UIView.transition(from: self.drawButtonContainer, to: self.drawProgressContainer, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                    
                    self.drawProgressView.setProgress(progress: drawPercentDbl, animationduration: progressAnimationDuration)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + progressAnimationDuration, execute: {
                        UIView.transition(from: self.team2ButtonContainer, to: self.team2ProgressContainer, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                            self.team2ProgressView.setProgress(progress: team2PercentDbl, animationduration: progressAnimationDuration)
                        })
                        UIView.transition(from: self.team1ButtonContainer, to: self.team1ProgressContainer, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                            self.team1ProgressView.setProgress(progress: team1PercentDbl, animationduration: progressAnimationDuration)
                        })
                    })
                })
            case .team2:
                UIView.transition(from: self.team2ButtonContainer, to: self.team2ProgressContainer, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                    self.team2ProgressView.setProgress(progress: team2PercentDbl, animationduration: progressAnimationDuration)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + progressAnimationDuration, execute: {
                        UIView.transition(from: self.team1ButtonContainer, to: self.team1ProgressContainer, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                            self.team1ProgressView.setProgress(progress: team1PercentDbl, animationduration: progressAnimationDuration)
                        })
                        UIView.transition(from: self.drawButtonContainer, to: self.drawProgressContainer, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { (success) in
                            self.drawProgressView.setProgress(progress: drawPercentDbl, animationduration: progressAnimationDuration)
                        })
                    })
                })
            }
            
            self.buttonTapped = .no
		})
	}
	
	private func setupPercentTexts(team1PercentVal: Double, drawPercentVal: Double, team2PercentVal: Double, team1RiseValue: Double, drawRiseValue: Double, team2RiseValue: Double, team1CurrentPercent: Double, drawCurrentPercent: Double, team2CurrentPercent: Double, currentDuration: Int) {
		
		if(currentDuration == 800) {
			
			self.team1Percent.text = "% " + String(format: "%.2f", (team1PercentVal * 100.0))
			self.team2Percent.text = "% " + String(format: "%.2f", (team2PercentVal * 100.0))
			self.drawPercent.text = "% " + String(format: "%.2f", (drawPercentVal * 100.0))
		}else{
			
			self.team1Percent.text = "% " + String(format: "%.2f", ((team1CurrentPercent + team1RiseValue) * 100.0))
			self.team2Percent.text = "% " + String(format: "%.2f", ((team2CurrentPercent + team2RiseValue) * 100.0))
			self.drawPercent.text = "% " + String(format: "%.2f", ((drawCurrentPercent + drawRiseValue) * 100.0))
			
			let nextDuration = currentDuration + 100
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
			
				self.setupPercentTexts(team1PercentVal: team1PercentVal, drawPercentVal: drawPercentVal, team2PercentVal: team2PercentVal, team1RiseValue: team1RiseValue, drawRiseValue: drawRiseValue, team2RiseValue: team2RiseValue, team1CurrentPercent: (team1CurrentPercent + team1RiseValue), drawCurrentPercent: (drawCurrentPercent + drawRiseValue), team2CurrentPercent: (team2CurrentPercent + team2RiseValue), currentDuration: nextDuration)
			})
		}
	}
    
    private func addMask(to view: UIView) {
        
        let progressMask = CAShapeLayer()
        
        // using more accurate mask instead of team1ProgressView
        let frameView = UIView()
        frameView.frame = CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)
        frameView.center = view.center
        
        progressMask.frame = frameView.bounds
        progressMask.path = UIBezierPath.init(ovalIn: frameView.frame).cgPath
        progressMask.fillColor = UIColor.white.cgColor
        
        view.layer.mask = progressMask
    }
    
    // MARK: - Actions
    
    @IBAction func onTeam1(sender: UIButton) {
        guard self.delegate != nil else {
            return
        }
        
        buttonTapped = .team1
        self.delegate!.whoWinsCellTabBtnTapped(btnIdx: 0)
    }
    
    @IBAction func onTeam2(sender: UIButton) {
        guard self.delegate != nil else {
            return
        }
        
        buttonTapped = .team2
        self.delegate!.whoWinsCellTabBtnTapped(btnIdx: 1)
    }
    
    @IBAction func onDraw(sender: UIButton) {
        guard self.delegate != nil else {
            return
        }
        
        buttonTapped = .draw
        self.delegate!.whoWinsCellTabBtnTapped(btnIdx: 2)
    }
}
