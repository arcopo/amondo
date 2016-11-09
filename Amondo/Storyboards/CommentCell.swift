//
//  CommentCell.swift
//  Amondo
//
//  Created by Timothy Whiting on 09/11/2016.
//  Copyright © 2016 Arcopo. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    func setLabels(comment:[String:AnyObject]){
        commentLabel.text = comment["comment"] as? String
        infoLabel.text = comment["username"] as? String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
