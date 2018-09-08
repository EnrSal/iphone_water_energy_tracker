//
//  WifiSendDataVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 9/7/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import SwiftyBluetooth
import CoreBluetooth
import RealmSwift

class WifiSendDataVC: SaviorVC {

    let RX_SERVICE_UUID:String = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
    let RX_CHAR_UUID:String = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    var peripheral:Peripheral!
    var savior: RealmSavior!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.showHud()
        peripheral.connect(withTimeout: 30) { result in
            switch result {
            case .success:
                print("CONNECT SUCCESS")
                self.hideHud()
                self.doSend()
            break // You are now connected to the peripheral
            case .failure(let error):
                print("CONNECT ERROR \(error)")
                self.hideHud()
                self.showError(message: error.localizedDescription)
                break // An error happened while connecting
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func doSend() {
        
        print("TRY WRITE PERIPHERAL -->\(peripheral)")
        self.showHud()
        
        let data = "swn\(self.savior.network!)".data(using: String.Encoding.utf8)!
        self.peripheral.writeValue(ofCharacWithUUID: self.RX_CHAR_UUID,
                                   fromServiceWithUUID: self.RX_SERVICE_UUID,
                                   value: data) { result in
                                    switch result {
                                    case .success:
                                        print("WRITE SUCCESS -->swn\(self.savior.network!)")
                                        
                                        let data2 = "swp\(self.savior.password!)".data(using: String.Encoding.utf8)!
                                        self.peripheral.writeValue(ofCharacWithUUID: self.RX_CHAR_UUID,
                                                                   fromServiceWithUUID: self.RX_SERVICE_UUID,
                                                                   value: data2) { result in
                                                                    switch result {
                                                                    case .success:
                                                                        print("2WRITE SUCCESS -->swp\(self.savior.password!)")
                                                                        
                                                                        
                                                                        let data3 = self.savior.sdn_string!.data(using: String.Encoding.utf8)!
                                                                        self.peripheral.writeValue(ofCharacWithUUID: self.RX_CHAR_UUID,
                                                                                                   fromServiceWithUUID: self.RX_SERVICE_UUID,
                                                                                                   value: data3) { result in
                                                                                                    switch result {
                                                                                                    case .success:
                                                                                                        print("2WRITE SUCCESS -->\(self.savior.sdn_string!)")
                                                                                                        
                                                                                                        self.complete()
                                                                                                        
                                                                                                    break // The write was succesful.
                                                                                                    case .failure(let error):
                                                                                                        print("2WRITE ERROR \(error)")
                                                                                                        self.hideHud()
                                                                                                        self.showError(message: error.localizedDescription)
                                                                                                        break // An error happened while writting the data.
                                                                                                    }
                                                                        }

                                                                        
                                                                        /*
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
                                                                        }*/
                                                                        
                                                                        
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
    
    

}
