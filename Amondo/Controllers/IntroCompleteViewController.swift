//
//  IntroCompleteViewController.swift
//  Amondo
//
//  Created by James Bradley on 12/09/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import UIKit

class IntroCompleteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = PlopixKonamiGesture(target: self, action: #selector(forceLoadImprint(_:)))
        recognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(recognizer)

        
        // Do any additional setup after loading the view.
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    func forceLoadImprint(recognizer: UIGestureRecognizer) {
        if ( recognizer.state == .Ended ) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("imprintStart")
            UIApplication.sharedApplication().delegate!.window?!.rootViewController = viewController
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.contentView.addShadows(0, y: 2, alpha: 0.4, radius: 3)
        return cell
    }

}
