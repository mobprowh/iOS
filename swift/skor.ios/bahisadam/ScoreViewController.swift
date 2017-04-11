//
//  ScoreViewController.swift
//  bahisadam
//
//  Created by anton on 3/16/17.
//

import UIKit
import MBProgressHUD
import BahisadamLive
import AASegmentedControl

class ScoreViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, ScoreTableViewCellDelegate{
    
    @IBOutlet var optionButton: AASegmentedControl!
    @IBOutlet weak var teamTableView: UITableView!
    
    private var optionSeg: Int = 0
    private var totalstandingData: [BA_Standings] = [BA_Standings]()
    private var homestandingData: [BA_Standings] = [BA_Standings]()
    private var awaystandingData: [BA_Standings] = [BA_Standings]()
    
    private var totalteamData: [BA_Team] = [BA_Team]()
    private var hometeamData: [BA_Team] = [BA_Team]()
    private var awayteamData: [BA_Team] = [BA_Team]()
    
    private var leagueid: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        optionButton.itemNames = ["GENEL","iç SAHA","DIS SAHA"]
        //segmentControl.font = UIFont(name: "Chalkduster", size: 14.0)!
        optionButton.selectedIndex = 0
        optionButton.addTarget(self,
                               action: #selector(self.segmentValueChanged(_:)),
                               for: .valueChanged)
        self.loadData()
        
        teamTableView.rowHeight = UITableViewAutomaticDimension
        teamTableView.estimatedRowHeight = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        optionSeg = 0
        self.loadData()
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        optionSeg = 0
        self.loadData()
        super.viewDidAppear(animated)
    }
    
    
    
        
    func segmentValueChanged(_ sender: AASegmentedControl) {
        
        //optionButton.forEach({$0.selectedIndex = sender.selectedIndex})
        
        optionSeg = sender.selectedIndex
        self.teamTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countNum: Int = 1
        if optionSeg == 0{
            countNum = totalstandingData.count
        } else if optionSeg == 1{
            countNum = homestandingData.count
        } else if optionSeg == 2{
            countNum = awaystandingData.count
        }
        return countNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! ScoreTableViewCell
        print("formatcell")
        if optionSeg == 0{
            cell.setupCell(standingData: totalstandingData[indexPath.row],teamData: totalteamData[indexPath.row], delegate: self)
            print("optionSeg: ", 0)
        } else if optionSeg == 1{
            cell.setupCell(standingData: homestandingData[indexPath.row],teamData: hometeamData[indexPath.row], delegate: self)
            print("optionSeg: ", 1)
        } else if optionSeg == 2{
            cell.setupCell(standingData:awaystandingData[indexPath.row],teamData: awayteamData[indexPath.row], delegate: self)
            print("optionSeg: ", 2)
        }
        
        return cell
    }
    
    private func loadData(withoutHud noHud: Bool = false) {
        print("loadData")
        if(!noHud) {
            
            MBProgressHUD.showAdded(to: self.view, animated: false)
        }
        
        let urlString = String(format: BA_Server.ScoreStandingsApi, leagueid)
        
        IO_NetworkHelper(getJSONRequest: urlString, completitionHandler: { (status, data, error, statusCode) in
            
            if(status) {
                
                if let dataDict = data as? [Dictionary<String, AnyObject>] {
                    
                    print("loaddata json")
                    self.configureData(data: dataDict)
                }
            }
            
            if(!noHud) {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
            }
        })
    }
    
    
    private func configureData(data: [Dictionary<String, AnyObject>]) {
        print("configureData")
        totalstandingData = ConfigureStandingData(data: data[0])
        homestandingData = ConfigureStandingData(data: data[1])
        awaystandingData = ConfigureStandingData(data: data[2])
        
        totalteamData = ConfigureteamData(data: data[0])
        awayteamData = ConfigureteamData(data: data[1])
        hometeamData = ConfigureteamData(data: data[1])
        
        self.teamTableView.reloadData()
    }
    
    private func ConfigureStandingData(data: Dictionary<String, AnyObject>) -> [BA_Standings] {
        print("ConfigureStandingData")
        var standingDatas: [BA_Standings] = [BA_Standings]()
        
        if let groups = data["groups"] as? [Dictionary<String, AnyObject>] {
            
            let group = groups[0]
            
            if let standings = group["team_standings"] as? [Dictionary<String, AnyObject>]{
                
                for standing in standings {
                    
                    let groupCode = standing["rank"] as? Int32 ?? 0
                    let teamName = standing["team_name"] as? String ?? ""
                    let teamId = standing["_id"] as? Int64 ?? 0
                    let standingAG = standing["AG"] as? Int32 ?? 0
                    let standingAVG = standing["AVG"] as? Int32 ?? 0
                    let standingB = standing["B"] as? Int32 ?? 0
                    let standingG = standing["G"] as? Int32 ?? 0
                    let standingM = standing["M"] as? Int32 ?? 0
                    let standingOM = standing["OM"] as? Int32 ?? 0
                    let standingPTS = standing["PTS"] as? Int32 ?? 0
                    let standingYG = standing["YG"] as? Int32 ?? 0
                    
                    let standingData = BA_Standings(groupCode: groupCode, teamName: teamName, teamId: teamId, standingAG: standingAG, standingAVG: standingAVG, standingB: standingB, standingG: standingG, standingM: standingM, standingOM: standingOM, standingPTS: standingPTS, standingYG: standingYG)
                    
                    standingDatas.append(standingData)
                }
            }
        }
        
        return standingDatas
        
    }
    
    private func ConfigureteamData(data: Dictionary<String, AnyObject>) -> [BA_Team] {
        print("ConfigureteamData")
        var teamDatas: [BA_Team] = [BA_Team]()
        
        if let groups = data["groups"] as? [Dictionary<String, AnyObject>] {
            
            let group = groups[0]
            
            if let standings = group["team_standings"] as? [Dictionary<String, AnyObject>]{
                
                for standing in standings {
                    
                    let teamName = standing["team_name"] as? String ?? ""
                    let teamId = standing["_id"] as? Int ?? 0
                    let color1 = standing["color1"] as? String ?? ""
                    let color2 = standing["color2"] as? String ?? ""
                    
                    let teamData = BA_Team(teamName: teamName, teamId: teamId, color1: color1, color2: color2)
                    
                    teamDatas.append(teamData)
                }
            }
        }
        
        return teamDatas
        
    }
    
    
    /**
     * @TODO: implement delegate method
     */
    
    func teamTableCellTapped(teamId: Int) {
        
        print("ScoreTableViewCellDelegate \(teamId)")
        
        if let baNavController = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.last as? BA_NavigationController {
            
            let teamDetailUrl = String(format: BA_Server.TeamDetail, teamId)
            baNavController.openWebView(withUrl: teamDetailUrl)
        }
        
    }
    
    
}
