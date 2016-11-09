//
//  LoaderImage.swift
//  Amondo
//
//  Created by James Bradley on 07/09/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import UIKit

class LoaderImage: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.animationImages = (1...11).map { (i) -> UIImage in
            UIImage(named: "loader/frame-\(i).png")!
        }
        self.animationDuration = 1.3
        self.startAnimating()
    }
}
