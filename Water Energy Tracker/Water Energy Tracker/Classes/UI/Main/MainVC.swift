//
//  MainVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/13/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class MainVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {

    var saviors:[RealmSavior] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(MainDeviceCell.self, forCellReuseIdentifier: "DEVICE_CELL")
        self.tableView.register(UINib(nibName: "MainDeviceCell", bundle: nil), forCellReuseIdentifier: "DEVICE_CELL")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        
        self.reload()
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom) as UIButton
        buttonBack.frame = CGRect(x: 0, y: 0, width: 40, height: 40) // CGFloat, Double, Int
        buttonBack.setImage(#imageLiteral(resourceName: "baseline_refresh_white_36pt"), for: UIControlState.normal)
        buttonBack.addTarget(self, action: #selector(clickRefresh(sender:)), for: UIControlEvents.touchUpInside)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -13
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        navigationItem.rightBarButtonItems = [negativeSpacer, rightBarButtonItem]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        let realm = try! Realm()
        let items = realm.objects(RealmSavior.self)
        saviors.removeAll()
        saviors.append(contentsOf: items)

        self.tableView.reloadData()
    }
    
    // MARK: - Actions

    @objc func clickRefresh(sender:UIButton?) {
        self.reload()
    }

    @IBAction func clickNotifications(_ sender: Any) {
    }

    @IBAction func clickManage(_ sender: Any) {
        let detailVC:ManageVC = ManageVC(nibName: "ManageVC", bundle: nil)
        self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.saviors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainDeviceCell = (self.tableView.dequeueReusableCell(withIdentifier: "DEVICE_CELL", for: indexPath) as? MainDeviceCell)!
        cell.owner = self
        cell.savior = self.saviors[indexPath.row]
        cell.populate()
        
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.saviors[indexPath.row].stype == 0 {
            let detailVC:DetailVC = DetailVC(nibName: "DetailVC", bundle: nil)
            detailVC.savior = self.saviors[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
