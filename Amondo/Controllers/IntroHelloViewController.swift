//
//  IntroPage1ViewController.swift
//  Amondo
//
//  Created by James Bradley on 30/08/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import UIKit

class IntroHelloViewController: UIViewController {
    @IBOutlet weak var hConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        hConstraint.constant = view.frame.width - CGFloat(50)
        // Do any additional setup after loading the view.
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
