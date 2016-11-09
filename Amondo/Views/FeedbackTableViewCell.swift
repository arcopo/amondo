//
//  FeedbackTableViewCell.swift
//  Amondo
//
//  Created by James Bradley on 10/09/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var response: UISwitch!
    
    var remoteData: [String: AnyObject]? {
        didSet {
            label.text = self.remoteData!["text"] as? String
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
