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
      //  self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom) as UIButton
        buttonBack.frame = CGRect(x: 0, y: 0, width: 40, height: 40) // CGFloat, Double, Int
        buttonBack.setImage(#imageLiteral(resourceName: "baseline_refresh_white_36pt"), for: UIControlState.normal)
        buttonBack.addTarget(self, action: #selector(clickRefresh(sender:)), for: UIControlEvents.touchUpInside)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -13
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        navigationItem.rightBarButtonItems = [negativeSpacer, rightBarButtonItem]

        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue:"DeviceAddedEvent"),
                                               object:nil, queue:nil,
                                               using:catchNotification)

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reload()
    }

    func catchNotification(notification: Notification) -> Void {
        print("GOT NOTIFICATION")
        DispatchQueue.main.async {
            self.reload()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        let realm = try! Realm()
        let items = realm.objects(RealmSavior.self)
        saviors.removeAll()
        
        var waterList:[RealmSavior] = []
        var energyList:[RealmSavior] = []
        var tempList:[RealmSavior] = []

        for item in items {
            if item.name == nil {
                try! realm.write {
                    item.name = ""
                }
            }
            if item.stype == Constants.water_stype || item.stype == Constants.water_gals_stype || item.stype == Constants.water_gals2_stype || item.stype == Constants.water_gals4_stype || item.stype == Constants.water_gals8_stype {
                waterList.append(item)
            } else if item.stype == Constants.temperature_only_stype || item.stype == Constants.remote_well {
                tempList.append(item)
            } else {
                energyList.append(item)
            }
        }
        
        saviors.append(contentsOf: waterList.sorted(by: { $0.name! > $1.name! }))
        saviors.append(contentsOf: energyList.sorted(by: { $0.name! > $1.name! }))
        saviors.append(contentsOf: tempList.sorted(by: { $0.name! > $1.name! }))
        print("RELOAD")
        self.tableView.reloadData()
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        self.title = "Last update: \(formatter.string(from: Date()))"
    }
    
    // MARK: - Actions

    @objc func clickRefresh(sender:UIButton?) {
        self.reload()
    }

    @IBAction func clickNotifications(_ sender: Any) {
        let detailVC:NotificationsVC = NotificationsVC(nibName: "NotificationsVC", bundle: nil)
        self.navigationController?.pushViewController(detailVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 165
        
        switch self.saviors[indexPath.row].stype {
        case 0,20:
            height -= 44
        case 1,21,31:
            height += 1*44
        case 2,22,32:
            height += 3*44
        case 4,24,34:
            height += 7*44
        default:
            break
        }
        
        return CGFloat(height)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        if self.saviors[indexPath.row].isValidDevice() && (self.saviors[indexPath.row].stype == 0 || self.saviors[indexPath.row].stype == 20 || self.saviors[indexPath.row].stype == Constants.temperature_only_stype || self.saviors[indexPath.row].stype == Constants.remote_well || self.saviors[indexPath.row].stype == Constants.gas) {
            
            let realm = try! Realm()
            let items = realm.objects(RealmDataPoint.self).filter("mac = '\(self.saviors[indexPath.row].savior_address!)'").sorted(byKeyPath: "timestamp", ascending: false)
            if items.count == 0 {
                return
            }
            
            
            let detailVC:DetailVC = DetailVC(nibName: "DetailVC", bundle: nil)
            detailVC.savior = self.saviors[indexPath.row]
            if self.saviors[indexPath.row].stype == 20 {
                detailVC.energy_unit = 1
            }
            print("2 DID CLICK HERE")
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
