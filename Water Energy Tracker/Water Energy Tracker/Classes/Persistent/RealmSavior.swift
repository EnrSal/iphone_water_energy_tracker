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
    
    @objc dynamic var sdn_string: String? = "sdn2 m:0"
    @objc dynamic var network: String? = nil
    @objc dynamic var password: String? = nil
    @objc dynamic var num_mins: String? = "30"
    @objc dynamic var num_gpm: String? = "50"
    @objc dynamic var relay_default: Bool = true
    @objc dynamic var is_configured: Bool = false

    
    func isValidDevice() -> Bool {
        print("is valid from_share=\(from_share) share_number_prev=\(share_number_prev) temp_share_number_prev=\(temp_share_number_prev) share_number_used=\(share_number_used) temp_share_number_prev=\(temp_share_number_prev) ")
        if (!from_share) {
            print("1 is valid from_share=\(from_share)")
            return true
        }
        if ((share_number_used != nil) && (share_number_prev != nil) && (temp_share_number_prev != nil)) {
            if ((share_number_used! != share_number_prev!) && (share_number_used! != temp_share_number_prev!)) {
                print("1 is NOT valid from_share=\(from_share)")
                return false
            }
        }
        print("2 is valid from_share=\(from_share)")
        return true
    }
    

}






