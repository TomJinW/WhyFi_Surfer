//
//  network.swift
//  WhyFi
//
//  Created by 崔振宇 on 2017/4/25.
//  Copyright © 2017年 Tom. All rights reserved.
//

import UIKit

import Foundation
import SystemConfiguration.CaptiveNetwork

class network : NSObject {
    
    @objc func getSSID() -> String? {
        
        let interfaces = CNCopySupportedInterfaces()
        if interfaces == nil {
            return nil
        }
        
        let interfacesArray = interfaces as! [String]
        if interfacesArray.count <= 0 {
            return nil
        }
        
        let interfaceName = interfacesArray[0] as String
        let unsafeInterfaceData =     CNCopyCurrentNetworkInfo(interfaceName as CFString)
        if unsafeInterfaceData == nil {
            return nil
        }
        
        let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
        
        return interfaceData["SSID"] as? String
    }
    
}
