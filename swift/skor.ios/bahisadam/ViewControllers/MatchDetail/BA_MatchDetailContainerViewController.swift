//
//  BA_MatchDetailIndexViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 24/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import MBProgressHUD
import BahisadamLive
import Dispatch
import Crashlytics
import KDCircularProgress
import FontAwesome_swift
import FirebaseMessaging

enum BA_MatchDetailesPresentationType {
    case no
    case stats
    case lineup
}

struct BA_MatcDetailForecasts {
	
	let userId: String
	let userName: String
	let userScore: Float
	let forecastId: String
	let forecast: String
	let userComment: String
	let commentAreaHeight: Float
	
	var totalLike: Int
}

class BA_MatchDetailContainerViewController: UIViewController, BA_FakeTabBarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, BA_MatchDetailMenuDelegate, BA_WhoWinsCellCollectionViewCellDelegate, BA_PointsCellCollectionViewCellDelegate, BA_ForecastsCollectionViewCellDelegate, BA_MatchDetailSegmentControlDelegate, BA_MatchDetailNewForecastDelegate, BA_MatchDetailCreateForecastDelegate, BA_LoginDelegate {

	// MARK: User defined attributes
    var headerViewInitialHeight: NSNumber!
    var smallHeaderInitialHeight: NSNumber!
	var forecastCellInitialHeight: NSNumber!
	var forecastCellCommentAreaHeight: NSNumber!
	
	// MARK: Outlets
	@IBOutlet var team1FormLeft: UIImageView!
	@IBOutlet var team1FormRight: UIImageView!
	@IBOutlet var team2FormLeft: UIImageView!
	@IBOutlet var team2FormRight: UIImageView!
    @IBOutlet var team1FormContainer: UIView!
    @IBOutlet var team2FormContainer: UIView!
    @IBOutlet var team1Logo: UIImageView!
    @IBOutlet var team2Logo: UIImageView!
	@IBOutlet var homeTeamName: UILabel!
	@IBOutlet var awayTeamName: UILabel!
	@IBOutlet var leagueNameTitle: UILabel!
	@IBOutlet var currentTabBar: BA_FakeTabBarView!
	@IBOutlet var willPlayingView: UIView!
	@IBOutlet var willPlayingViewTimeLeft: UILabel!
	@IBOutlet var headerViewHeightConstraints: NSLayoutConstraint!
	@IBOutlet var headerImageHeightConstraints: NSLayoutConstraint!
	@IBOutlet var playingView: UIView!
    
    @IBOutlet weak var timeProgressView: KDCircularProgress!
    @IBOutlet weak var currentMinuteLabel: UILabel!
    @IBOutlet weak var matchResultLabel: UILabel!
    @IBOutlet weak var firsttimeResult: UILabel!
	
	@IBOutlet var team1FormLeftBorder: UIImageView!
	@IBOutlet var team1FormRightBorder: UIImageView!
	@IBOutlet var team2FormLeftBorder: UIImageView!
	@IBOutlet var team2FormRightBorder: UIImageView!
    
    @IBOutlet var team1LastMatchesView: UIView!
    @IBOutlet var team2LastMatchesView: UIView!
	
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
	@IBOutlet var collectionView: UICollectionView!
	
	var delegate: BA_MatchDetailContainerDelegate?
	var matchId: String?
    var presentationType = BA_MatchDetailesPresentationType.no
	var cellData: [BA_MatchDetailIndexCellData]!
	
	// MARK: Index
	private var forecastsData: [BA_MatcDetailForecasts]?
	private var forecastDataIsDownloading = false
	private var isWhoWinsVoting = false
	private var whoWinsVoteValue: String?
	
	// MARK: Matches
	private var currentMatchesTab: Int?
	
	// MARK: Stats
	private var currentSelectedStatsTab: Int?
	
	// MARK: Lineups
	private var currentSelectedLineupsTab: Int?
	
	// MARK: New Forecast
	private var oldContentInset: UIEdgeInsets?
	
	private var matchDetailData: BA_MatchDetailData?
	private var matchDetailDataPP: UnsafeMutablePointer<BA_MatchDetailData>?
	private var matchDetailMenuPP: UnsafeMutablePointer<BA_MatchDetailTabMenuViewController>?
	private var loadedMatchDetailApis = 0
	private var timerSetted = false
	private var currentSelectedMenu = 0
	private var tabIsChanging = false
	
	private lazy var headerSizeQueue = DispatchQueue(label: "com.bahisadam.headerSizeQueue", qos: DispatchQoS.userInteractive, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: DispatchQueue.main)
	
	private lazy var headerViewInitialHeightCGF: CGFloat = CGFloat(self.headerViewInitialHeight.floatValue)
	private lazy var smallHeaderInitialHeightCGF: CGFloat = CGFloat(self.smallHeaderInitialHeight.floatValue)
	private lazy var headerViewDiff: CGFloat = CGFloat(self.headerViewInitialHeight.floatValue) - CGFloat(self.smallHeaderInitialHeight.floatValue)
    
    private var isFavorite = false
	
	// MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch presentationType {
        case .stats:
            self.currentSelectedMenu = BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS)
        case .lineup:
            self.currentSelectedMenu = BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS)
        default:
            break
        }
		
		let collectionViewHeader = UINib(nibName: "BA_MatchDetailIndexCollectionReusableView", bundle: nil)
		self.collectionView.register(collectionViewHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "matchDetailIndexHeader")
        
        let statsHeader = UINib(nibName: "BA_MatchDetailsStatsHeader", bundle: nil)
        self.collectionView.register(statsHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "statisticHeader")
		
		let collectionViewFooter = UINib(nibName: "BA_MatchDetailFooterCollectionReusableView", bundle: nil)
		self.collectionView.register(collectionViewFooter, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "matchDetailIndexFooter")
		
		let segmentNib = UINib(nibName: "BA_MatchDetailSegmentCollectionViewCell", bundle: nil)
		self.collectionView.register(segmentNib, forCellWithReuseIdentifier: "matchDetailSegmentCell")
		
		let forecastsNib = UINib(nibName: "BA_MatchDetailForecastCell", bundle: nil)
		self.collectionView.register(forecastsNib, forCellWithReuseIdentifier: "ForecastsCell")
		
		let pointsCellNib = UINib(nibName: "BA_MatchDetailPointsCell", bundle: nil)
		self.collectionView.register(pointsCellNib, forCellWithReuseIdentifier: "PointsCell")
		
		let generalStatsCellNib = UINib(nibName: "BA_MatchDetailGeneralStatsCell", bundle: nil)
		self.collectionView.register(generalStatsCellNib, forCellWithReuseIdentifier: "GeneralStatsCell")
		
		let ballControllCellNib = UINib(nibName: "BA_MatchDetailBallControllCell", bundle: nil)
		self.collectionView.register(ballControllCellNib, forCellWithReuseIdentifier: "BallControlCell")
		
		let matchStatsCellNib = UINib(nibName: "BA_MatchDetailMatchStatsCell", bundle: nil)
		self.collectionView.register(matchStatsCellNib, forCellWithReuseIdentifier: "MatchStatsCell")
		
		let matchLineupsCellNib = UINib(nibName: "BA_MatchDetailLineupsCell", bundle: nil)
		self.collectionView.register(matchLineupsCellNib, forCellWithReuseIdentifier: "LineupsCell")
		
		let newForecastCellNib = UINib(nibName: "BA_MatchDetailNewForecastCell", bundle: nil)
		self.collectionView.register(newForecastCellNib, forCellWithReuseIdentifier: "NewForecastsCell")
		
		let createForecastCellNib = UINib(nibName: "BA_MatchDetailCreateForecastCell", bundle: nil)
		self.collectionView.register(createForecastCellNib, forCellWithReuseIdentifier: "CreateForecastsCell")
		
		self.collectionView?.contentInset = UIEdgeInsets(top: headerViewInitialHeightCGF - 20, left: 0, bottom: 0, right: 0)
        
        self.currentMinuteLabel.layer.cornerRadius = self.currentMinuteLabel.bounds.size.width / 2.0
        self.currentMinuteLabel.layer.masksToBounds = true
        self.currentMinuteLabel.backgroundColor = UIColor(colorLiteralRed: 23.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        
        self.updateFavoritesButton()
        self.backButton.imageView?.contentMode = .scaleAspectFit
        self.backButton.contentEdgeInsets = UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0)
        
        self.team1Logo.layer.cornerRadius = self.team1Logo.bounds.size.width / 2.0
        self.team1Logo.layer.masksToBounds = true
        self.team2Logo.layer.cornerRadius = self.team2Logo.bounds.size.width / 2.0
        self.team2Logo.layer.masksToBounds = true
		
        NotificationCenter.default.addObserver(self, selector: #selector(userStateChanged(notification:)), name: NSNotification.Name(rawValue: "UserStateChanged"), object: nil)
    }

	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		currentTabBar.delegate = self
        if let loginData = BA_AppDelegate.Ba_LoginData {
            if loginData.IsDeviceLogin {
                currentTabBar.setupLoggedIn()
            }
        }
		
		MBProgressHUD.showAdded(to: self.view, animated: true)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		self.loadedMatchDetailApis = 0
		self.loadData()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
		self.timerSetted = false
		currentTabBar.delegate = nil
		
		if(self.matchDetailMenuPP != nil) {
			
			self.matchDetailMenuPP!.pointee.delegate = nil
			
			defer {
				self.matchDetailMenuPP!.deinitialize()
				self.matchDetailMenuPP!.deallocate(capacity: MemoryLayout<BA_MatchDetailTabMenuViewController>.size)
			}
		}
		
		defer {
			self.matchDetailDataPP!.deinitialize()
			self.matchDetailDataPP!.deallocate(capacity: MemoryLayout<BA_MatchDetailData>.size)
		}
		
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		super.viewWillDisappear(animated)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
	
    @IBAction func onFavorite(_ sender: UIButton) {
        
        if let matchId = matchDetailData?.matchId {
            let postData = ["match_id" : matchId as AnyObject]
            
            guard BA_AppDelegate.Ba_LoginData != nil else {
                
                BA_AppDelegate.Ba_LoginData = BA_Login(withDelegate: self)
                return
            }
            
            if(!BA_AppDelegate.Ba_LoginData!.IsDeviceLogin) {
                
                BA_AppDelegate.Ba_LoginData!.loginDelegate = self
                BA_AppDelegate.Ba_LoginData!.askLoginOrRegister()
            } else {
                let apiAddress = isFavorite ? BA_Server.RemoveFavoritesApi : BA_Server.AddFavoritesApi
                IO_NetworkHelper.init(postJSONRequestWithHeader: apiAddress, postData: postData, headers: ["X-BA-Authentication" : IO_Helpers.deviceUUID]) { (success, data, errorStr, statusCode) in
                    if success {
                        
                        let topicName = "/topics/\(matchId)"
                        
                        if self.isFavorite {
                            if let index = BA_AppDelegate.Ba_LoginData!.favorites?.index(of: matchId) {
                                BA_AppDelegate.Ba_LoginData!.favorites?.remove(at: index)
                                FIRMessaging.messaging().unsubscribe(fromTopic: topicName)
                            }
                        } else {
                            if BA_AppDelegate.Ba_LoginData!.favorites == nil {
                                BA_AppDelegate.Ba_LoginData!.favorites = [String]()
                            }
                            BA_AppDelegate.Ba_LoginData!.favorites?.append(matchId)
                            FIRMessaging.messaging().subscribe(toTopic: topicName)
                        }
                        
                        DispatchQueue.main.async {
                            self.isFavorite = !self.isFavorite
                            self.updateFavoritesButton()
                        }
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.IO_dismissViewControllerWithCustomAnimation()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
	*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if let segueID = segue.identifier {
			
			if(segueID == "sg_match_detail_menu") {
				
				if let matchDetailMenu = segue.destination as? BA_MatchDetailTabMenuViewController {
					
					matchDetailMenu.delegate = self
					
					if(self.matchDetailMenuPP != nil) {
						
						self.matchDetailMenuPP!.deinitialize()
						self.matchDetailMenuPP!.deallocate(capacity: MemoryLayout<BA_MatchDetailTabMenuViewController>.size)
					}
					
					self.matchDetailMenuPP = UnsafeMutablePointer<BA_MatchDetailTabMenuViewController>.allocate(capacity: MemoryLayout<BA_MatchDetailTabMenuViewController>.size)
					self.matchDetailMenuPP?.initialize(to: matchDetailMenu)
				}
			}
		}
    }
	
	// MARK: UIScrollView
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		guard (!self.tabIsChanging) else {
			return
		}
		
		let correctScrollPosition: CGFloat = self.collectionView.contentOffset.y + headerViewInitialHeightCGF - 20
		
		self.headerSizeQueue.async {
			
			let newSize = self.smallHeaderInitialHeightCGF - correctScrollPosition
			let imageNewSize = self.headerViewInitialHeightCGF - correctScrollPosition
			
			if(abs(self.headerViewHeightConstraints.constant - newSize) > 1) {
				
				if(newSize < 0) {
					
					self.headerViewHeightConstraints.constant = 0
				}else{
					
					self.headerViewHeightConstraints.constant = newSize
				}
				
			}else if(newSize < 0 && self.headerViewHeightConstraints.constant != 0) {
				
				self.headerViewHeightConstraints.constant = 0
			}
			
			if(abs(self.headerImageHeightConstraints.constant - imageNewSize) > 1) {
				
				if(imageNewSize < self.headerViewDiff) {
					
					self.headerImageHeightConstraints.constant = self.headerViewDiff
				}else{
					
					self.headerImageHeightConstraints.constant = imageNewSize
				}
			}else if(imageNewSize < self.headerViewDiff && self.headerImageHeightConstraints.constant != self.headerViewDiff) {
				
				self.headerImageHeightConstraints.constant = self.headerViewDiff
			}
		}
	}
	
	// MARK: Tab bar
	func fakeTabBarItemSelected(tabBarItemNumber: Int) {
		
		self.IO_dismissViewControllerWithCustomAnimation()
		guard self.delegate != nil else {
			
			return
		}
		
		self.delegate?.BA_MatchDetailDismiss(tabBarItemNumber: tabBarItemNumber)
	}
	
	func itemTapped(itemNumber: Int) {
		
		guard (itemNumber != self.currentSelectedMenu) else {
			return
		}
		
		self.tabIsChanging = true
		
		self.headerSizeQueue.async {
			
			self.headerViewHeightConstraints.constant = self.smallHeaderInitialHeightCGF
			self.headerImageHeightConstraints.constant = self.headerViewInitialHeightCGF
		}
		
		if(itemNumber == BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES)) {
			
			if(self.currentMatchesTab == nil) {
				
				self.currentMatchesTab = 0
			}
			self.matchDetailSegmentChanged(selectedIdx: self.currentMatchesTab!, section: itemNumber, invalidate: false)
			
		}else if(itemNumber == BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS)) {
			
			if(self.currentSelectedStatsTab == nil && self.matchDetailData != nil) {
				
				if((self.matchDetailData?.isPlayed)! || (self.matchDetailData?.isPlaying)!) {
					
					self.currentSelectedStatsTab = 0
				}else{
					self.currentSelectedStatsTab = 1
				}
			}
			
			if(self.currentSelectedStatsTab != nil) {
				
				self.matchDetailSegmentChanged(selectedIdx: self.currentSelectedStatsTab!, section: itemNumber, invalidate: false)
			}
		}
		
		if let matchDetailLayout = self.collectionView?.collectionViewLayout as? BA_MatchDetailIndexLayout {
			
			let oldTab = self.currentSelectedMenu
			matchDetailLayout.changeTab(tabNum: itemNumber, cellData: self.cellData)
            
			self.collectionView.performBatchUpdates({
				
				self.currentSelectedMenu = itemNumber
				
				var removeSections = [Int]()
				var currentRemoveSection = 0
					
				var addSections = [Int]()
				var currentAddSection = 0
					
				for cellData in self.cellData {
						
					if(cellData.tabIdx == oldTab) {
							
						removeSections.append(currentRemoveSection)
						currentRemoveSection += 1
							
					}else if(cellData.tabIdx == itemNumber) {
							
						addSections.append(currentAddSection)
						currentAddSection += 1
					}
				}
				
				self.collectionView.deleteSections(IndexSet(removeSections))
				self.collectionView.insertSections(IndexSet(addSections))
					
			}, completion: { (_) in
                
				if(itemNumber == BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.CREATE_FORECAST)) {
					
					guard BA_AppDelegate.Ba_LoginData != nil else {
						
						BA_AppDelegate.Ba_LoginData = BA_Login(withDelegate: self)
						return
					}
					
					if(!BA_AppDelegate.Ba_LoginData!.IsDeviceLogin) {
						
						BA_AppDelegate.Ba_LoginData!.loginDelegate = self
						BA_AppDelegate.Ba_LoginData!.askLoginOrRegister()
					}
				}
				
				guard self.matchDetailMenuPP != nil else {
					return
				}
				
				self.matchDetailMenuPP?.pointee.setSelectedTab(tabIdx: itemNumber)
				self.tabIsChanging = false
			})

		}else{
			
			self.tabIsChanging = false
		}
		
	}
	
	// MARK: Load and Parse Data
	private func loadData() {
		
		guard self.matchId != nil else {
			return
		}
		
		if(self.matchDetailData != nil && self.matchDetailData?.matchId == self.matchId) {
			
			self.updatePageVCData()
			return
		}
		
		self.matchDetailData = BA_MatchDetailData(matchId: self.matchId!)
		
		let urlString = String(format: BA_Server.MatchDetailApi, self.matchId!)
		IO_NetworkHelper(getJSONRequest: urlString, completitionHandler: { (status, data, error, statusCode) in
			
			if(status) {
				
				if let dataDict = data as? Dictionary<String, AnyObject> {
					
					self.configureData(data: dataDict)
					return
				}
			}
			
			self.loadedMatchDetailApis += 3
		})
	}
	
	private func parseMatchData(data: [[String : AnyObject]]) -> [BA_Matc] {
		
		var retval = [BA_Matc]()
		
		for teamLastMatch in data {
		
            let homeTeamId: Int
			let homeTeamName: String
			let homeTeamColor1: String
			let homeTeamColor2: String
			
			if let homeTeamData = teamLastMatch["home_team"] as? [String : AnyObject] {
        
                if let idfield = homeTeamData["id"] as? String {
                    homeTeamId = Int(idfield)!
                }else{
                    homeTeamId = homeTeamData["id"] as? Int ?? 0
                }
                
				homeTeamName = homeTeamData["team_name_tr"] as? String ?? ""
				homeTeamColor1 = homeTeamData["color1"] as? String ?? "#FFFFFF"
				homeTeamColor2 = homeTeamData["color2"] as? String ?? "#FFFFFF"
			}else{
                homeTeamId = 0
				homeTeamName = ""
				homeTeamColor1 = "#FFFFFF"
				homeTeamColor2 = "#FFFFFF"
			}
			let homeTeam = BA_Team(teamName: homeTeamName, teamId: homeTeamId, color1: homeTeamColor1, color2: homeTeamColor2)
			
            let awayTeamId: Int
			let awayTeamName: String
			let awayTeamColor1: String
			let awayTeamColor2: String
			
			if let awayTeamData = teamLastMatch["away_team"] as? [String : AnyObject] {
            
                if let idfield = awayTeamData["id"] as? String {
                    awayTeamId = Int(idfield)!
                }else{
                    awayTeamId = awayTeamData["id"] as? Int ?? 0
                }
                
				awayTeamName = awayTeamData["team_name_tr"] as? String ?? ""
				awayTeamColor1 = awayTeamData["color1"] as? String ?? "#FFFFFF"
				awayTeamColor2 = awayTeamData["color2"] as? String ?? "#FFFFFF"
			}else{
                awayTeamId = 0
				awayTeamName = ""
				awayTeamColor1 = "#FFFFFF"
				awayTeamColor2 = "#FFFFFF"
			}
			let awayTeam = BA_Team(teamName: awayTeamName, teamId: awayTeamId, color1: awayTeamColor1, color2: awayTeamColor2)
			
			let matchDateStr = teamLastMatch["match_date"] as? String ?? ""
			let homeGoals = teamLastMatch["home_goals"] as? Int ?? 0
			let awayGoals = teamLastMatch["away_goals"] as? Int ?? 0
            let halfTimeAwayGoals = teamLastMatch["half_time_away_score"] as? Int ?? 0
            let halfTimeHomeGoals = teamLastMatch["half_time_home_score"] as? Int ?? 0
			
			retval.append(BA_Matc(homeTeam: homeTeam, awayTeam: awayTeam, matchDateStr: matchDateStr, bets: [], resultType: "Played", homeGoals: homeGoals, awayGoals: awayGoals, matchId: "", matchYear: 0, halfTimeHomeGoals: halfTimeHomeGoals, halfTimeAwayGoals: halfTimeAwayGoals, currentMinutes: 0))
		}
		
		let retvalSorted = retval.sorted { (s1, s2) -> Bool in
			
			if(Int((s1.matchDate?.timeIntervalSince1970)!) > Int((s2.matchDate?.timeIntervalSince1970)!)) {
				
				return true
			}
			
			return false
		}
		
		let retvalTrimmed = Array(retvalSorted.prefix(5))
		#if DEBUG
		print(retvalTrimmed)
		#endif
		return retvalTrimmed
	}
	
	private func parsePlayerData(lineups: [[String : AnyObject]]) -> [BA_Player] {
		
		var retval = [BA_Player]()
		
		for player in lineups {
			
			let playerId = player["id"] as? String ?? ""
			let jerseyNumber = player["jersey_number"] as? Int ?? 0
			let playerName = player["name"] as? String ?? ""
			let playerPos = player["type"] as? String ?? ""
			
			retval.append(BA_Player(jerseyNumber: jerseyNumber, playerId: playerId, playerName: playerName, playerPos: playerPos))
		}
		
		return retval
	}
	
	private func configureData(data: Dictionary<String, AnyObject>) {
        
		let resultType = data["result_type"] as? String ?? ""
		if(resultType == "Played") {
			
			self.matchDetailData?.isPlayed = true
		}else if(resultType == "Playing") {
			
			self.matchDetailData?.isPlaying = true
		}
		
		let matchStats = data["stats"] as? [[String : AnyObject]]
		
		if let homeTeamData = data["home_team"] as? Dictionary<String, AnyObject> {
			
//            print(homeTeamData)
            
			self.matchDetailData?.homeTeamName = homeTeamData["team_name_tr"] as? String ?? nil
			self.matchDetailData?.homeTeamColor1 = homeTeamData["color1"] as? String ?? "#ffffff"
			self.matchDetailData?.homeTeamColor2 = homeTeamData["color2"] as? String ?? "#ffffff"
			self.matchDetailData?.homeTeamId = homeTeamData["_id"] as? Int ?? 0
			
			if let homeTeamLastMatches = homeTeamData["allMatches"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.homeTeamLastMatches = self.parseMatchData(data: homeTeamLastMatches)
			}
			
			if let homeTeamHomeMatches = homeTeamData["homeMatches"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.homeTeamHomeMatches = self.parseMatchData(data: homeTeamHomeMatches)
			}
			
			if let homeTeamAwayMatches = homeTeamData["awayMatches"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.homeTeamAwayMatches = self.parseMatchData(data: homeTeamAwayMatches)
			}
			
			if((self.matchDetailData?.isPlayed)! || (self.matchDetailData?.isPlaying)!) {
			
				if (matchStats?.count)! < 1 {
					
					self.matchDetailData?.homeTeamMatchStats = BA_MatchStats(pos: 0.0, foul: 0.0, shot: 0.0, shotOnTarget: 0.0, missedShot: 0.0, rescue: 0.0, freeKick: 0.0, corner: 0.0, offSide: 0.0)
				}else if let homeTeamStats = matchStats?[0] {
					
					self.matchDetailData?.homeTeamMatchStats = BA_MatchStats(pos: (homeTeamStats["pos"] as? Float ?? 0.0), foul: (homeTeamStats["fou"] as? Float ?? 0.0), shot: (homeTeamStats["sot"] as? Float ?? 0.0), shotOnTarget: (homeTeamStats["son"] as? Float ?? 0.0), missedShot: (homeTeamStats["soff"] as? Float ?? 0.0), rescue: (homeTeamStats["blk"] as? Float ?? 0.0), freeKick: (homeTeamStats["frk"] as? Float ?? 0.0), corner: (homeTeamStats["cor"] as? Float ?? 0.0), offSide: (homeTeamStats["off"] as? Float ?? 0.0))
				}
			}
		}
		
		if let awayTeamData = data["away_team"] as? Dictionary<String, AnyObject> {
			
			self.matchDetailData?.awayTeamName = awayTeamData["team_name_tr"] as? String ?? nil
			self.matchDetailData?.awayTeamColor1 = awayTeamData["color1"] as? String ?? "#ffffff"
			self.matchDetailData?.awayTeamColor2 = awayTeamData["color2"] as? String ?? "#ffffff"
			self.matchDetailData?.awayTeamId = awayTeamData["_id"] as? Int ?? 0
			
			if let awayTeamLastMatches = awayTeamData["allMatches"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.awayTeamLastMatches = self.parseMatchData(data: awayTeamLastMatches)
			}
			
			if let awayTeamHomeMatches = awayTeamData["homeMatches"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.awayTeamHomeMatches = self.parseMatchData(data: awayTeamHomeMatches)
			}
			
			if let awayTeamAwayMatches = awayTeamData["awayMatches"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.awayTeamAwayMatches = self.parseMatchData(data: awayTeamAwayMatches)
			}
			
			if((self.matchDetailData?.isPlayed)! || (self.matchDetailData?.isPlaying)!) {
				
				if (matchStats?.count)! < 2 {
					
					self.matchDetailData?.awayTeamMatchStats = BA_MatchStats(pos: 0.0, foul: 0.0, shot: 0.0, shotOnTarget: 0.0, missedShot: 0.0, rescue: 0.0, freeKick: 0.0, corner: 0.0, offSide: 0.0)
					
				}else if let awayTeamStats = matchStats?[1] {
					
					self.matchDetailData?.awayTeamMatchStats = BA_MatchStats(pos: (awayTeamStats["pos"] as? Float ?? 0.0), foul: (awayTeamStats["fou"] as? Float ?? 0.0), shot: (awayTeamStats["sot"] as? Float ?? 0.0), shotOnTarget: (awayTeamStats["son"] as? Float ?? 0.0), missedShot: (awayTeamStats["soff"] as? Float ?? 0.0), rescue: (awayTeamStats["blk"] as? Float ?? 0.0), freeKick: (awayTeamStats["frk"] as? Float ?? 0.0), corner: (awayTeamStats["cor"] as? Float ?? 0.0), offSide: (awayTeamStats["off"] as? Float ?? 0.0))
				}
			}
		}
		
		if let headToHeadData = data["headtohead"] as? [[String : AnyObject]] {
		
			self.matchDetailData?.headToHeadMatches = self.parseMatchData(data: headToHeadData)
		}
		
		if let stadiumData = data["stadium"] as? Dictionary<String, AnyObject> {
		
			self.matchDetailData?.stadiumName = stadiumData["name"] as? String ?? nil
			self.matchDetailData?.stadiumImageUrl = stadiumData["image"] as? String ?? nil
			self.matchDetailData?.stadiumCapacity = stadiumData["capacity"] as? String ?? nil
			self.matchDetailData?.stadiumFans = stadiumData["fans"] as? String ?? nil
			self.matchDetailData?.stadiumYearBuilt = stadiumData["yearBuilt"] as? String ?? nil
		}
		
		if let forecastData = data["forecast"] as? Dictionary<String, AnyObject> {
			
			self.matchDetailData?.homeTeamForecast = forecastData["home"] as? Int ?? 0
			self.matchDetailData?.awayTeamForecast = forecastData["away"] as? Int ?? 0
			self.matchDetailData?.drawForecast = forecastData["draw"] as? Int ?? 0
		}
		
		let groupCodeStr = data["group_code"] as? String ?? "0"
		let groupCode = Int(groupCodeStr) ?? 0
		let leagueId: Int
		let leagueName: String
		if let leagueData = data["league_id"] as? Dictionary<String, AnyObject> {
			
			leagueId = leagueData["_id"] as? Int ?? 0
			leagueName = leagueData["league_name_tr"] as? String ?? ""
		}else{
			
			leagueId = 0
			leagueName = ""
		}

		self.matchDetailData?.leagueId = leagueId
		self.matchDetailData?.leagueName = leagueName
		
		
		self.matchDetailData?.homeGoals = data["home_goals"] as? Int ?? 0
		self.matchDetailData?.awayGoals = data["away_goals"] as? Int ?? 0
        self.matchDetailData?.halfTimeHomeGoals = data["half_time_home_score"] as? Int ?? 0
        self.matchDetailData?.halfTimeAwayGoals = data["half_time_away_score"] as? Int ?? 0
        
		
		if let matchDate = data["match_date"] as? String {
			self.matchDetailData?.matchDate = BA_DateFormat(string: matchDate)
		}
		
		let liveMinute = data["live_minute"] as? Int ?? 0
		self.matchDetailData?.liveMinute = liveMinute
		
		if let homeAverage = data["homeAverageStats"] as? [String : AnyObject] {
			
			self.matchDetailData?.homeTeamAverageStats = BA_MatchStats(pos: (homeAverage["pos"] as? Float ?? 0.0), foul: (homeAverage["fou"] as? Float ?? 0.0), shot: (homeAverage["sot"] as? Float ?? 0.0), shotOnTarget: (homeAverage["son"] as? Float ?? 0.0), missedShot: (homeAverage["soff"] as? Float ?? 0.0), rescue: (homeAverage["blk"] as? Float ?? 0.0), freeKick: (homeAverage["frk"] as? Float ?? 0.0), corner: (homeAverage["cor"] as? Float ?? 0.0), offSide: (homeAverage["off"] as? Float ?? 0.0))
		}
		
		if let awayAverage = data["awayAverageStats"] as? [String : AnyObject] {
			
			self.matchDetailData?.awayTeamAverageStats = BA_MatchStats(pos: (awayAverage["pos"] as? Float ?? 0.0), foul: (awayAverage["fou"] as? Float ?? 0.0), shot: (awayAverage["sot"] as? Float ?? 0.0), shotOnTarget: (awayAverage["son"] as? Float ?? 0.0), missedShot: (awayAverage["soff"] as? Float ?? 0.0), rescue: (awayAverage["blk"] as? Float ?? 0.0), freeKick: (awayAverage["frk"] as? Float ?? 0.0), corner: (awayAverage["cor"] as? Float ?? 0.0), offSide: (awayAverage["off"] as? Float ?? 0.0))
		}
		
		if let matchEvents = data["events"] as? [[String : AnyObject]] {
			
			var matchEventList = [BA_MatchEvents]()
			let homeTeamId = (self.matchDetailData?.homeTeamId)!
			let awayTeamId = (self.matchDetailData?.homeTeamId)!
			
			for matchEvent in matchEvents {
				
				let type = matchEvent["event_type"] as? String ?? ""
				let minute = matchEvent["minute"] as? Int ?? 0
				let playerName = matchEvent["player"] as? String ?? ""
				let playerId = matchEvent["player_sr_id"] as? String ?? ""
				let teamId = matchEvent["team"] as? Int ?? 0
				let substitutionAction = matchEvent["action_type"] as? String ?? "0"
				let substitutionActionInt = Int(substitutionAction)
				
				matchEventList.append(BA_MatchEvents(eventType: type, homeTeamId: homeTeamId, awayTeamId: awayTeamId, eventTeamId: teamId, playerName: playerName, playerSrId: playerId, minute: minute, substitutionAction: substitutionActionInt!))
			}
			
			let matchEventsSorted = matchEventList.sorted { (s1, s2) -> Bool in
				
				if((s1.minute < s2.minute) && s1.substitutionAction == 0 && s2.substitutionAction == 0) {
					
					return true
				}else if((s1.minute < s2.minute) && (s1.substitutionAction < s2.substitutionAction)) {
					
					return true
				}
				
				return false
			}
			
			self.matchDetailData?.matchEvents = matchEventsSorted
		}
		
		if let matchOdds = data["odds"] as? [String : AnyObject] {
			
			if let iddaaOdds = matchOdds["iddaa"] as? [String : AnyObject] {
				
				let result_1 = iddaaOdds["1"] as? Float ?? 0.0
				let result_x = iddaaOdds["X"] as? Float ?? 0.0
				let result_2 = iddaaOdds["2"] as? Float ?? 0.0
				
				let halfTime_1 = iddaaOdds["IY1"] as? Float ?? 0.0
				let halfTime_x = iddaaOdds["IYX"] as? Float ?? 0.0
				let halfTime_2 = iddaaOdds["IY2"] as? Float ?? 0.0
				
				let doubleChance_1_x = iddaaOdds["1X"] as? Float ?? 0.0
				let doubleChance_x_2 = iddaaOdds["X2"] as? Float ?? 0.0
				let doubleChance_1_2 = iddaaOdds["12"] as? Float ?? 0.0
				
				let hand_1 = iddaaOdds["H1"] as? Float ?? 0.0
				let hand_x = iddaaOdds["HX"] as? Float ?? 0.0
				let hand_2 = iddaaOdds["H2"] as? Float ?? 0.0
				
				let bott_15 = iddaaOdds["15Alt"] as? Float ?? 0.0
				let top_15 = iddaaOdds["15Üst"] as? Float ?? 0.0
				
				let bott_25 = iddaaOdds["Alt"] as? Float ?? 0.0
				let top_25 = iddaaOdds["Üst"] as? Float ?? 0.0
				
				let bott_35 = iddaaOdds["35Alt"] as? Float ?? 0.0
				let top_35 = iddaaOdds["35Üst"] as? Float ?? 0.0
				
				let htbott_15 = iddaaOdds["IY15Alt"] as? Float ?? 0.0
				let httop_15 = iddaaOdds["IY15Üst"] as? Float ?? 0.0
				
				let sog01 = iddaaOdds["GSO1"] as? Float ?? 0.0
				let sog23 = iddaaOdds["GS23"] as? Float ?? 0.0
				let sog46 = iddaaOdds["GS46"] as? Float ?? 0.0
				let sog7 = iddaaOdds["GS7P"] as? Float ?? 0.0
				
				let opposingGoalYes = iddaaOdds["KGV"] as? Float ?? 0.0
				let opposingGoalNo = iddaaOdds["KGY"] as? Float ?? 0.0
				
				let iyms_11 = iddaaOdds["SF11"] as? Float ?? 0.0
				let iyms_x1 = iddaaOdds["SFX1"] as? Float ?? 0.0
				let iyms_21 = iddaaOdds["SF21"] as? Float ?? 0.0
				let iyms_1x = iddaaOdds["SF1X"] as? Float ?? 0.0
				let iyms_2x = iddaaOdds["SF2X"] as? Float ?? 0.0
				let iyms_xx = iddaaOdds["SFXX"] as? Float ?? 0.0
				let iyms_22 = iddaaOdds["SF22"] as? Float ?? 0.0
				let iyms_x2 = iddaaOdds["SFX2"] as? Float ?? 0.0
				let iyms_12 = iddaaOdds["SF12"] as? Float ?? 0.0
				
				self.matchDetailData?.odds = BA_MatchOdds(result_1: result_1, result_x: result_x, result_2: result_2, halfTime_1: halfTime_1, halfTime_x: halfTime_x, halfTime_2: halfTime_2, doubleChance_1_x: doubleChance_1_x, doubleChance_x_2: doubleChance_x_2, doubleChance_1_2: doubleChance_1_2, hand_1: hand_1, hand_x: hand_x, hand_2: hand_2, bott_15: bott_15, top_15: top_15, bott_25: bott_25, top_25: top_25, bott_35: bott_35, top_35: top_35, htbott_15: htbott_15, httop_15: httop_15, sog01: sog01, sog23: sog23, sog46: sog46, sog7: sog7, opposingGoalYes: opposingGoalYes, opposingGoalNo: opposingGoalNo, iyms_11: iyms_11, iyms_x1: iyms_x1, iyms_21: iyms_21, iyms_1x: iyms_1x, iyms_2x: iyms_2x, iyms_xx: iyms_xx, iyms_22: iyms_22, iyms_x2: iyms_x2, iyms_12: iyms_12)
			}else{
				
				self.matchDetailData?.odds = BA_MatchOdds(result_1: 0, result_x: 0, result_2: 0, halfTime_1: 0, halfTime_x: 0, halfTime_2: 0, doubleChance_1_x: 0, doubleChance_x_2: 0, doubleChance_1_2: 0, hand_1: 0, hand_x: 0, hand_2: 0, bott_15: 0, top_15: 0, bott_25: 0, top_25: 0, bott_35: 0, top_35: 0, htbott_15: 0, httop_15: 0, sog01: 0, sog23: 0, sog46: 0, sog7: 0, opposingGoalYes: 0, opposingGoalNo: 0, iyms_11: 0, iyms_x1: 0, iyms_21: 0, iyms_1x: 0, iyms_2x: 0, iyms_xx: 0, iyms_22: 0, iyms_x2: 0, iyms_12: 0)
			}
			
		}else{
				
			self.matchDetailData?.odds = BA_MatchOdds(result_1: 0, result_x: 0, result_2: 0, halfTime_1: 0, halfTime_x: 0, halfTime_2: 0, doubleChance_1_x: 0, doubleChance_x_2: 0, doubleChance_1_2: 0, hand_1: 0, hand_x: 0, hand_2: 0, bott_15: 0, top_15: 0, bott_25: 0, top_25: 0, bott_35: 0, top_35: 0, htbott_15: 0, httop_15: 0, sog01: 0, sog23: 0, sog46: 0, sog7: 0, opposingGoalYes: 0, opposingGoalNo: 0, iyms_11: 0, iyms_x1: 0, iyms_21: 0, iyms_1x: 0, iyms_2x: 0, iyms_xx: 0, iyms_22: 0, iyms_x2: 0, iyms_12: 0)
		}
		
		if let matchLineups = data["lineups"] as? [String : AnyObject] {
			
			if let homeTeamLineups = matchLineups["local"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.homeTeamLineups = self.parsePlayerData(lineups: homeTeamLineups)
			}
			
			if let homeTeamSubstitutesLineups = matchLineups["local_substitutes"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.homeTeamSubstitutesLineups = self.parsePlayerData(lineups: homeTeamSubstitutesLineups)
			}
			
			if let awayTeamLineups = matchLineups["visitor"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.awayTeamLineups = self.parsePlayerData(lineups: awayTeamLineups)
			}
			
			if let awayTeamSubstitutesLineups = matchLineups["visitor_substitutes"] as? [[String : AnyObject]] {
				
				self.matchDetailData?.awayTeamSubstitutesLineups = self.parsePlayerData(lineups: awayTeamSubstitutesLineups)
			}
		}
		
		self.loadedMatchDetailApis += 1
		
		BA_Database.SharedInstance.getAllStandingsForLeague(leagueId: leagueId, groupCode: groupCode, handler: { (success, data, errorStr, statusCode) -> Void
			in
		
			if let responseData = data as? [BA_Standings] {
			
				var currentPos = 1
				for currentStandingData in responseData {
					
					if(currentStandingData.teamId == Int64((self.matchDetailData?.homeTeamId) ?? 0)) {
						
						self.matchDetailData?.homeTeamStanding = currentStandingData
						self.matchDetailData?.homeTeamPos = currentPos
					}else if(currentStandingData.teamId == Int64((self.matchDetailData?.awayTeamId) ?? 0)) {
						
						self.matchDetailData?.awayTeamStanding = currentStandingData
						self.matchDetailData?.awayTeamPos = currentPos
					}
					
					currentPos += 1
				}
				
				self.loadedMatchDetailApis += 1
				return
			}
			
			self.loadedMatchDetailApis += 2
		})
		
		BA_Database.SharedInstance.getHomeAwayStandingsForLeague(leagueId: leagueId, groupCode: groupCode, handler: { (success, data, errorStr, statusCode) -> Void
			in
			
			if let responseData = data as? [String : AnyObject] {
				
				let insideData = responseData["inside"] as! [BA_Standings]
				let outsideData = responseData["outside"] as! [BA_Standings]
				
				var insideCurrentPos = 1
				for currentInsideStandingData in insideData {
					
					if(currentInsideStandingData.teamId == Int64((self.matchDetailData?.homeTeamId) ?? 0)) {
						
						self.matchDetailData?.homeTeamInsideStanding = currentInsideStandingData
						self.matchDetailData?.homeTeamInsidePos = insideCurrentPos
					}else if(currentInsideStandingData.teamId == Int64((self.matchDetailData?.awayTeamId) ?? 0)) {
						
						self.matchDetailData?.awayTeamInsideStanding = currentInsideStandingData
						self.matchDetailData?.awayTeamInsidePos = insideCurrentPos
					}
					
					insideCurrentPos += 1
				}
				
				var outsideCurrentPos = 1
				for currentOutsideStandingData in outsideData {
					
					if(currentOutsideStandingData.teamId == Int64((self.matchDetailData?.homeTeamId) ?? 0)) {
						
						self.matchDetailData?.homeTeamOutsideStandings = currentOutsideStandingData
						self.matchDetailData?.homeTeamOutsidePos = outsideCurrentPos
					}else if(currentOutsideStandingData.teamId == Int64((self.matchDetailData?.awayTeamId) ?? 0)) {
						
						self.matchDetailData?.awayTeamOutsideStandings = currentOutsideStandingData
						self.matchDetailData?.awayTeamOutsidePos = outsideCurrentPos
					}
					
					outsideCurrentPos += 1
				}
				
				self.loadedMatchDetailApis += 1
				return
			}
			
			self.loadedMatchDetailApis += 1
		})
        
        if BA_AppDelegate.Ba_LoginData != nil {
            if let favourite = BA_AppDelegate.Ba_LoginData!.favorites?.contains((matchDetailData?.matchId)!) {
                isFavorite = favourite
            } else {
                isFavorite = false
            }
        }
		
		self.checkAllDataLoaded()
	}
	
	private func checkAllDataLoaded() {
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {() -> Void
			in
			
			if(self.loadedMatchDetailApis == 3) {
				
				MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
				self.updatePageVCData()
			}else{
				
				self.checkAllDataLoaded()
			}
		})
	}
	
	private func updatePageVCData() {
		
		if(self.matchDetailDataPP != nil) {
			
			self.matchDetailDataPP!.deinitialize()
			self.matchDetailDataPP!.deallocate(capacity: MemoryLayout<BA_MatchDetailData>.size)
		}
		
		self.matchDetailDataPP = UnsafeMutablePointer<BA_MatchDetailData>.allocate(capacity: MemoryLayout<BA_MatchDetailData>.size)
		self.matchDetailDataPP?.initialize(to: self.matchDetailData!)
		
		self.homeTeamName.text = self.matchDetailData?.homeTeamName
		self.awayTeamName.text = self.matchDetailData?.awayTeamName
		
		self.homeTeamName.isHidden = false
		self.awayTeamName.isHidden = false
		
        let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
        if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
            self.team1Logo.isHidden = !isLogo
            self.team2Logo.isHidden = !isLogo
            self.team1FormContainer.isHidden = isLogo
            self.team2FormContainer.isHidden = isLogo
            
            if isLogo {
                UIImage.getWebImage(imageUrl: (self.matchDetailData?.homeTeamLogoURLString)!) { (responseImage) in
                    
                    self.team1Logo.image = responseImage
                }
                UIImage.getWebImage(imageUrl: (self.matchDetailData?.awayTeamLogoURLString)!) { (responseImage) in
                    
                    self.team2Logo.image = responseImage
                }
            }
            
        } else {
            self.team1Logo.isHidden = true
            self.team2Logo.isHidden = true
            self.team1FormContainer.isHidden = false
            self.team2FormContainer.isHidden = false
        }
        
		#if os(iOS)
		self.team1FormLeft.tintColor = self.matchDetailData?.homeTeamUIColor1
		self.team1FormRight.tintColor = self.matchDetailData?.homeTeamUIColor2
		self.team2FormLeft.tintColor = self.matchDetailData?.awayTeamUIColor1
		self.team2FormRight.tintColor = self.matchDetailData?.awayTeamUIColor2
		
		self.team1FormLeft.isHidden = false
		self.team1FormRight.isHidden = false
		self.team2FormLeft.isHidden = false
		self.team2FormRight.isHidden = false
			
		self.team1FormLeftBorder.isHidden = false
		self.team1FormRightBorder.isHidden = false
		self.team2FormLeftBorder.isHidden = false
		self.team2FormRightBorder.isHidden = false
		#endif
		
		self.leagueNameTitle.text = self.matchDetailData?.leagueName
		self.leagueNameTitle.isHidden = false
		
		if((self.matchDetailData?.isPlayed)!) {
			
            self.matchResultLabel.text = "\((self.matchDetailData?.homeGoals)!)   :   \((self.matchDetailData?.awayGoals)!)"
            self.currentMinuteLabel.text = "MS"
            self.timeProgressView.angle = 360
            self.firsttimeResult.isHidden = false
            if let halfAway = self.matchDetailData?.halfTimeAwayGoals, let halfHome = self.matchDetailData?.halfTimeHomeGoals {
                self.firsttimeResult.text = "\(halfHome)  :  \(halfAway)"
            } else {
                self.firsttimeResult.text = "0  :  0"
            }
            
            self.playingView.isHidden = false
			
		} else if((self.matchDetailData?.isPlaying)!) {
			
            self.matchResultLabel.text = "\((self.matchDetailData?.homeGoals)!)   :   \((self.matchDetailData?.awayGoals)!)"
            self.currentMinuteLabel.text = "\((self.matchDetailData?.liveMinute)!)'"
            
            self.timeProgressView.angle = (Double((self.matchDetailData?.liveMinute)!) / 90) * 360
            
            self.firsttimeResult.isHidden = (self.matchDetailData?.liveMinute)! < 46
            
            if let halfAway = self.matchDetailData?.halfTimeAwayGoals, let halfHome = self.matchDetailData?.halfTimeHomeGoals {
                self.firsttimeResult.text = "\(halfHome)  :  \(halfAway)"
            } else {
                self.firsttimeResult.text = "0  :  0"
            }
            
			self.playingView.isHidden = false
		}else{
			
			self.timerSetted = true
			self.willPlayingViewTimeLeft.text = ""
			self.willPlayingView.isHidden = false
            
			self.setupMatchTimeLeft()
		}
        
        fillLastGames()
        updateFavoritesButton()
		
		self.updateCollectionViewData()
	}
	
	private func setupMatchTimeLeft() {
		
		guard self.timerSetted || self.matchDetailData?.matchDate != nil else {
			
			return
		}
		
		let timeLeftVal = Int(((self.matchDetailData?.matchDate)!).timeIntervalSince1970 - Date().timeIntervalSince1970)
		let timeLeftStr = IO_Helpers.getTimeAgoString(dateDiff: timeLeftVal)
		
		let timeLeftDays = timeLeftStr["days"]!
		let timeLeftHours = (timeLeftStr["hours"]! < 10) ? "0\(timeLeftStr["hours"]!)" : "\(timeLeftStr["hours"]!)"
		let timeLeftMinutes = (timeLeftStr["minutes"]! < 10) ? "0\(timeLeftStr["minutes"]!)" : "\(timeLeftStr["minutes"]!)"
        let timeLeftSeconds = (timeLeftStr["seconds"]! < 10) ? "0\(timeLeftStr["seconds"]!)" : "\(timeLeftStr["seconds"]!)"
		
		if(timeLeftDays > 0) {
			
			self.willPlayingViewTimeLeft.text = "\(timeLeftDays) gün \(timeLeftHours) saat"
			
		}else{
			
			self.willPlayingViewTimeLeft.text = "\(timeLeftHours):\(timeLeftMinutes):\(timeLeftSeconds)"
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {() -> Void
				in
				
				self.setupMatchTimeLeft()
			})
		}
	}
    
    private func updateFavoritesButton() {
        let title = isFavorite ? String.fontAwesomeIcon(name: .star) : String.fontAwesomeIcon(name: .starO)
        favoriteButton.setTitle(title, for: .normal)
    }
    
    private func fillLastGames() {
        for view in team1LastMatchesView.subviews {
            view.removeFromSuperview()
        }
        for view in team2LastMatchesView.subviews {
            view.removeFromSuperview()
        }
    
        if let matches = self.matchDetailData?.homeTeamLastMatches {
            
            var startPoint = 0.0
            
            for match in matches {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 10.0)
                label.textAlignment = .center
                let viewSize = 13.0
                let cornerRadius = viewSize / 2
                label.layer.cornerRadius = CGFloat(cornerRadius)
                label.layer.masksToBounds = true
                
                label.frame = CGRect(x: startPoint, y: 0.0, width: viewSize, height: viewSize)
                
                let baseTeamHomeGoals: Int
                let baseTeamAwayGoals: Int
                
                if(matchDetailData?.homeTeamName == match.homeTeam.teamName) {
                    
                    baseTeamHomeGoals = match.homeGoals
                    baseTeamAwayGoals = match.awayGoals
                }else{
                    
                    baseTeamAwayGoals = match.homeGoals
                    baseTeamHomeGoals = match.awayGoals
                }
                
                if baseTeamHomeGoals > baseTeamAwayGoals{
                    label.backgroundColor = UIColor.init(colorLiteralRed: 42.0/255.0, green: 182.0/255.0, blue: 49.0/255.0, alpha: 1.0)
                    label.text = "G"
                } else if baseTeamHomeGoals < baseTeamAwayGoals {
                    label.backgroundColor = UIColor.init(colorLiteralRed: 217.0/255.0, green: 44.0/255.0, blue: 46.0/255.0, alpha: 1.0)
                    label.text = "M"
                } else {
                    label.backgroundColor = UIColor.init(colorLiteralRed: 225.0/255.0, green: 219.0/255.0, blue: 83.0/255.0, alpha: 1.0)
                    label.text = "B"
                }
                
                self.team1LastMatchesView.addSubview(label)
                
                startPoint += 15.0
            }
        }
        
        if let matches = self.matchDetailData?.awayTeamLastMatches {
            
            var startPoint = 0.0
            
            for match in matches {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 10.0)
                label.textAlignment = .center
                let viewSize = 13.0
                let cornerRadius = viewSize / 2
                label.layer.cornerRadius = CGFloat(cornerRadius)
                label.layer.masksToBounds = true
                
                label.frame = CGRect(x: startPoint, y: 0.0, width: viewSize, height: viewSize)
                
                let baseTeamHomeGoals: Int
                let baseTeamAwayGoals: Int
                
                if(matchDetailData?.awayTeamName == match.homeTeam.teamName) {
                    
                    baseTeamHomeGoals = match.homeGoals
                    baseTeamAwayGoals = match.awayGoals
                }else{
                    
                    baseTeamAwayGoals = match.homeGoals
                    baseTeamHomeGoals = match.awayGoals
                }
                
                if baseTeamHomeGoals > baseTeamAwayGoals{
                    label.backgroundColor = UIColor.init(colorLiteralRed: 49.0/255.0, green: 162.0/255.0, blue: 84.0/255.0, alpha: 1.0)
                    label.text = "G"
                } else if baseTeamHomeGoals < baseTeamAwayGoals {
                    label.backgroundColor = UIColor.init(colorLiteralRed: 210.0/255.0, green: 47.0/255.0, blue: 49.0/255.0, alpha: 1.0)
                    label.text = "M"
                } else {
                    label.backgroundColor = UIColor.init(colorLiteralRed: 201.0/255.0, green: 211.0/255.0, blue: 102.0/255.0, alpha: 1.0)
                    label.text = "B"
                }
                
                self.team2LastMatchesView.addSubview(label)
                
                startPoint += 15.0
            }
        }
        
    }
	
	// MARK: Collection view
	private func updateCollectionViewData() {
		
		// MARK: Matches
		let homeTeamName = self.matchDetailData?.homeTeamName ?? ""
		
		let homeTeamLastMatchesCount = self.matchDetailData?.homeTeamLastMatches?.count ?? 0
		let homeTeamLastMatchesCellHeights = [CGFloat](repeating: 40, count: homeTeamLastMatchesCount)
		
		let homeTeamHomeMatchesCount = self.matchDetailData?.homeTeamHomeMatches?.count ?? 0
		let homeTeamHomeMatchesCellHeights = [CGFloat](repeating: 40, count: homeTeamHomeMatchesCount)
		
		let homeTeamAwayMatchesCount = self.matchDetailData?.homeTeamAwayMatches?.count ?? 0
		let homeTeamAwayMatchesCellHeights = [CGFloat](repeating: 40, count: homeTeamAwayMatchesCount)
		
		let headToHeadMatchesCount = self.matchDetailData?.headToHeadMatches?.count ?? 0
		let headToHeadMatchesCellHeights = [CGFloat](repeating: 40, count: headToHeadMatchesCount)
		
		let awayTeamName = self.matchDetailData?.awayTeamName ?? ""
		
		let awayTeamLastMatchesCount = self.matchDetailData?.awayTeamLastMatches?.count ?? 0
		let awayTeamLastMatchesCellHeights = [CGFloat](repeating: 40, count: awayTeamLastMatchesCount)
		
		let awayTeamHomeMatchesCount = self.matchDetailData?.awayTeamHomeMatches?.count ?? 0
		let awayTeamHomeMatchesCellHeights = [CGFloat](repeating: 40, count: awayTeamHomeMatchesCount)
		
		let awayTeamAwayMatchesCount = self.matchDetailData?.awayTeamAwayMatches?.count ?? 0
		let awayTeamAwayMatchesCellHeights = [CGFloat](repeating: 40, count: awayTeamAwayMatchesCount)
		
		// MARK: Stats
		let hasGameStats: Bool
		let forecastCellRowCount: Int
		if((self.matchDetailData?.isPlayed)! || (self.matchDetailData?.isPlaying)!) {
			
			hasGameStats = true
			forecastCellRowCount = 0
		}else{
			
			hasGameStats = false
			
			if(!BA_Database.SharedInstance.isMatchCommented(matchId: (self.matchDetailData?.matchId)!)) {
				forecastCellRowCount = 1
			}else{
				forecastCellRowCount = 0
			}
		}
		
		var goalsCellCount = 0
		var goalsCellHeights = [CGFloat]()
		var goalsCellNames = [String]()
		
		var asistsCellCount = 0
		var asistsCellHeights = [CGFloat]()
		var asistsCellNames = [String]()
		
		var cardsCellCount = 0
		var cardsCellHeights = [CGFloat]()
		var cardsCellNames = [String]()
		
		var substituonCellCount = 0
		var substituonCellHeights = [CGFloat]()
		var substituonCellNames = [String]()
		
		if let matchEvents = self.matchDetailData?.matchEvents {
			
			for matchEvent in matchEvents {
				
				if(matchEvent.type == .Goal) {
					
					goalsCellCount += 1
					goalsCellHeights.append(33)
					
					if(matchEvent.team == .Home) {
						
						goalsCellNames.append("HomeTeamGoalCell")
					}else{
						
						goalsCellNames.append("AwayTeamGoalCell")
					}
					
				}else if(matchEvent.type == .Asist) {
					
					asistsCellCount += 1
					asistsCellHeights.append(33)
					
					if(matchEvent.team == .Home) {
						
						asistsCellNames.append("HomeTeamAsistsCell")
					}else{
						
						asistsCellNames.append("AwayTeamAsistsCell")
					}
					
				}else if(matchEvent.type == .YellowCard || matchEvent.type == .RedCard) {
					
					cardsCellCount += 1
					cardsCellHeights.append(33)
					
					if(matchEvent.team == .Home) {
						
						cardsCellNames.append("HomeTeamCardCell")
					}else{
						
						cardsCellNames.append("AwayTeamACardCell")
					}
					
				}else if(matchEvent.type == .Substitution && matchEvent.substitutionAction == 18) {
					
					substituonCellCount += 1
					substituonCellHeights.append(40)
					
					if(matchEvent.team == .Home) {
						
						substituonCellNames.append("HomeTeamReplacementCell")
					}else{
						
						substituonCellNames.append("AwayTeamReplacementCell")
					}
				}
			}
			
		}else{
			
			goalsCellHeights.append(32)
			goalsCellNames.append("NoDataCell")
			goalsCellCount = 1
			
			asistsCellHeights.append(32)
			asistsCellNames.append("NoDataCell")
			asistsCellCount = 1
			
			cardsCellHeights.append(32)
			cardsCellNames.append("NoDataCell")
			cardsCellCount = 1
			
			substituonCellHeights.append(32)
			substituonCellNames.append("NoDataCell")
			substituonCellCount = 1
		}
		
		if(goalsCellCount == 0) {
			
			goalsCellHeights.append(32)
			goalsCellNames.append("NoDataCell")
			goalsCellCount = 1
		}
		
		if(asistsCellCount == 0) {
			
			asistsCellHeights.append(32)
			asistsCellNames.append("NoDataCell")
			asistsCellCount = 1
		}
		
		if(cardsCellCount == 0) {
			
			cardsCellHeights.append(32)
			cardsCellNames.append("NoDataCell")
			cardsCellCount = 1
		}
		
		if(substituonCellCount == 0) {
			
			substituonCellHeights.append(32)
			substituonCellNames.append("NoDataCell")
			substituonCellCount = 1
		}
		
		var homeTeamLineupsCellCount = 0
		var homeTeamLineupsCellHeight = [CGFloat]()
		var homeTeamLineupsCellNames = [String]()
		if(self.matchDetailData?.homeTeamLineups != nil) {
			
			homeTeamLineupsCellCount = (self.matchDetailData?.homeTeamLineups?.count)!
			homeTeamLineupsCellHeight = [CGFloat](repeating: 38, count: (self.matchDetailData?.homeTeamLineups?.count)!)
			homeTeamLineupsCellNames = [String](repeating: "LineupsCell", count: (self.matchDetailData?.homeTeamLineups?.count)!)
		}
		
		var homeTeamSubstitutesLineupsCellCount = 0
		var homeTeamSubstitutesLineupsCellHeight = [CGFloat]()
		var homeTeamSubstitutesLineupsCellNames = [String]()
		if(self.matchDetailData?.homeTeamSubstitutesLineups != nil) {
			
			homeTeamSubstitutesLineupsCellCount = (self.matchDetailData?.homeTeamSubstitutesLineups?.count)!
			homeTeamSubstitutesLineupsCellHeight = [CGFloat](repeating: 38, count: (self.matchDetailData?.homeTeamSubstitutesLineups?.count)!)
			homeTeamSubstitutesLineupsCellNames = [String](repeating: "LineupsCell", count: (self.matchDetailData?.homeTeamSubstitutesLineups?.count)!)
		}
		
		var awayTeamLineupsCellCount = 0
		var awayTeamLineupsCellHeight = [CGFloat]()
		var awayTeamLineupsCellNames = [String]()
		if(self.matchDetailData?.awayTeamLineups != nil) {
			
			awayTeamLineupsCellCount = (self.matchDetailData?.awayTeamLineups?.count)!
			awayTeamLineupsCellHeight = [CGFloat](repeating: 38, count: (self.matchDetailData?.awayTeamLineups?.count)!)
			awayTeamLineupsCellNames = [String](repeating: "LineupsCell", count: (self.matchDetailData?.awayTeamLineups?.count)!)
		}
		
		var awayTeamSubstitutesLineupsCellCount = 0
		var awayTeamSubstitutesLineupsCellHeight = [CGFloat]()
		var awayTeamSubstitutesLineupsCellNames = [String]()
		if(self.matchDetailData?.awayTeamSubstitutesLineups != nil) {
			
			awayTeamSubstitutesLineupsCellCount = (self.matchDetailData?.awayTeamSubstitutesLineups?.count)!
			awayTeamSubstitutesLineupsCellHeight = [CGFloat](repeating: 38, count: (self.matchDetailData?.awayTeamSubstitutesLineups?.count)!)
			awayTeamSubstitutesLineupsCellNames = [String](repeating: "LineupsCell", count: (self.matchDetailData?.awayTeamSubstitutesLineups?.count)!)
		}
		
		/*
		* For updating cell data following methods must be updated
		* addForecastSection(data: [[String : AnyObject]])
		* collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
		* cellForItemAt (case 2 3 4)
		* matchDetailSegmentChanged(selectedIdx: Int, section: Int)
		* pointsCellTabBtnTapped(tabType: BA_PointsCellCollectionViewCell.CellTypes)
		* createForecastBtnSendTapped
		*/
		self.cellData = [
			
			// MARK: Index Tab
			//BA_MatchDetailIndexCellData(cellHeights: [153], cellId: ["StadiumCell"], hasResuableHeader: false, resuableTitle: "", hasResuableFooter: false, rowCount: 1, isVisible: true),
			BA_MatchDetailIndexCellData(cellHeights: [34], cellId: ["WhoWinsCell"], hasResuableHeader: true, resuableTitle: "Kim Kazanır?", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.INDEX), isVisible: false),
			BA_MatchDetailIndexCellData(cellHeights: [116], cellId: ["WhoWinsResultCell"], hasResuableHeader: true, resuableTitle: "Kim Kazanır?", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.INDEX), isVisible: false),
			BA_MatchDetailIndexCellData(cellHeights: [116], cellId: ["PointsCell"], hasResuableHeader: true, resuableTitle: "Puan Durumu", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.INDEX), isVisible: true),
			BA_MatchDetailIndexCellData(cellHeights: [116], cellId: ["PointsCell"], hasResuableHeader: true, resuableTitle: "Puan Durumu", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.INDEX), isVisible: false),
			BA_MatchDetailIndexCellData(cellHeights: [116], cellId: ["PointsCell"], hasResuableHeader: true, resuableTitle: "Puan Durumu", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.INDEX), isVisible: false),
			BA_MatchDetailIndexCellData(cellHeights: [116], cellId: ["GoalsCell"], hasResuableHeader: true, resuableTitle: "Gol Ortalamaları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.INDEX), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [46], cellId: ["NewForecastsCell"], hasResuableHeader: true, resuableTitle: "Tahmin Ligi", hasResuableFooter: false, rowCount: forecastCellRowCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.INDEX), isVisible: true),
			
			// MARK: Matches Tab
			BA_MatchDetailIndexCellData(cellHeights: [80], cellId: ["matchDetailSegmentCell"], hasResuableHeader: false, resuableTitle: "", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: homeTeamHomeMatchesCellHeights, cellId: ["MatchRowCell"], hasResuableHeader: true, resuableTitle: "\(homeTeamName) Evindeki Son 5 Maç", hasResuableFooter: false, rowCount: homeTeamHomeMatchesCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), isVisible: true),
			BA_MatchDetailIndexCellData(cellHeights: homeTeamLastMatchesCellHeights, cellId: ["MatchRowCell"], hasResuableHeader: true, resuableTitle: "\(homeTeamName) Son 5 Maç", hasResuableFooter: false, rowCount: homeTeamLastMatchesCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), isVisible: true),
			BA_MatchDetailIndexCellData(cellHeights: homeTeamAwayMatchesCellHeights, cellId: ["MatchRowCell"], hasResuableHeader: true, resuableTitle: "\(homeTeamName) Deplasmandaki Son 5 Maç", hasResuableFooter: false, rowCount: homeTeamAwayMatchesCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: headToHeadMatchesCellHeights, cellId: ["MatchRowCell"], hasResuableHeader: true, resuableTitle: "Karşılıklı Maçlar", hasResuableFooter: false, rowCount: headToHeadMatchesCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), isVisible: false),
			
			BA_MatchDetailIndexCellData(cellHeights: awayTeamAwayMatchesCellHeights, cellId: ["MatchRowCell"], hasResuableHeader: true, resuableTitle: "\(awayTeamName) Deplasmandaki Son 5 Maç", hasResuableFooter: false, rowCount: awayTeamAwayMatchesCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), isVisible: false),
			BA_MatchDetailIndexCellData(cellHeights: awayTeamLastMatchesCellHeights, cellId: ["MatchRowCell"], hasResuableHeader: true, resuableTitle: "\(awayTeamName) Son 5 Maç", hasResuableFooter: false, rowCount: awayTeamLastMatchesCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), isVisible: false),
			BA_MatchDetailIndexCellData(cellHeights: awayTeamHomeMatchesCellHeights, cellId: ["MatchRowCell"], hasResuableHeader: true, resuableTitle: "\(awayTeamName) Evindeki Son 5 Maç", hasResuableFooter: false, rowCount: awayTeamHomeMatchesCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), isVisible: false),
			
			
			// MARK: Stats Tab
			BA_MatchDetailIndexCellData(cellHeights: [52], cellId: ["matchDetailSegmentCell"], hasResuableHeader: false, resuableTitle: "", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [457], cellId: ["GeneralStatsCell"], hasResuableHeader: false, resuableTitle: "Ortalama Sezon İstatistikleri", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), isVisible: !hasGameStats),
			
			BA_MatchDetailIndexCellData(cellHeights: [156], cellId: ["BallControlCell"], hasResuableHeader: false, resuableTitle: "", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), isVisible: hasGameStats),
			
			BA_MatchDetailIndexCellData(cellHeights: goalsCellHeights, cellId: goalsCellNames, hasResuableHeader: true, resuableTitle: "Goller", hasResuableFooter: false, rowCount: goalsCellCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), isVisible: hasGameStats),
			
			BA_MatchDetailIndexCellData(cellHeights: asistsCellHeights, cellId: asistsCellNames, hasResuableHeader: true, resuableTitle: "Asist", hasResuableFooter: false, rowCount: asistsCellCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), isVisible: hasGameStats),
			
			BA_MatchDetailIndexCellData(cellHeights: cardsCellHeights, cellId: cardsCellNames, hasResuableHeader: true, resuableTitle: "Kartlar", hasResuableFooter: false, rowCount: cardsCellCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), isVisible: hasGameStats),
			
			BA_MatchDetailIndexCellData(cellHeights: substituonCellHeights, cellId: substituonCellNames, hasResuableHeader: true, resuableTitle: "Oyuncu Değişiklikleri", hasResuableFooter: false, rowCount: substituonCellCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), isVisible: hasGameStats),
			
			BA_MatchDetailIndexCellData(cellHeights: [250], cellId: ["MatchStatsCell"], hasResuableHeader: true, resuableTitle: "Maç İstatistikleri", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), isVisible: hasGameStats),
			
			// MARK: Odds Tab
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsTrioCell"], hasResuableHeader: true, resuableTitle: "Maç Sonu İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsTrioCell"], hasResuableHeader: true, resuableTitle: "İlk Yarı İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsTrioCell"], hasResuableHeader: true, resuableTitle: "Çifte Şans İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsTrioCell"], hasResuableHeader: true, resuableTitle: "Handikap İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsDualCell"], hasResuableHeader: true, resuableTitle: "1.5 Alt Üst İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsDualCell"], hasResuableHeader: true, resuableTitle: "2.5 Alt Üst İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsDualCell"], hasResuableHeader: true, resuableTitle: "3.5 Alt Üst İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsDualCell"], hasResuableHeader: true, resuableTitle: "İlk Yarı 1.5 Alt Üst İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsDualCell"], hasResuableHeader: true, resuableTitle: "Karş. Gol İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: [104], cellId: ["OddsQuartCell"], hasResuableHeader: true, resuableTitle: "Toplam Gol İddaa Oranları", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS), isVisible: true),
			
			// MARK: Lineups
			BA_MatchDetailIndexCellData(cellHeights: [46], cellId: ["matchDetailSegmentCell"], hasResuableHeader: false, resuableTitle: "", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: homeTeamLineupsCellHeight, cellId: homeTeamLineupsCellNames, hasResuableHeader: true, resuableTitle: "Kadrolar", hasResuableFooter: false, rowCount: homeTeamLineupsCellCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS), isVisible: true),
			
			BA_MatchDetailIndexCellData(cellHeights: homeTeamSubstitutesLineupsCellHeight, cellId: homeTeamSubstitutesLineupsCellNames, hasResuableHeader: true, resuableTitle: "Yedekler", hasResuableFooter: false, rowCount: homeTeamSubstitutesLineupsCellCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS), isVisible: true),
		
			BA_MatchDetailIndexCellData(cellHeights: awayTeamLineupsCellHeight, cellId: awayTeamLineupsCellNames, hasResuableHeader: true, resuableTitle: "Kadrolar", hasResuableFooter: false, rowCount: awayTeamLineupsCellCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS), isVisible: false),
			
			BA_MatchDetailIndexCellData(cellHeights: awayTeamSubstitutesLineupsCellHeight, cellId: awayTeamSubstitutesLineupsCellNames, hasResuableHeader: true, resuableTitle: "Yedekler", hasResuableFooter: false, rowCount: awayTeamSubstitutesLineupsCellCount, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS), isVisible: false),
			
			BA_MatchDetailIndexCellData(cellHeights: [804], cellId: ["CreateForecastsCell"], hasResuableHeader: true, resuableTitle: "Senin Tahminin", hasResuableFooter: false, rowCount: 1, tabIdx: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.CREATE_FORECAST), isVisible: true)
		]
		
		if(self.matchDetailData != nil) {
			
			self.forecastDataIsDownloading = false
			
//			if(BA_Database.SharedInstance.isMatchVoted(matchId: (self.matchDetailData?.matchId)!) || (self.matchDetailData?.isPlayed)!) {
//				
				self.cellData[1].isVisible = true
//			}else{
//				
//				self.cellData[0].isVisible = true
//			}
			
			if(self.matchDetailData?.homeTeamStanding == nil || self.matchDetailData?.awayTeamStanding == nil) {
				
				self.cellData[2].isVisible = false
			}
		}
		
		self.matchDetailMenuPP?.pointee.setSelectedTab(tabIdx: self.currentSelectedMenu)
		self.invalidateLayout()
		self.collectionView.reloadData()
		self.loadMatchForecasts()
	}
	
	private func invalidateLayout() {
		
		if let matchDetailLayout = self.collectionView?.collectionViewLayout as? BA_MatchDetailIndexLayout {
			
			matchDetailLayout.prepareLayout(insetTop: self.headerViewInitialHeightCGF, cellData: self.cellData, currentTab: self.currentSelectedMenu)
			matchDetailLayout.invalidateLayout()
		}
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		guard self.matchDetailData != nil else {
			return 0
		}
		
		guard self.cellData != nil else {
			return 0
		}

		var sectionCount = 0
		for currentCellData in self.cellData {
			
			if(currentCellData.tabIdx == self.currentSelectedMenu) {
				
				sectionCount += 1
			}
		}
		
		return sectionCount
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		var realSectionNumber = 0
		for currentCellData in self.cellData {
			
			if(currentCellData.tabIdx != self.currentSelectedMenu) {
				
				realSectionNumber += 1
			}else{
				
				break
			}
		}
		
		let currentSectionNumber = section + realSectionNumber
		return self.cellData[currentSectionNumber].rowCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		var realSectionNumber = 0
		for currentCellData in self.cellData {
			
			if(currentCellData.tabIdx != self.currentSelectedMenu) {
				
				realSectionNumber += 1
			}else{
				
				break
			}
		}
		
		let currentSectionNumber = realSectionNumber + indexPath.section
		switch currentSectionNumber {
			// MARK: Match Detail Index Tab
			/*
			Stadium cell
			case 0:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailStadiumCollectionViewCell
			cell.setupCell(matchDetailData: self.matchDetailData)
			return cell
			*/
		case 0:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailWhoWinsCollectionViewCell
			cell.setupCell(delegate: self)
			return cell
			
		case 1:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_WhoWinsResultCollectionViewCell
            cell.setupCell(matchDetailData: self.matchDetailDataPP, isVoted: BA_Database.SharedInstance.isMatchVoted(matchId: (self.matchDetailData?.matchId)!) || isWhoWinsVoting, delegate: self)
			
			if(self.isWhoWinsVoting) {
				cell.calculateVotes(voteTeam: self.whoWinsVoteValue!)
				
				self.isWhoWinsVoting = false
				self.whoWinsVoteValue = nil
			}
			return cell
			
		case 2, 3, 4:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_PointsCellCollectionViewCell
			
			if(currentSectionNumber == 2) {
				
				cell.setupCell(cellType: BA_PointsCellCollectionViewCell.CellTypes.GENERAL, matchDetailData: self.matchDetailDataPP, delegate: self)
				
			} else if(currentSectionNumber == 3) {
				
				cell.setupCell(cellType: BA_PointsCellCollectionViewCell.CellTypes.INSIDE, matchDetailData: self.matchDetailDataPP, delegate: self)
				
			} else if(currentSectionNumber == 4) {
				
				cell.setupCell(cellType: BA_PointsCellCollectionViewCell.CellTypes.OUTSIDE, matchDetailData: self.matchDetailDataPP, delegate: self)
				
			}
			return cell
			
		case 5:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_GoalsCollectionViewCell
			cell.setupCell(matchDetailData: self.matchDetailDataPP)
			return cell
			
		case 6:
			
			let cellId = (self.cellData[currentSectionNumber].cellId)[indexPath.item]
			
			if(cellId == "ForecastsCell") {
				
				if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? BA_ForecastsCollectionViewCell {
					
					cell.setupCell(forecastData: self.forecastsData![indexPath.item], delegate: self)
					return cell
				}else{
					return UICollectionViewCell()
				}
				
			}else if(cellId == "NewForecastsCell") {
				
				if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? BA_MatchDetailNewForecastCollectionViewCell {
					
					cell.setupCell(delegate: self)
					return cell
				}else{
					return UICollectionViewCell()
				}
			}else{
				
				let error = NSError(domain: "ForecastsCellError", code: 1, userInfo: [NSLocalizedDescriptionKey: "cellForItemAt case 6 cell is is \(cellId)"])
				Crashlytics.sharedInstance().recordError(error as Error)
				return UICollectionViewCell()
			}
		
		// MARK: Match Detail Matches Tab
		case 7:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailSegmentCollectionViewCell
			
			let currentSegmentTexts: [String] = [
				(self.matchDetailData?.homeTeamName)!,
				"Karşılıklı",
				(self.matchDetailData?.awayTeamName)!
			]
			
			if(self.currentMatchesTab == nil) {
				
				currentMatchesTab = 0
			}
			
//			cell.setupCell(segmentCount: 3, segmentTexts: currentSegmentTexts, selectedIdx: self.currentMatchesTab!, segmentsEnabled: [true, true, true], section: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), delegate: self)
            let homeTeam = BA_Team.init(teamName: (matchDetailData?.homeTeamName)!, teamId: (matchDetailData?.homeTeamId)!, color1: (matchDetailData?.homeTeamColor1)!, color2: (matchDetailData?.homeTeamColor2)!)
            let awayTeam = BA_Team.init(teamName: (matchDetailData?.awayTeamName)!, teamId: (matchDetailData?.awayTeamId)!, color1: (matchDetailData?.awayTeamColor1)!, color2: (matchDetailData?.awayTeamColor2)!)
            cell.setupCell(homeTeam: homeTeam, awayTeam: awayTeam, selectedIdx: self.currentMatchesTab!, section: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES), delegate: self)
			return cell
		case 8:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_MatchDetailMatchesCollectionViewCell
            let matchData = self.matchDetailData?.homeTeamHomeMatches?[indexPath.item]
			cell.setupCell(matchData: matchData!, baseTeam: 0, baseTeamName: (self.matchDetailData?.homeTeamName ?? ""))
			return cell
			
		case 9:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_MatchDetailMatchesCollectionViewCell
			let matchData = self.matchDetailData?.homeTeamLastMatches?[indexPath.item]
			cell.setupCell(matchData: matchData!, baseTeam: 0, baseTeamName: (self.matchDetailData?.homeTeamName ?? ""))
			return cell
			
		case 10:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_MatchDetailMatchesCollectionViewCell
			let matchData = self.matchDetailData?.homeTeamAwayMatches?[indexPath.item]
			cell.setupCell(matchData: matchData!, baseTeam: 0, baseTeamName: (self.matchDetailData?.homeTeamName ?? ""))
			return cell
			
		case 11:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_MatchDetailMatchesCollectionViewCell
			let matchData = self.matchDetailData?.headToHeadMatches?[indexPath.item]
			cell.setupCell(matchData: matchData!, baseTeam: 1, baseTeamName: "")
			return cell
			
		case 12:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_MatchDetailMatchesCollectionViewCell
            let matchData = self.matchDetailData?.awayTeamAwayMatches?[indexPath.item]
			cell.setupCell(matchData: matchData!, baseTeam: 2, baseTeamName: (self.matchDetailData?.awayTeamName ?? ""))
			return cell
			
		case 13:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_MatchDetailMatchesCollectionViewCell
            let matchData = self.matchDetailData?.awayTeamLastMatches?[indexPath.item]
			cell.layer.shouldRasterize = true
			cell.layer.rasterizationScale = UIScreen.main.scale
			cell.setupCell(matchData: matchData!, baseTeam: 2, baseTeamName: (self.matchDetailData?.awayTeamName ?? ""))
			return cell
			
		case 14:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_MatchDetailMatchesCollectionViewCell
			let matchData = self.matchDetailData?.awayTeamHomeMatches?[indexPath.item]
			cell.setupCell(matchData: matchData!, baseTeam: 2, baseTeamName: (self.matchDetailData?.awayTeamName ?? ""))
			return cell
			
		// MARK: Match Detail Stats Tab
		case 15:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailSegmentCollectionViewCell
			
			let currentSegmentTexts: [String] = [
				"Maç İstatistikleri",
				"Sezon İstatistikleri"
			]
			
			if(self.currentSelectedStatsTab == nil) {
				
				if((matchDetailData?.isPlayed)! || (matchDetailData?.isPlaying)!) {
					
					self.currentSelectedStatsTab = 0
				}else{
					self.currentSelectedStatsTab = 1
				}
			}
			
			cell.setupCell(segmentCount: 2, segmentTexts: currentSegmentTexts, selectedIdx: self.currentSelectedStatsTab!, segmentsEnabled: [true, true], section: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS), delegate: self)
			return cell
			
		case 16:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_AverageStatsCollectionViewCell
			cell.setupCell(matchDetailData: self.matchDetailDataPP)
			return cell
			
		case 17:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[0], for: indexPath) as! BA_BallControlCollectionViewCell
			cell.setupCell(matchDetailData: self.matchDetailDataPP)
			return cell
			
		case 18:
			
			// TODO: UPDATE Events Player
			let cellId = (self.cellData[currentSectionNumber].cellId)[indexPath.item]
			
			if(cellId == "NoDataCell") {
				
				return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
			}else{
				
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BA_MatcEventsCollectionViewCell
				cell.setupCell(matchDetailData: self.matchDetailDataPP, eventIdx: indexPath.item, eventType: BA_MatchEvents.EventTypes.Goal)
				
				return cell
			}
			
		case 19:
			
			// TODO: UPDATE Events Player
			let cellId = (self.cellData[currentSectionNumber].cellId)[indexPath.item]
			
			if(cellId == "NoDataCell") {
				
				return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
			}else{
				
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BA_MatcEventsCollectionViewCell
				cell.setupCell(matchDetailData: self.matchDetailDataPP, eventIdx: indexPath.item, eventType: BA_MatchEvents.EventTypes.Asist)
				
				return cell
			}
			
		case 20:
			
			// TODO: UPDATE Events Player
			let cellId = (self.cellData[currentSectionNumber].cellId)[indexPath.item]
			
			if(cellId == "NoDataCell") {
				
				return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
			}else{
				
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BA_MatcEventsCollectionViewCell
				cell.setupCell(matchDetailData: self.matchDetailDataPP, eventIdx: indexPath.item, eventType: BA_MatchEvents.EventTypes.YellowCard)
				
				return cell
			}
			
		case 21:
			
			// TODO: UPDATE Events Player
			let cellId = (self.cellData[currentSectionNumber].cellId)[indexPath.item]
			
			if(cellId == "NoDataCell") {
				
				return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
			}else{
				
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BA_MatcEventsCollectionViewCell
				cell.setupCell(matchDetailData: self.matchDetailDataPP, eventIdx: indexPath.item, eventType: BA_MatchEvents.EventTypes.Substitution)
				
				return cell
			}
			
		case 22:
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchStatsCollectionViewCell
			cell.setupCell(matchDetailData: self.matchDetailDataPP)
			
			return cell
			
		// MARK: Odds Tab
		case 23:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.TRIO, names: ["1", "X", "2"], data: [matchOdds.result_1, matchOdds.result_x, matchOdds.result_2])
			return cell
			
		case 24:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.TRIO, names: ["1", "X", "2"], data: [matchOdds.halfTime_1, matchOdds.halfTime_x, matchOdds.halfTime_2])
			return cell
			
		case 25:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.TRIO, names: ["1-X", "X-2", "1-2"], data: [matchOdds.doubleChance_1_x, matchOdds.doubleChance_x_2, matchOdds.doubleChance_1_2])
			return cell
			
		case 26:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.TRIO, names: ["1", "X", "2"], data: [matchOdds.hand_1, matchOdds.hand_x, matchOdds.hand_2])
			return cell
			
		case 27:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.DUAL, names: ["Üst", "Alt"], data: [matchOdds.top_15, matchOdds.bott_15])
			return cell
			
		case 28:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.DUAL, names: ["Üst", "Alt"], data: [matchOdds.top_25, matchOdds.bott_25])
			return cell
			
		case 29:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.DUAL, names: ["Üst", "Alt"], data: [matchOdds.top_35, matchOdds.bott_35])
			return cell
			
		case 30:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.DUAL, names: ["Üst", "Alt"], data: [matchOdds.httop_15, matchOdds.htbott_15])
			return cell
			
		case 31:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.DUAL, names: ["Var", "Yok"], data: [matchOdds.opposingGoalYes, matchOdds.opposingGoalNo])
			return cell
			
		case 32:
			
			let matchOdds = (self.matchDetailData?.odds)!
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchOddsCollectionViewCell
			cell.setupCell(cellType: BA_MatchOddsCollectionViewCell.Ba_MatchOddsCellTypes.QUART, names: ["0-1", "2-3", "4-6", "7+"], data: [matchOdds.sog01, matchOdds.sog23, matchOdds.sog46, matchOdds.sog7])
			return cell
			
		// MARK: Match Detail Lineups
		case 33:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailSegmentCollectionViewCell
			
			let currentSegmentTexts: [String] = [
				(self.matchDetailData?.homeTeamName)!,
				(self.matchDetailData?.awayTeamName)!
			]
			
			if(self.currentSelectedLineupsTab == nil) {
				
				self.currentSelectedLineupsTab = 0
			}
			
			cell.setupCell(segmentCount: 2, segmentTexts: currentSegmentTexts, selectedIdx: self.currentSelectedLineupsTab!, segmentsEnabled: [true, true], section: BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS), delegate: self)
			return cell
			
		case 34:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailLineupsCollectionViewCell
			if let playerData = self.matchDetailData?.homeTeamLineups {
				
				cell.setupCell(teamColor1: (self.matchDetailData?.homeTeamUIColor1)!, teamColor2: (self.matchDetailData?.homeTeamUIColor2)!, playerData: playerData[indexPath.item])
			}
			return cell
			
		case 35:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailLineupsCollectionViewCell
			if let playerData = self.matchDetailData?.homeTeamSubstitutesLineups {
				
				cell.setupCell(teamColor1: (self.matchDetailData?.homeTeamUIColor1)!, teamColor2: (self.matchDetailData?.homeTeamUIColor2)!, playerData: playerData[indexPath.item])
			}
			return cell
			
		case 36:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailLineupsCollectionViewCell
			if let playerData = self.matchDetailData?.awayTeamLineups {
				
				cell.setupCell(teamColor1: (self.matchDetailData?.awayTeamUIColor1)!, teamColor2: (self.matchDetailData?.awayTeamUIColor2)!, playerData: playerData[indexPath.item])
			}
			return cell
			
		case 37:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailLineupsCollectionViewCell
			if let playerData = self.matchDetailData?.awayTeamSubstitutesLineups {
				
				cell.setupCell(teamColor1: (self.matchDetailData?.awayTeamUIColor1)!, teamColor2: (self.matchDetailData?.awayTeamUIColor2)!, playerData: playerData[indexPath.item])
			}
			return cell
			
		case 38:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.cellData[currentSectionNumber].cellId)[indexPath.item], for: indexPath) as! BA_MatchDetailCreateForecastCollectionViewCell
			
			if let matchOdds = self.matchDetailData?.odds {
				
				cell.setupCell(matchOdds: matchOdds, delegate: self)
			}
			return cell
			
		default:
			abort()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		if(self.currentSelectedMenu == 1 || self.currentSelectedMenu == 2) {
			
			var realSectionNumber = 0
			for currentCellData in self.cellData {
				
				if(currentCellData.tabIdx != self.currentSelectedMenu) {
					
					realSectionNumber += 1
				}else{
					
					break
				}
			}
			
			let currentSectionNumber = realSectionNumber + indexPath.section
			
			switch currentSectionNumber {
			case 8, 9, 10, 11, 12, 13, 14:
				
				if let matcDetailCell = cell as? BA_MatchDetailMatchesCollectionViewCell {
					
					DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150), execute: {() -> Void
					in
						matcDetailCell.cellWillDisplay()
					})
				}
				break
			case 34, 35, 36, 37:
				
				if let playerCell = cell as? BA_MatchDetailLineupsCollectionViewCell {
					
					DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150), execute: {() -> Void
						in
						playerCell.cellWillDisplay()
					})
				}
				break
			default:
				break
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		switch kind {
		case UICollectionElementKindSectionHeader:
			
            if self.currentSelectedMenu == BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS) {
                return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "statisticHeader", for: indexPath)
            } else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "matchDetailIndexHeader", for: indexPath)
            }
            
			
		case UICollectionElementKindSectionFooter:
			
			return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "matchDetailIndexFooter", for: indexPath)
		default:
			abort()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		
		var realSectionNumber = 0
		for currentCellData in self.cellData {
			
			if(currentCellData.tabIdx != self.currentSelectedMenu) {
				
				realSectionNumber += 1
			}else{
				
				break
			}
		}
		let currentSectionNumber = realSectionNumber + indexPath.section
		
		if(self.cellData.count <= currentSectionNumber) {
			return
		}
		
		switch elementKind {
		case UICollectionElementKindSectionHeader:
			
			if let headerView = view as? BA_MatchDetailIndexCollectionReusableView {
				
				
				if(self.cellData[currentSectionNumber].hasResuableHeader) {
					
					headerView.setupCell(title: self.cellData[currentSectionNumber].resuableTitle)
				}
            } else if let headerView = view as? BA_MatchDetailsStatsHeader {
                headerView.cellTitle.text = self.cellData[currentSectionNumber].resuableTitle
                headerView.triangleView.isHidden = self.cellData[currentSectionNumber].resuableTitle != "Goller"
            }
			break
		case UICollectionElementKindSectionFooter:
			
			if let footerView = view as? BA_MatchDetailFooterCollectionReusableView {
				
				if(self.cellData[currentSectionNumber].hasResuableFooter) {
					
					footerView.setupCell()
				}
			}
			break
		default:
			abort()
		}
	}
	
	private func loadMatchForecasts(_ disableHud: Bool = false) {
		
		guard (self.matchDetailData != nil && self.cellData != nil) else {
			
			if(disableHud) {
				MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
			}
			return
		}
		
		guard !self.forecastDataIsDownloading else {
			
			if(disableHud) {
				MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
			}
			
			return
		}
		
		self.forecastDataIsDownloading = true
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750), execute: {() -> Void
		in
			
			let requestUrl = String(format: BA_Server.GetForecastsApi, self.matchDetailData!.matchId)
			IO_NetworkHelper(getJSONRequest: requestUrl, completitionHandler: {(success, data, errorStr, statusCode) -> Void
				in
				
				if(success) {
					
					if let responseData = data as? [[String : AnyObject]] {
						
						self.addForecastSection(data: responseData)
						
						if(disableHud) {
							MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
						}
					}
				}
			})
		})
	}
	
	private func addForecastSection(data: [[String : AnyObject]]) {
		
		if(data.count > 0 && self.collectionView.numberOfSections >= 6) {
			
			self.forecastsData = [BA_MatcDetailForecasts]()
			let userCommentAreaFont = UIFont.systemFont(ofSize: 10)
			let deviceResolution = IO_Helpers.getResolution()
			let commentAreaWidth: CGFloat = (deviceResolution.0 * 0.6) - 32.0
			let constraintRect = CGSize(width: commentAreaWidth, height: .greatestFiniteMagnitude)
			
			for currentForecastRow in data {
				
				let userId: String
				let userName: String
				let userScore: Float
				if let forecastUserData = currentForecastRow["user_id"] as? [String : AnyObject] {
					
					userId = forecastUserData["_id"] as? String ?? ""
					userName = forecastUserData["nickname"] as? String ?? ""
					userScore = forecastUserData["score"] as? Float ?? 0.0
				}else{
					userId = ""
					userName = ""
					userScore = 0.0
				}
				
				let forecastId = currentForecastRow["_id"] as? String ?? ""
				let forecast = currentForecastRow["forecast"] as? String ?? ""
				let userComment = currentForecastRow["reason"] as? String ?? ""
				let totalLike = currentForecastRow["totalLike"] as? Int ?? 0
				
				let userCommentStr = userComment as NSString
				let forecastBoundingbox = userCommentStr.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: userCommentAreaFont], context: nil)
				let userCommentStrHeight = forecastBoundingbox.height + 16.0
				
				self.forecastsData?.append(BA_MatcDetailForecasts(userId: userId, userName: userName, userScore: userScore, forecastId: forecastId, forecast: forecast, userComment: userComment, commentAreaHeight: Float(userCommentStrHeight), totalLike: totalLike))
			}
			
			var forecastsRowCount = 0
			var forecastsRowHeights = [CGFloat]()
			var cellIds = [String]()
			
			for forecastData in self.forecastsData! {
				
				forecastsRowCount += 1
				let initialCommentHeight = CGFloat(self.forecastCellCommentAreaHeight.floatValue)
				let initialCellHeight = CGFloat(self.forecastCellInitialHeight.floatValue)
				
				if(CGFloat(forecastData.commentAreaHeight) < initialCommentHeight) {
					
					forecastsRowHeights.append(initialCellHeight)
				}else{
					
					let cellHeight = initialCellHeight - initialCommentHeight + CGFloat(forecastData.commentAreaHeight)
					forecastsRowHeights.append(cellHeight)
				}
				
				cellIds.append("ForecastsCell")
			}
			
			var itemsWillAdd = false
			let sectionNum = 6
			if(!(self.matchDetailData?.isPlayed)! && !(self.matchDetailData?.isPlaying)!) {
				
				if(!BA_Database.SharedInstance.isMatchCommented(matchId: (self.matchDetailData?.matchId)!)) {
					
					itemsWillAdd = true
					self.collectionView.performBatchUpdates({
						
						self.cellData[sectionNum].rowCount = 0
						self.invalidateLayout()
						let indexPaths: [IndexPath] = [
							IndexPath(item: 0, section: sectionNum)
						]
                        self.collectionView.deleteItems(at: indexPaths)
						
					}, completion: { (_) in
					
						forecastsRowCount += 1
						forecastsRowHeights.append(46)
						cellIds.append("NewForecastsCell")
                        
                        self.addForecastItems(sectionNum: sectionNum, forecastsRowCount: forecastsRowCount, forecastsRowHeights: forecastsRowHeights, cellIds: cellIds)
					})
				}
			}
			
			if(!itemsWillAdd) {
				
				self.addForecastItems(sectionNum: sectionNum, forecastsRowCount: forecastsRowCount, forecastsRowHeights: forecastsRowHeights, cellIds: cellIds)
			}
		}
	}
	
	func addForecastItems(sectionNum: Int, forecastsRowCount: Int, forecastsRowHeights: [CGFloat], cellIds: [String]) {

		if(forecastsRowCount > 0) {
		
			if(currentSelectedMenu == 0) {
		
				self.collectionView.performBatchUpdates({
					
					self.cellData[sectionNum].cellHeights = forecastsRowHeights
					self.cellData[sectionNum].cellId = cellIds
					self.cellData[sectionNum].rowCount = forecastsRowCount
					self.cellData[sectionNum].isVisible = true
					
					var indexPaths = [IndexPath]()
					for itemNumber in 0..<forecastsRowCount {
						
						indexPaths.append(IndexPath(item: itemNumber, section: sectionNum))
					}
						
					self.collectionView.insertItems(at: indexPaths)
						
				}, completion: { (_) in
					
					self.invalidateLayout()
					self.forecastDataIsDownloading = false
				})
			}
		}
	}
	
	// MARK: Collection view cell delegates
	func whoWinsCellTabBtnTapped(btnIdx: Int) {
		
		BA_Database.SharedInstance.voteMatch(matchId: (self.matchDetailData?.matchId)!, voteNum: Int16(btnIdx))
		
		let postKey: String
		if(btnIdx == 0) {
			
			postKey = "home"
			
			if(self.matchDetailData?.homeTeamForecast != nil) {
				
				self.matchDetailData?.homeTeamForecast = ((self.matchDetailData?.homeTeamForecast)!) + 1
			}else{
				
				self.matchDetailData?.homeTeamForecast = 1
				self.matchDetailData?.drawForecast = 0
				self.matchDetailData?.awayTeamForecast = 0
			}
		} else if(btnIdx == 1) {
			
			postKey = "draw"
			
			if(self.matchDetailData?.drawForecast != nil) {
				
				self.matchDetailData?.drawForecast = ((self.matchDetailData?.drawForecast)!) + 1
			}else{
				
				self.matchDetailData?.drawForecast = 1
				self.matchDetailData?.homeTeamForecast = 0
				self.matchDetailData?.awayTeamForecast = 0
			}
		} else {
			
			postKey = "away"
			
			if(self.matchDetailData?.awayTeamForecast != nil) {
				
				self.matchDetailData?.awayTeamForecast = ((self.matchDetailData?.awayTeamForecast)!) + 1
			}else{
				
				self.matchDetailData?.drawForecast = 0
				self.matchDetailData?.homeTeamForecast = 0
				self.matchDetailData?.awayTeamForecast = 1
			}
		}
		
		var postData = Dictionary<String, AnyObject>()
		postData["match_id"] = (self.matchDetailData?.matchId)! as AnyObject
		postData["key"] = postKey as AnyObject
		
		IO_NetworkHelper(postJSONRequestWithHeader: BA_Server.UpdateForecastApi, postData: postData, headers: ["X-BA-Authentication" : IO_Helpers.deviceUUID]) { (status, data, error, responseCode) in
			
			// pass
			#if DEBUG
				print("UpdateForecastApi \(status) \(responseCode)")
			#endif
		}
		
		self.isWhoWinsVoting = true
		self.whoWinsVoteValue = postKey
		self.cellData[1].isVisible = true
		self.cellData[0].isVisible = false
		self.invalidateLayout()
        self.collectionView.reloadData()
	}
	
	func pointsCellTabBtnTapped(tabType: BA_PointsCellCollectionViewCell.CellTypes) {
		
		self.cellData[2].isVisible = false
		self.cellData[3].isVisible = false
		self.cellData[4].isVisible = false
		
		switch tabType {
		case .GENERAL:
			self.cellData[2].isVisible = true
			break
		case .INSIDE:
			self.cellData[3].isVisible = true
			break
		case .OUTSIDE:
			self.cellData[4].isVisible = true
			break
		}
		
		self.invalidateLayout()
	}
	
	func btnLikeTapped(forecastId: String) {
		
		let likeForecastApi = String(format: BA_Server.LikeForecastsApi, forecastId)
		IO_NetworkHelper(getJSONRequest: likeForecastApi, completitionHandler: {(success, data, errorStr, statusCode) -> Void
			in
			
			if(success) {
				
				BA_Database.SharedInstance.likeForecast(forecastId: forecastId)
			}
		})
	}
	
	func matchDetailSegmentChanged(selectedIdx: Int, section: Int, invalidate: Bool) {
		
		if(section == BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES)) {
		
			switch selectedIdx {
			case 0:
				self.cellData[8].isVisible = true
				self.cellData[9].isVisible = true
				self.cellData[10].isVisible = true
				
				self.cellData[11].isVisible = false
				
				self.cellData[12].isVisible = false
				self.cellData[13].isVisible = false
				self.cellData[14].isVisible = false
				break
			case 1:
				self.cellData[8].isVisible = false
				self.cellData[9].isVisible = false
				self.cellData[10].isVisible = false
				
				self.cellData[11].isVisible = true
				
				self.cellData[12].isVisible = false
				self.cellData[13].isVisible = false
				self.cellData[14].isVisible = false
				break
			case 2:
				self.cellData[8].isVisible = false
				self.cellData[9].isVisible = false
				self.cellData[10].isVisible = false
				
				self.cellData[11].isVisible = false
				
				self.cellData[12].isVisible = true
				self.cellData[13].isVisible = true
				self.cellData[14].isVisible = true
				break
			default:
				// pass
				break
			}
			
			self.currentMatchesTab = selectedIdx
			if(invalidate) {
				
				self.invalidateLayout()
			}
			
		}else if(section == BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS)) {
			
			if(selectedIdx == 0) {
				
				self.cellData[16].isVisible = false
				
				self.cellData[17].isVisible = true
				self.cellData[18].isVisible = true
				self.cellData[19].isVisible = true
				self.cellData[20].isVisible = true
				self.cellData[21].isVisible = true
				self.cellData[22].isVisible = true
			}else{
				
				self.cellData[16].isVisible = true
				
				self.cellData[17].isVisible = false
				self.cellData[18].isVisible = false
				self.cellData[19].isVisible = false
				self.cellData[20].isVisible = false
				self.cellData[21].isVisible = false
				self.cellData[22].isVisible = false
			}
			
			self.currentSelectedStatsTab = selectedIdx
			if(invalidate) {
				
				self.invalidateLayout()
                self.collectionView.reloadData()
			}
            
		}else if(section == BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS)) {
			
			if(selectedIdx == 0) {
				
				self.cellData[34].isVisible = true
				self.cellData[35].isVisible = true
				
				self.cellData[36].isVisible = false
				self.cellData[37].isVisible = false
			}else{
				
				self.cellData[34].isVisible = false
				self.cellData[35].isVisible = false
				
				self.cellData[36].isVisible = true
				self.cellData[37].isVisible = true
			}
			
			self.currentSelectedLineupsTab = selectedIdx
			if(invalidate) {
				
				self.invalidateLayout()
			}
		}
	}
	
	func newForecastButtonTapped() {
		
		guard (BA_CurrentMatchDetailMenusIdx(forType: .CREATE_FORECAST) != self.currentSelectedMenu) else {
			return
		}
		
		self.itemTapped(itemNumber: BA_CurrentMatchDetailMenusIdx(forType: .CREATE_FORECAST))
	}
	
	func createForecastBtnSendTapped(selectedForecastVal: String, comment: String) {
		
		MBProgressHUD.showAdded(to: self.view, animated: true)
		
		let sectionNum = 6
		self.cellData[sectionNum].cellHeights = [0]
		self.cellData[sectionNum].cellId = ["ForecastsCell"]
		self.cellData[sectionNum].rowCount = 0
		self.cellData[sectionNum].isVisible = true
		self.forecastsData?.removeAll()
		
		var postData = Dictionary<String, AnyObject>()
		postData["match_id"] = (self.matchDetailData?.matchId)! as AnyObject
		postData["forecast"] = selectedForecastVal as AnyObject
		postData["reason"] = comment as AnyObject
		
		IO_NetworkHelper(postJSONRequest: BA_Server.ForecastsCommentApi, postData: postData) { (status, response, error, statusCode) in
			
			if(status) {
				
				BA_Database.SharedInstance.addForecastComment(matchId: (self.matchDetailData?.matchId)!)
			}
			
			
			self.itemTapped(itemNumber: 0)
			self.loadMatchForecasts(true)
		}
	}
	
	// Mark: Keyboard notifications
	func keyboardWillShow(sender: Notification) {
		
		if let userInfo = sender.userInfo {
			
			if let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
				
				self.oldContentInset = self.collectionView.contentInset
				let newContentInset = UIEdgeInsets(top: (self.oldContentInset?.top)!, left: (self.oldContentInset?.left)!, bottom: (self.oldContentInset?.bottom)! + keyboardRect.height, right: (self.oldContentInset?.right)!)
				self.collectionView.contentInset = newContentInset
				let currentScrollPos = self.collectionView.scrollIndicatorInsets
				let collectionViewRect = self.collectionView.bounds
				let scrollRect = CGRect(x: 0, y: currentScrollPos.top + keyboardRect.height, width: collectionViewRect.size.width, height: collectionViewRect.size.height)
				self.collectionView.scrollRectToVisible(scrollRect, animated: true)
			}
		}
	}
	
	func keyboardWillHide(sender: Notification) {
		
		guard self.oldContentInset != nil else {
			
			return
		}
		self.collectionView.contentInset = self.oldContentInset!
	}
	
	// Mark: Login delegate
	func loginCanceled() {
		
		BA_AppDelegate.Ba_LoginData!.loginDelegate = nil
		self.itemTapped(itemNumber: BA_CurrentMatchDetailMenusIdx(forType: .INDEX))
	}
	
	// TODO: will be deleted
	@IBAction func homeTeamTapped(sender: UITapGestureRecognizer) {
			
		self.dismiss(animated: false, completion: nil)
		guard self.delegate != nil else {
				
			return
		}
			
		let apiUrl = String(format: BA_Server.TeamDetail, (self.matchDetailData?.homeTeamId)!)
		self.delegate?.BA_MatchDetailDismiss(withUrl: apiUrl)
	}
	
	@IBAction func awayTeamTapped(sender: UITapGestureRecognizer) {
		
		self.dismiss(animated: false, completion: nil)
		guard self.delegate != nil else {
			
			return
		}
		
		let apiUrl = String(format: BA_Server.TeamDetail, (self.matchDetailData?.awayTeamId)!)
		self.delegate?.BA_MatchDetailDismiss(withUrl: apiUrl)
	}
    
    // MARK: notification
    func userStateChanged(notification: Notification) {
        if let loginData = BA_AppDelegate.Ba_LoginData {
            if loginData.IsDeviceLogin {
                currentTabBar.setupLoggedIn()
            }
        }
    }
}
