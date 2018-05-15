//
//  NotificationCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    var notification: RealmNotification!
    @IBOutlet weak var notification_text: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, h:mm a"
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!

        if let text = self.notification.text {
            self.notification_text.text = text
        }
        
        if let time = self.notification.time {
            self.time.text = formatter.string(from: time)
        }
        
    }
}
