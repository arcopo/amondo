//
//  ImageCollectionViewCell.swift
//  Amondo
//
//  Created by James Bradley on 08/09/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import Photos
import UIKit
import Parse

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var asset: PHAsset? {
        didSet {
            let manager = PHImageManager.defaultManager()
            let option = PHImageRequestOptions()
            
            imageView.image=nil
            
            manager.requestImageForAsset(self.asset!, targetSize: self.frame.size, contentMode: .AspectFill, options: option, resultHandler: {(result, info)->Void in
                self.imageView.image = result!
            })
        }
    }
    
    var file: PFFile? {
        didSet {
            
            imageView.image=nil
            
            file?.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) in
                if error == nil {
                    let result = UIImage(data: data!)
                    self.imageView.image = result
                }
            })
        }
    }
}
