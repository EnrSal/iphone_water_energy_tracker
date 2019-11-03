//
//  ScheduleVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/2/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class ScheduleVC: SaviorVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var savior: RealmSavior!
    @IBOutlet weak var collectionView: UICollectionView!
    var hours:[ScheduleItem] = Array(repeating: ScheduleItem(), count: 24)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for n in 0...23 {
            hours[n] = ScheduleItem()
        }
        
        self.title = "Current Schedule"
        self.makeCloseButton()
        
        collectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: "SCHEDULE_CELL")
        collectionView.register(UINib(nibName: "ScheduleCell", bundle:nil), forCellWithReuseIdentifier: "SCHEDULE_CELL")

        collectionView.backgroundColor = UIColor.clear
        collectionView.backgroundView = nil
        
        let req:ReadWriteScheduleRequest = ReadWriteScheduleRequest()
        req.name = savior.savior_address!
        req.Command = "WR:"
        self.showHud()
        AzureApi.shared.readWriteSchedule(req: req) { (error:ServerError?, response:GenericResponse?) in
            self.hideHud()
            if let response = response {
                let a = response.retstring!.split(separator: ":")
                let characters = Array(a[1])
                for (index, element) in characters.enumerated() {
                    self.hours[index].on = element == "1"
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }


    }
    // MARK: - Actions

    @IBAction func clickUpdate(_ sender: Any) {
        let req:ReadWriteScheduleRequest = ReadWriteScheduleRequest()
        req.name = savior.savior_address!
        req.Command = "W:"
        for item in self.hours {
            if item.on {
                req.Command! += "1"
            } else {
                req.Command! += "0"
            }
        }
        self.showHud()
        AzureApi.shared.readWriteSchedule(req: req) { (error:ServerError?, response:GenericResponse?) in
            self.hideHud()
            if let response = response {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

    }
    
    // MARK: - CollectionView

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ScheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCHEDULE_CELL", for: indexPath) as! ScheduleCell
        cell.item = self.hours[indexPath.row]
        cell.item.index = indexPath.row
        // cell.owner = self
        cell.populate()
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        
        let width = ((screenSize.width-2.0)/2.0)

        return CGSize(width: width, height: 50)
    }
    

}
