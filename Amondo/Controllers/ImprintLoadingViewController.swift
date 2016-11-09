//
//  ImprintLoadingViewController.swift
//  Amondo
//
//  Created by James Bradley on 06/09/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import Photos
import UIKit
import Parse
import CoreLocation

var curatedAssets = [AMDAsset]()

class ImprintLoadingViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.Authorized {
                let delay = 1 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
       //             self.performSegueWithIdentifier("showImprint", sender: self)
                }
            }
        }
        
        curatedAssets = [AMDAsset]()
        
        AMDAsset.retrieveAssetsForEvent("") { (error, assets) in
            curatedAssets=assets
            self.performSegueWithIdentifier("showImprint", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
