//
//  StatisticViewController.swift
//  bahisadam
//
//  Created by anton on 3/18/17.
//

import UIKit
import MBProgressHUD
import BahisadamLive
import AASegmentedControl

class StatisticViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, PlayerTableViewCellDelegate {
    
    @IBOutlet var optionButton: AASegmentedControl!
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var optionText: UILabel!
    
    
    private var optionSeg: Int = 0
    private var leagueid: Int = 1
    
    private var goalData: [BA_Players] = [BA_Players]()
    private var yellowData: [BA_Players] = [BA_Players]()
    private var redData: [BA_Players] = [BA_Players]()
    private var assistData: [BA_Players] = [BA_Players]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        optionButton.itemNames = ["GOL","ASIST","S.KART", "K.KART"]
        //segmentControl.font = UIFont(name: "Chalkduster", size: 14.0)!
        optionButton.selectedIndex = 0
        optionButton.addTarget(self,
                               action: #selector(self.segmentValueChanged(_:)),
                               for: .valueChanged)
        self.loadData()
        
        playerTableView.rowHeight = UITableViewAutomaticDimension
        playerTableView.estimatedRowHeight = 10
        print("playerviewdidload")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentValueChanged(_ sender: AASegmentedControl) {
        
        //optionButton.forEach({$0.selectedIndex = sender.selectedIndex})
        
        optionSeg = sender.selectedIndex
        print("optionSeg: ", optionSeg)
        
        if optionSeg == 0{
            self.optionText.text = "Gol" + " Krallığı"
        } else if optionSeg == 1{
            self.optionText.text = "Asist" + " Krallığı"
        } else if optionSeg == 2{
            self.optionText.text = "S.Kart" + " Krallığı"
        } else if optionSeg == 3{
            self.optionText.text = "K.Kart" + " Krallığı"
        }
        
        self.playerTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var playerCount: Int = 0
        if optionSeg == 0{
            playerCount = goalData.count
        } else if optionSeg == 1{
            playerCount = assistData.count
        } else if optionSeg == 2{
            playerCount = yellowData.count
        } else if optionSeg == 3{
            playerCount = redData.count
        }
        
        return playerCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerTableViewCell
        print("formatcell")
        if optionSeg == 0{
            cell.setupCell(playerData: goalData[indexPath.row], delegate: self)
            print("optionSeg: ", 0)
        } else if optionSeg == 1{
            cell.setupCell(playerData: assistData[indexPath.row], delegate: self)
            print("optionSeg: ", 1)
        } else if optionSeg == 2{
            cell.setupCell(playerData: yellowData[indexPath.row], delegate: self)
            print("optionSeg: ", 2)
        } else if optionSeg == 3{
            cell.setupCell(playerData: redData[indexPath.row], delegate: self)
            print("optionSeg: ", 3)
        }
        
        return cell
    }
    
    private func loadData(withoutHud noHud: Bool = false) {
        print("loadData")
        if(!noHud) {
            
            MBProgressHUD.showAdded(to: self.view, animated: false)
        }
        
        let urlString = String(format: BA_Server.StatisticApi, leagueid)
        
        IO_NetworkHelper(getJSONRequest: urlString, completitionHandler: { (status, data, error, statusCode) in
            
            if(status) {
                
                if let dataDict = data as? Dictionary<String, AnyObject> {
                    
                    print("loaddata json")
                    self.configureData(data: dataDict)
                }
            }
            
            if(!noHud) {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
            }
        })
    }
    
    
    private func configureData(data: Dictionary<String, AnyObject>) {
        print("configureData")
        goalData = ConfigurePlayerData(data: data, option: "goals")
        assistData = ConfigurePlayerData(data: data, option: "asists")
        yellowData = ConfigurePlayerData(data: data, option: "yellow_cards")
        redData = ConfigurePlayerData(data: data, option: "red_cards")
        
        self.playerTableView.reloadData()
    }
    
    private func ConfigurePlayerData(data: Dictionary<String, AnyObject>, option: String) -> [BA_Players] {
        print("ConfigurePlayerData")
        var playerDatas: [BA_Players] = [BA_Players]()
        
        if let players = data[option] as? [Dictionary<String, AnyObject>] {
            
                for player in players {
                    
                    let playerId = player["player_id"] as? String ?? ""
                    let playerNic = player["nick"] as? String ?? ""
                    let name = player["name"] as? String ?? ""
                    let lastName = player["last_name"] as? String ?? ""
                    let teamId = player["team_id"] as? String ?? ""
                    let playerCC = player["cc"] as? String ?? ""
                    let teamName = player["team_name"] as? String ?? ""
                    let total = player["total"] as? String ?? ""
                    let year = player["year"] as? String ?? ""
                    let playerAlias = player["player_alias"] as? String ?? ""
                    let teamAlias = player["team_alias"] as? String ?? ""
                    let teamSheildUrl = player["team_shield"] as? String ?? ""
                    let playerImageUrl = player["player_image"] as? String ?? ""
                    let teamFlagUrl = player["team_flag"] as? String ?? ""
                    
                    let playerData = BA_Players(playerId: playerId, playerNic: playerNic, name: name, lastName: lastName, teamId: teamId, playerCC: playerCC, teamName: teamName, total: total, year: year, playerAlias: playerAlias, teamAlias: teamAlias, teamSheildUrl: teamSheildUrl, playerImageUrl: playerImageUrl, teamFlagUrl: teamFlagUrl)
                    
                    playerDatas.append(playerData)
                }
            
        }
        
        return playerDatas
        
    }
    
    
    
    /**
     * @TODO: implement delegate method
     */
    
    func playerTableCellTapped(playerId: String) {
        
        print("playerTableViewCellDelegate \(playerId)")
        
        if let baNavController = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.last as? BA_NavigationController {
            
            //let playerDetailUrl = String(format: BA_Server.playerDetail, playerId) //To add
            //baNavController.openWebView(withUrl: playerDetailUrl)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
