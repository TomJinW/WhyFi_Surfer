//
//  AppDelegate.swift
//  WhyFi
//
//  Created by 崔振宇 on 2017/4/25.
//  Copyright © 2017年 Tom. All rights reserved.
//

import UIKit
import UserNotifications

import Foundation
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var login = false;
    var wifi = false;
    var bus = false;
    func completePing (timeElapsed:Double?, error:Error?){
        if error != nil {

            if #available(iOS 10.0, *) {
                let content = UNMutableNotificationContent()
                content.title = "Connected".localized
                content.subtitle = "ShanghaiTech or guest"
                content.body = "noti1".localized
                content.badge = 1
                content.sound = UNNotificationSound.default()
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            } else {
                let notification = UILocalNotification()
                notification.alertTitle = "Connected".localized
                notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
                notification.alertBody = "noti1".localized+"\nShanghaiTech or guest"
                notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.shared.scheduleLocalNotification(notification)
            }

        }
    }

    
    func isInternetAvailable()
    {
        PlainPing.ping("baidu.com", withTimeout: 2.0,completionBlock: completePing)
    }
    func application(_ application: UIApplication,didRegister notificationSettings: UIUserNotificationSettings){
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
        
        
    }
    func application(_ application: UIApplication,
                              performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        
        completionHandler(UIBackgroundFetchResult.newData)
        getData()
    }

    func getData(){

        
        
        let wifiName = network().getSSID()
        if (wifiName != nil){
            if (wifiName == "ShanghaiTech" || wifiName == "guest"){
                isInternetAvailable()
//                if !isInternetAvailable(){
//                    let content = UNMutableNotificationContent()
//                    content.title = "XX體驗過了，才是你的。"
//                    content.subtitle = "米花兒"
//                    content.body = "不要追問為什麼，就笨拙地走入未知。感受眼前的怦然與顫抖，聽聽左邊的碎裂和跳動。不管好的壞的，只有體驗過了，才是你的。"
//                    content.badge = 1
//                    content.sound = UNNotificationSound.default()
//                    
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//                    let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
//                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//                }
            }
        }
    }
    
    
    func application(_ app: UIApplication,  open url: URL,  options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("\nDEALING URL")
        let urlComponents = NSURLComponents(url: url as URL, resolvingAgainstBaseURL: false)
        let items = (urlComponents?.queryItems)! as [NSURLQueryItem] // {name = backgroundcolor, value = red}
        login = false;
        wifi = false;
        if (url.scheme == "org.ShanghaiTech.WhyFi") {
            _ = UIApplication.shared.delegate as! AppDelegate
            if let _ = items.first, let propertyName = items.first?.name, let propertyValue = items.first?.value {
                if propertyName == "performLogin"{
                    if propertyValue == "true"{
                        self.login = true;
                        self.wifi = false;
                        self.bus = false;
                        print("SET LOGIN TRUE");
                        
                    }
                    
                }else if propertyName == "openSettings" {
                    if propertyValue == "true"{
                        self.wifi = true;
                        self.login = false;
                        self.bus = false;
                        print("SET WIFI TRUE");
                    }
                }else if propertyName == "bus" {
                    if propertyValue == "true"{
                        self.bus = true;
                        self.login = false;
                        self.wifi = false;
                        print("SET WIFI TRUE");
                    }
                }


            }
            

        // URL Scheme entered through URL example : swiftexamples://red
        //swiftexamples://?backgroundColor=red
        
    }
        return false
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("shown\n");
        
    }
    


    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
//        let content = UNMutableNotificationContent()
//        content.title = "XX體驗過了，才是你的。"
//        content.subtitle = "米花兒"
//        content.body = "不要追問為什麼，就笨拙地走入未知。感受眼前的怦然與顫抖，聽聽左邊的碎裂和跳動。不管好的壞的，只有體驗過了，才是你的。"
//        content.badge = 1
//        content.sound = UNNotificationSound.default()
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        completionHandler(UIBackgroundFetchResult.newData)
//    }

}

