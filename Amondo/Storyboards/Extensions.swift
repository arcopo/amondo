//
//  Extensions.swift
//  Amondo
//
//  Created by Timothy Whiting on 08/11/2016.
//  Copyright © 2016 Arcopo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadows(x:CGFloat,y:CGFloat,alpha:Float,radius:CGFloat){
        self.layer.shadowColor=UIColor.blackColor().CGColor
        self.layer.shadowOpacity=alpha
        self.layer.shadowOffset=CGSize(width: x, height: y)
        self.layer.shadowRadius=radius
    }
}

extension String {
    
    func heightForView(font:UIFont, width:CGFloat) -> CGFloat{
        let text = self
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }

}
