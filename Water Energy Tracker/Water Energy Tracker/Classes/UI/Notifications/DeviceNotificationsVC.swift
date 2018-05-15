//
//  DeviceNotificationsVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class DeviceNotificationsVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var notifications:[RealmNotification] = []
    var savior: RealmSavior!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = savior.alias!
        
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: "NOTIFICATION_CELL")
        self.tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NOTIFICATION_CELL")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .singleLine
        
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
        let items = realm.objects(RealmNotification.self).filter("mac_address = '\(savior.savior_address!)'").sorted(byKeyPath: "time", ascending: false)
        notifications.removeAll()
        notifications.append(contentsOf: items)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func clickRefresh(sender:UIButton?) {
        self.reload()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = (self.tableView.dequeueReusableCell(withIdentifier: "NOTIFICATION_CELL", for: indexPath) as? NotificationCell)!
        cell.notification = self.notifications[indexPath.row]
        cell.populate()
        
        return cell;
    }
    


}
