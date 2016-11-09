//
//  CompletionViewController.swift
//  Amondo
//
//  Created by James Bradley on 10/09/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

//import Intercom
import UIKit

class CompletionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chatButtonPressed(sender: UIButton) {
    //    Intercom.presentMessageComposer()
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
