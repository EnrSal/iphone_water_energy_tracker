//
//  SendCommandVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/15/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class SendCommandVC: SaviorVC {

    @IBOutlet weak var lastSent: UILabel!
    @IBOutlet weak var commandSegments: UISegmentedControl!
    
    var savior: RealmSavior!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Send Command"
        self.makeCloseButton()
        
        if let last_command_sent = savior.last_command_sent, let last_command_state = savior.last_command_state {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy hh:mm a"
            
            self.lastSent.text = "\(last_command_state) (\(formatter.string(from: last_command_sent)))"
        } else {
            self.lastSent.text = "NONE"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickSend(_ sender: Any) {
        self.showHud()
        let req:SendCommandRequest = SendCommandRequest()
        req.name = savior.savior_address!
        req.Command = commandSegments.selectedSegmentIndex == 0 ? "ON" : "OFF"
        AzureApi.shared.sendCommand(req: req) { (error:ServerError?, response:GenericResponse?) in
            self.hideHud()
            if let error = error {
                self.showError(message: error.getMessage()!)
            } else {
                if response != nil {
                    let realm = try! Realm()
                    try! realm.write {
                        self.savior.last_command_sent = Date()
                        self.savior.last_command_state = req.Command
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
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
