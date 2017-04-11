//
//  BA_SportsViewController.swift
//  bahisadam
//
//  Created by anton on 3/15/17.
//

import UIKit
import BahisadamLive

class SportsViewController: UIViewController {
    
    @IBOutlet weak var segPages: SwiftPages!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let VCIDs : [String] = ["ScoreVC", "FixVC", "StatisVC"]
        let buttonTitles : [String] = ["P.Durumu", "Fikstur", "istatistikler"]
        segPages.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
        
        //Customization 32B846
        
        //swiftPagesView.enableAeroEffectInTopBar(true)
        segPages.setButtonsTextColor(UIColor.white)
        segPages.setAnimatedBarColor(UIColor.white)
        
        segPages.setTopBarBackground(UIColor(red: 50/255, green: 184/255, blue: 70/255, alpha: 1.0))
        
        //swiftPagesView.disableTopBar()
        
        
        //swiftPagesView.setOriginY(0.0)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("viewWillAppear")
        self.tabBarController?.navigationItem.title = "Türkiye Süper Ligi"
        //let logo = UIImage(named: "BA_tr")
        //let logoView = UIImageView(image: logo)
        //self.tabBarController?.navigationItem.titleView = logoView
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
}
