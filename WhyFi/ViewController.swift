//
//  ViewController.swift
//  WhyFi
//
//  Created by 崔振宇 on 2017/4/25.
//  Copyright © 2017年 Tom. All rights reserved.
//

import UIKit
import Foundation
import KeychainAccess
import Swifter
import SwiftyJSON
import MessageUI
import UserNotifications
let count = 10;let time = 1000000;
let keychain = Keychain(service: "org.ShanghaiTech.WhyFi-token").synchronizable(true)
var firstTime = false;

extension String {
    var localized: String {
        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
            // we set a default, just in case
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, comment: "")
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

class ViewController: UIViewController, UITextFieldDelegate,MFMailComposeViewControllerDelegate {
    //private var server: HttpServer?
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var txfUserName: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var switchRem: UISwitch!
    @IBOutlet weak var switchAutoLogin: UISwitch!
    @IBOutlet weak var progressbar: UIProgressView!


    @IBAction func memSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(switchRem.isOn, forKey: "remember")
        if !switchRem.isOn {
            if UserDefaults.standard.string(forKey: "username") != nil{
                keychain[UserDefaults.standard.string(forKey: "username")!] = nil;
            }
            UserDefaults.standard.set("", forKey: "username")
            switchAutoLogin.isOn = false;
             UserDefaults.standard.set(switchAutoLogin.isOn, forKey: "auto")
        }
    }
    @IBAction func autoSwitchChanged(_ sender: UISwitch) {
        if switchAutoLogin.isOn {
            switchRem.isOn = true
            UserDefaults.standard.set(switchRem.isOn, forKey: "remember")
        }
        UserDefaults.standard.set(switchAutoLogin.isOn, forKey: "auto")

    }
    
    func wifiNetworkWrong(type:Int32,name:String!){
        let alertController = UIAlertController (title: "wrongWiFi".localized, message: "noWifiConnect".localized, preferredStyle: .alert)
        if type == 2 {
            alertController.title = "wrongWiFi".localized
            alertController.message = String(format:"SSID is not ShanghaiTech.\n You are now connecting %@.".localized,"\(name!)");
        }
        let settingsAction = UIAlertAction(title: "Wi-Fi Settings".localized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: "App-Prefs:root=WIFI") else {
                return
                
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Close".localized, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // http server
        

        
        
        
        
        
        
        
//        let fileManger = FileManager.default
//        var doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
//        let destinationPath = doumentDirectoryPath.appendingPathComponent("ShanghaiTech.mobileconfig")
//        let sourcePath = Bundle.main.path(forResource: "ShanghaiTech", ofType: "mobileconfig")
//        do{
//            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//            let url = NSURL(fileURLWithPath: path)
//            let filePath = url.appendingPathComponent("ShanghaiTech.mobileconfig")?.path
//            let fileManager = FileManager.default
//            if fileManager.fileExists(atPath: filePath!) {
//                print(url)
//                print("FILE AVAILABLE")
//            } else {
//                print("FILE NOT AVAILABLE")
//                try fileManger.copyItem(atPath: sourcePath!, toPath: destinationPath)
//            }
//            
//        }catch{
//        
//        }
        
        
        
//        let server = HttpServer()
//        server["/:path"] = shareFilesFromDirectory("/")
//        server["/hello"] = { .ok(.html("You asked for \($0)"))  }
//        do {
//            try server.start(9080)
//        }catch{
//            print("SERVER START FAILED")
//        }
//        

        
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.txfUserName.delegate = self
        self.txfPassword.delegate = self
        
        switchRem.isOn = UserDefaults.standard.bool(forKey: "remember")
        switchAutoLogin.isOn = UserDefaults.standard.bool(forKey:"auto");
        
        if switchRem.isOn {
            txfUserName.text = UserDefaults.standard.string(forKey: "username")
            if UserDefaults.standard.string(forKey: "username") != nil{
                txfPassword.text = keychain[UserDefaults.standard.string(forKey: "username")!]
            }
        }
        //setMinimumBackgroundFetchInterval(600)
        if switchAutoLogin.isOn{
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async(execute: {
                    self.btnLogin.isEnabled = false;
                })
                
                self.clickLogin(hint: true,auto: true);
                
                DispatchQueue.main.async(execute: {
                    self.btnLogin.isEnabled = true;
                })
                
            }
        }
        if keychain["chenwen"] != nil{
            let alertController = UIAlertController(title: "Failed", message: "Chenwen is busy or problematic.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func syncRequest(ip:String){
        var success = false
        
        // Check request result
        for i in 1...count{
            DispatchQueue.main.async(execute: {
                self.progressbar.progress = Float(i)/Float(count)})
            print("pro\(i)")
            let a = ip
            var ansrequest = URLRequest(url: URL(string: "https://controller1.net.shanghaitech.edu.cn:8445/PortalServer/Webauth/webAuthAction!syncPortalAuthResult.action")!)
            let anspostString = "authLan=zh_CN&hasValidateCode=False&validCode=&hasValidateNextUpdatePassword=true&rememberPwd=false&browserFlag=zh&hasCheckCode=false&checkcode=&saveTime=14&autoLogin=false&userMac=&isBoardPage=false&browserFlag=zh&clientIp=\(a)"
            ansrequest.httpBody = anspostString.data(using: .utf8)
            let anstask = URLSession.shared.dataTask(with: ansrequest) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for
                    return
                }
                let responseString = String(data: data, encoding: .utf8)
                print("ANSWER_String = \(responseString)")
                if let dataFromString = responseString?.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)
                        if json["data"]["portalAuthStatus"] == 1{
                            success = true
                            
                        }
                    }catch {
                    }
                }
            }
            anstask.resume()
            //anstask.resume()
            if success{
                break
            }
            usleep(1000000);
        }
        
        
        if success{
            DispatchQueue.main.async(execute: {
                self.lblMsg.text = "Success. Welcome to the Internet.".localized;
                self.progressbar.progress = 1.0;
            })
            if UserDefaults.standard.bool(forKey: "remember") == true && self.txfUserName != nil{
                UserDefaults.standard.set(self.txfUserName.text!, forKey: "username")
                do {
                    try keychain
                        .synchronizable(true)
                        .set(self.txfPassword.text!, key: self.txfUserName.text!)
                } catch let error {
                    print("error: \(error)")
                }
            }
        }else{
            DispatchQueue.main.async(execute: {
                self.lblMsg.text = "Failed. Response is not correct.".localized
                self.progressbar.progress = 0.0;
            })
        }
    }

    func clickLogin(hint: Bool,auto:Bool){
        var ip = ""
        var status:Int32 = 0;
        var username:String = "";
        var password:String = "";
        
        if txfUserName == nil || txfPassword == nil {
            if UserDefaults.standard.string(forKey: "username") != nil{
                username = UserDefaults.standard.string(forKey: "username")!
            }
            
            if UserDefaults.standard.string(forKey: "username") != nil{
                password = keychain[UserDefaults.standard.string(forKey: "username")!]!
            }
        }else{
            if  txfUserName.text != nil && txfPassword.text != nil{
                username = txfUserName.text!
                password = txfPassword.text!
            }
        }
 
        if username != "" && password != "" {
            let wifiName = network().getSSID()
            guard wifiName != nil else {
                wifiNetworkWrong(type: 1,name:wifiName)
                return
            }
            if wifiName == "ShanghaiTech" || wifiName == "guest"{
                DispatchQueue.main.async(execute: {
                    self.lblMsg.text = "Authenticating. This may take a while.".localized
                })
                var request = URLRequest(url: URL(string: "https://controller1.net.shanghaitech.edu.cn:8445/PortalServer/Webauth/webAuthAction!login.action")!)
                //request = URLRequest(url: URL(string: "https://controller1.net.shanghaitech.edu.cn:8445/PortalServer/customize/1478262836414/pc/auth.jsp")!)
                request.httpMethod = "POST"
                let postString = "userName=\(username)&password=\(password)&authLan=zh_CN&hasValidateCode=False&validCode=&hasValidateNextUpdatePassword=true&rememberPwd=false&browserFlag=zh&hasCheckCode=false&checkcode=&saveTime=14&autoLogin=false&userMac=&isBoardPage=false"
                request.httpBody = postString.data(using: .utf8)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {                                                 // check for fundamental networking error
                        print("error=\(error)")
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {  // check for http errors
                        if hint {
                            DispatchQueue.main.async(execute: {
                                self.lblMsg.text = "Failed. Network is problematic.".localized
                            })
                        }
                    }
                    let responseString = String(data: data, encoding: .utf8)
                    print("RESPONSE\n")
                    let a:String = responseString!
                    print("responseString = \(a)")
                   // sleep(100);
                    if let dataFromString = a.data(using: .utf8, allowLossyConversion: true) {
                        
                        do{
                            let json = try JSON(data: dataFromString)
                            ip = json["data"]["ip"].stringValue
                            status = json["data"]["accessStatus"].int32!
                            if json["data"]["accessStatus"] != 200{
                                
                                DispatchQueue.main.async(execute: {
                                    //self.lblMsg.text = json["message"].stringValue
                                })
                                
                                
                            }else{
                                
                            }
                            
                        }catch{
                        }
                    }
                    
                    
                }
                task.resume()
                
                self.syncRequest(ip: ip);
               
                
                
                    
                
                

                
            }else{
                wifiNetworkWrong(type: 2,name:wifiName)
            }
        }
        else{
            if !auto{
                let alertController = UIAlertController(title: "Empty Username or Password".localized, message: "Please fill in the blanks!".localized, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients([""])
            composeVC.setSubject("title".localized)
            composeVC.setMessageBody("content".localized, isHTML: false)
            if let filePath = Bundle.main.path(forResource: "ShanghaiTech", ofType: "mobileconfig") {

                if let fileData = NSData(contentsOfFile: filePath) {
                   
                    composeVC.addAttachmentData(fileData as Data, mimeType: "mobileconfig", fileName: "ShanghaiTech.mobileconfig")
                }
            }
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
    
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

    @IBAction func install(_ sender: Any) {
        sendEmail()
    
    }
    

    
    @IBAction func btnLoginTouched(_ sender: Any) {

        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: {
                self.btnLogin.isEnabled = false;
            })
            
            self.clickLogin(hint: true,auto:false);
            
            DispatchQueue.main.async(execute: {
                self.btnLogin.isEnabled = true;
            })
        
        }
    }

}











