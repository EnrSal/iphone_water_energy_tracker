//
//  WifiConfigVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/22/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import SwiftyBluetooth
import CoreBluetooth
import RealmSwift


class WifiConfigVC: SaviorVC {

    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var wifiField: UITextField!
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var powerSegments: UISegmentedControl!
    @IBOutlet weak var minutes: UITextField!
    @IBOutlet weak var delaySegments: UISegmentedControl!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var savior: RealmSavior!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if getInterfaces() {
            
        }

        self.title = "Configure Device"
        self.makeCloseButton()
        if (self.savior.stype == 0) {
            // water
            powerSegments.isHidden = false
            waterView.isHidden = true
        } else if (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24)  {
            waterView.isHidden = false
            powerSegments.isHidden = true
            topConstraint.constant = 10
        } else {
            // energy
            waterView.isHidden = true
            powerSegments.isHidden = true
        }
        
        if let num_mins = savior.num_mins {
            minutes.text = num_mins
        }
        if let sdn_string = savior.sdn_string {
            if (savior.relay_default) {
                delaySegments.selectedSegmentIndex = 0
            } else if sdn_string == "sdn2 mins:3" {
                delaySegments.selectedSegmentIndex = 1
            } else if sdn_string == "sdn2 mins:4" {
                delaySegments.selectedSegmentIndex = 2
            } else if sdn_string == "sdn2 mins:0" {
                powerSegments.selectedSegmentIndex = 0
            }
        }
        
        if let network = self.savior.network {
            self.wifiField.text = network
        }
        if let password = self.savior.password {
            self.password.text = password
        }

    }

 
    @IBAction func clickWater(_ sender: Any) {
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSetDevice(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            self.savior.network = wifiField.text!
            self.savior.password = password.text!

            
            if (self.savior.stype == 0) {
                // water
                if self.powerSegments.selectedSegmentIndex == 0 {
                    self.savior.sdn_string = "sdn2 mins:0"
                } else {
                    self.savior.sdn_string = "sdn2 mins:1"
                }
            } else if (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24)  {
                self.savior.num_mins = minutes.text!
                if delaySegments.selectedSegmentIndex == 0 {
                    self.savior.sdn_string = "sdn\(self.savior.num_mins!) mins:2"
                    self.savior.relay_default = true
                } else if delaySegments.selectedSegmentIndex == 1 {
                    self.savior.sdn_string = "sdn2 mins:3"
                    self.savior.relay_default = false
                } else if delaySegments.selectedSegmentIndex == 2 {
                    self.savior.sdn_string = "sdn2 mins:4"
                    self.savior.relay_default = false
                }
            } else {
                // energy
                self.savior.sdn_string = "sdn"
            }
            
            self.savior.is_configured = true
        }
        print("IS CONFIGURED -->\(self.savior.is_configured)")

        let alert = UIAlertController(title: "Info", message: "Please restart the device, then select it in the manage screen to send data.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func getInterfaces() -> Bool {
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return false
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return false
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)") // en0
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                print("System error: \(interface) has no information")
                return false
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return false
            }
            for d in SSIDDict.keys {
                print("\(d): \(SSIDDict[d]!)")
                if d == "SSID" {
                    self.wifiField.text = SSIDDict[d]! as! String
                }
            }
        }
        return true
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