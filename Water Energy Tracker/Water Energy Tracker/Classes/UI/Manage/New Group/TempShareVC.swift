//
//  TempShareVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/3/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class TempShareVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var savior:RealmSavior!
    var selected:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Select Unit"
        self.makeCloseButton()
        self.tableView.register(TempShareCell.self, forCellReuseIdentifier: "TEMP_SHARE_CELL")
        self.tableView.register(UINib(nibName: "TempShareCell", bundle: nil), forCellReuseIdentifier: "TEMP_SHARE_CELL")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
    }
    
    
    @IBAction func clickGet(_ sender: Any) {
        UIPasteboard.general.string = savior.temp_share_number!
        if let selected = selected {
            self.showError(message: "temporary share number is: \(savior.temp_share_number!)\(selected) (saved to clipboard)")
        } else {
            self.showError(message: "temporary share number is: \(savior.temp_share_number!) (saved to clipboard)")
        }

    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if savior.stype == Constants.energy4_relay_stype {
            return 5
        } else if savior.stype == Constants.energy8_relay_stype {
            return 9
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TempShareCell = (self.tableView.dequeueReusableCell(withIdentifier: "TEMP_SHARE_CELL", for: indexPath) as? TempShareCell)!

        if indexPath.row == 0 {
            cell.sharenum.text = "All"
        } else {
            cell.sharenum.text = "\(indexPath.row)"
        }
        if let selected = selected {
            if selected == indexPath.row {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.accessoryType = .none
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        self.selected = indexPath.row
        self.tableView.reloadData()
    }
    
}
