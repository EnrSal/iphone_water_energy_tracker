//
//  MainDeviceCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/8/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class MainDeviceCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var savior: RealmSavior!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signalImage: UIImageView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.register(DeviceNameSubCell.self, forCellReuseIdentifier: "DEVICE_NAME_SUBCELL")
        self.tableView.register(UINib(nibName: "DeviceNameSubCell", bundle: nil), forCellReuseIdentifier: "DEVICE_NAME_SUBCELL")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 44
        self.tableView.separatorStyle = .none

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func populate() {
        self.name.text = savior.alias!
        
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MMddyyyyHH:mm:ss"
        
        let datestr = formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        
        let req:GetDataRequest = GetDataRequest()
        req.mac = savior.savior_address!
        req.stype = savior.stype
        req.utct = datestr
        
        self.spinner.startAnimating()
        AzureApi.shared.getData(req: req, completionHandler: { (error:ServerError?, response:GetDataResponse?) in
            
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
            } else {
                if let response = response {
                    
                    let realm = try! Realm()
                    try! realm.write {
                        self.savior.last_sync = Date()
                        for device in response.Result {
                            
                            let dataPoint:RealmDataPoint = RealmDataPoint(fromDataPoint: device)
                            let current = realm.objects(RealmDataPoint.self).filter("identifier = '\(dataPoint.identifier!)'").first
                            if current == nil {
                                realm.add(dataPoint)
                                print("ADDED \(dataPoint)")
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                    }
                }
            }
            
        })
        
        
        
    }
    
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        switch savior.stype {
        case 0,1:
            return 2
        case 2:
            return 4
        case 4:
            return 8
        default:
            break
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DeviceNameSubCell = (self.tableView.dequeueReusableCell(withIdentifier: "DEVICE_NAME_SUBCELL", for: indexPath) as? DeviceNameSubCell)!
        
        switch indexPath.row {
        case 0:
            <#code#>
        default:
            break
        }
        
        
        return cell;
    }

}
