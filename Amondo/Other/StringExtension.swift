//
//  StringExtension.swift
//  Amondo
//
//  Created by James Bradley on 20/07/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func highlight(highlight: String) -> NSMutableAttributedString {
        
        let range = (self as NSString).rangeOfString(highlight)
        
        let attributedString = NSMutableAttributedString(string:self)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.00, green:0.75, blue:0.79, alpha:1.0), range: range)
        
        return attributedString
    }
}
