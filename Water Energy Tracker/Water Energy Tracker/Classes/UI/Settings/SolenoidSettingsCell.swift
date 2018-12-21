//
//  SolenoidSettingsCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 12/20/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class SolenoidSettingsCell: UITableViewCell {

    @IBOutlet weak var user_gpm: UILabel!
    @IBOutlet weak var user_cflow: UILabel!
    @IBOutlet weak var user_relay: UILabel!
    var savior: RealmSavior!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate() {
        
        self.user_cflow.text = ""
        self.user_gpm.text = ""
        self.user_relay.text = ""

        let genericRequest = GenericRequest()
        genericRequest.name = self.savior.savior_address!
        
        AzureApi.shared.getAdditionalConfig(req: genericRequest) { (error:ServerError?, response:AdditionalConfigResponse?) in
            if let error = error {
                print("ERROR \(error)")
            } else {
                if let response = response {
                    DispatchQueue.main.async {
                        self.user_cflow.text = response.UserCFlow
                        self.user_gpm.text = response.UserGPM
                        self.user_relay.text = response.UserRelay
                    }
                    
                }
                
            }
        }
        

        
    }
    
}
