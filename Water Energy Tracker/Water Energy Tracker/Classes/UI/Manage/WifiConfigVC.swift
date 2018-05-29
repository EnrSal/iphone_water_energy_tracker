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

    let RX_SERVICE_UUID:String = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
    let RX_CHAR_UUID:String = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var waterSegments: UISegmentedControl!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var wifiField: UITextField!
    var peripheral:Peripheral!
    var savior: RealmSavior!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Configure Device"
        self.makeCloseButton()
        if getInterfaces() {
            
        }
        if savior.stype != 0 {
            waterLabel.isHidden = true
            waterSegments.isHidden = true
        }
        
        self.showHud()
        peripheral.connect(withTimeout: 30) { result in
            switch result {
            case .success:
                print("CONNECT SUCCESS")
                self.hideHud()
            break // You are now connected to the peripheral
            case .failure(let error):
                print("CONNECT ERROR \(error)")
                self.hideHud()
                self.showError(message: error.localizedDescription)
                break // An error happened while connecting
            }
        }

    }

    @IBAction func clickSetDevice(_ sender: Any) {
    
        print("TRY WRITE PERIPHERAL -->\(peripheral)")
        self.showHud()
        
        let data = "swn\(wifiField.text!)".data(using: String.Encoding.utf8)!
        self.peripheral.writeValue(ofCharacWithUUID: self.RX_CHAR_UUID,
                              fromServiceWithUUID: self.RX_SERVICE_UUID,
                              value: data) { result in
                                switch result {
                                case .success:
                                    print("WRITE SUCCESS -->swn\(self.wifiField.text!)")
                                    
                                    let data2 = "swp\(self.password.text!)".data(using: String.Encoding.utf8)!
                                    self.peripheral.writeValue(ofCharacWithUUID: self.RX_CHAR_UUID,
                                                          fromServiceWithUUID: self.RX_SERVICE_UUID,
                                                          value: data2) { result in
                                                            switch result {
                                                            case .success:
                                                                print("2WRITE SUCCESS -->swp\(self.password.text!)")
                                                                
                                                                if self.savior.stype == 0 {
                                                                    // send water
                                                                    var mins = "2 mins"
                                                                    switch self.waterSegments.selectedSegmentIndex {
                                                                    case 1:
                                                                        mins = "10 mins"
                                                                    case 2:
                                                                        mins = "20 mins"
                                                                    case 3:
                                                                        mins = "30 mins"
                                                                    case 4:
                                                                        mins = "60 mins"
                                                                    default:
                                                                        break
                                                                    }
                                                                    let data3 = "sdn\(mins)".data(using: String.Encoding.utf8)!
                                                                    self.peripheral.writeValue(ofCharacWithUUID: self.RX_CHAR_UUID,
                                                                                               fromServiceWithUUID: self.RX_SERVICE_UUID,
                                                                                               value: data3) { result in
                                                                                                switch result {
                                                                                                case .success:
                                                                                                    print("2WRITE SUCCESS -->sdn\(mins)")
                                                                                                    
                                                                                                    self.complete()

                                                                                                break // The write was succesful.
                                                                                                case .failure(let error):
                                                                                                    print("2WRITE ERROR \(error)")
                                                                                                    self.hideHud()
                                                                                                    self.showError(message: error.localizedDescription)
                                                                                                    break // An error happened while writting the data.
                                                                                                }
                                                                    }

                                                                } else {
                                                                    self.complete()
                                                                }
                                                                
                                                                
                                                            break // The write was succesful.
                                                            case .failure(let error):
                                                                print("2WRITE ERROR \(error)")
                                                                self.hideHud()
                                                                self.showError(message: error.localizedDescription)
                                                                break // An error happened while writting the data.
                                                            }
                                    }
                                    
                                    
                                break // The write was succesful.
                                case .failure(let error):
                                    print("WRITE ERROR \(error)")
                                    self.hideHud()
                                    self.showError(message: error.localizedDescription)
                                    break // An error happened while writting the data.
                                }
        }
    }
    
    func complete() {
        let data2 = "                  \n".data(using: String.Encoding.utf8)!
        self.peripheral.writeValue(ofCharacWithUUID: self.RX_CHAR_UUID,
                                   fromServiceWithUUID: self.RX_SERVICE_UUID,
                                   value: data2) { result in
                                    switch result {
                                    case .success:
                                        print("2WRITE SUCCESS -->                   \n")
                                        
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                                            self.hideHud()
                                            self.peripheral.disconnect(completion: { _ in ()
                                                self.dismiss(animated: true, completion: {
                                                    
                                                })
                                            })
                                        }
                                        
                                    break // The write was succesful.
                                    case .failure(let error):
                                        print("2WRITE ERROR \(error)")
                                        self.hideHud()
                                        self.showError(message: error.localizedDescription)
                                        break // An error happened while writting the data.
                                    }
        }
    }
 
    @IBAction func clickWater(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
