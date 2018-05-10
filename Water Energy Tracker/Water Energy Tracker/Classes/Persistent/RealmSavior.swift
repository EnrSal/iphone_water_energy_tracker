//
//  RealmSavior.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/25/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class RealmSavior: Object {

    @objc dynamic var mac_address: String? = nil
    @objc dynamic var savior_address: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var alias: String? = nil
    @objc dynamic var stype: Int = 0
    @objc dynamic var energy_unit_name_1: String? = nil
    @objc dynamic var energy_unit_name_2: String? = nil
    @objc dynamic var energy_unit_name_3: String? = nil
    @objc dynamic var energy_unit_name_4: String? = nil
    @objc dynamic var energy_unit_name_5: String? = nil
    @objc dynamic var energy_unit_name_6: String? = nil
    @objc dynamic var energy_unit_name_7: String? = nil
    @objc dynamic var energy_unit_name_8: String? = nil

    @objc dynamic var share_number: String? = nil
    @objc dynamic var temp_share_number: String? = nil
    @objc dynamic var share_number_prev: String? = nil
    @objc dynamic var temp_share_number_prev: String? = nil
    @objc dynamic var from_share: Bool = false
    @objc dynamic var share_number_used: String? = nil

    @objc dynamic var last_sync: Date? = nil
    @objc dynamic var is_registered: Bool = false
    @objc dynamic var num_notifications: Int = 0

    @objc dynamic var last_command_state: String? = nil
    @objc dynamic var last_command_sent: Date? = nil
    @objc dynamic var EnergyUnit: String? = nil
    @objc dynamic var EnergyUnitPerPulse: Double = 0
    
    
    func isValidDevice() -> Bool {
        if (!from_share) {
            return true
        }
        if ((share_number_used != nil) && (share_number_prev != nil) && (temp_share_number_prev != nil)) {
            if ((share_number_used! != share_number_prev!) && (share_number_used! != temp_share_number_prev!)) {
                return false
            }
        }
        return true
    }
    

}






