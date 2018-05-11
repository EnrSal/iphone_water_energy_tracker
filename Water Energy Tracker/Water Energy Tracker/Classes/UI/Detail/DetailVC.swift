//
//  DetailVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/10/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class DetailVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timeago: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var energy_unit:Int = 0
    var savior: RealmSavior!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(DetailWaterInfoCell.self, forCellReuseIdentifier: "WATER_INFO_CELL")
        self.tableView.register(UINib(nibName: "DetailWaterInfoCell", bundle: nil), forCellReuseIdentifier: "WATER_INFO_CELL")
        
        self.tableView.register(DetailEnergyInfoCell.self, forCellReuseIdentifier: "ENERGY_INFO_CELL")
        self.tableView.register(UINib(nibName: "DetailEnergyInfoCell", bundle: nil), forCellReuseIdentifier: "ENERGY_INFO_CELL")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.savior.stype == 0) {
            let cell:DetailWaterInfoCell = (self.tableView.dequeueReusableCell(withIdentifier: "WATER_INFO_CELL", for: indexPath) as? DetailWaterInfoCell)!
            
            cell.savior = self.savior
            cell.populate()
            
            return cell;
        }
        
        let cell:DetailEnergyInfoCell = (self.tableView.dequeueReusableCell(withIdentifier: "ENERGY_INFO_CELL", for: indexPath) as? DetailEnergyInfoCell)!
        
        cell.savior = self.savior
        cell.populate()
        
        return cell;

    }
    
}
