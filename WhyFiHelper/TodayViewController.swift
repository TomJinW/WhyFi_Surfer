//
//  TodayViewController.swift
//  WhyFiHelper
//
//  Created by 崔振宇 on 2017/4/25.
//  Copyright © 2017年 Tom. All rights reserved.
//

import UIKit
import Foundation
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var wifiName: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        let Name = network().getSSID()
        
        guard Name != nil else {
            wifiName.text = "Not Connected."
            return
        }
        wifiName.text = Name!
        
        completionHandler(NCUpdateResult.newData)
    }
    @IBAction func settingsPressed(_ sender: UIButton) {
                extensionContext?.open(URL(string: "org.ShanghaiTech.WhyFi://?openSettings=true")! , completionHandler: nil)

    }
    
    
    @IBAction func LoginPressed(_ sender: Any) {
                extensionContext?.open(URL(string: "org.ShanghaiTech.WhyFi://?performLogin=true")! , completionHandler: nil)
        
    }
}
