//
//  FeedbackViewController.swift
//  Amondo
//
//  Created by James Bradley on 10/09/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

//import Siesta
import UIKit

class FeedbackViewController: UIViewController, UITableViewDataSource{
    
    
    @IBOutlet weak var feedbackOptionTable: UITableView!
    var questions = [[String:AnyObject]]()
//    var responseResource: Resource?
  //  var questionResource: Resource?

    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackOptionTable.dataSource = self
//        let api = Service(baseURL: "https://jbrew.fwd.wf")
 //       let api = Service(baseURL: "https://amondo-feedback-production.herokuapp.com")
   //     self.responseResource = api.resource("responses")
     //   self.questionResource = api.resource("questions")
        
   //     questionResource?.addObserver(self)
     //   questionResource?.loadIfNeeded()
        
        if (feedbackOptionTable.contentSize.height < feedbackOptionTable.frame.size.height) {
            feedbackOptionTable.scrollEnabled = false;
        } else {
            feedbackOptionTable.scrollEnabled = true;
        }
        
        feedbackOptionTable.allowsSelection = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /*
    func resourceChanged(resource: Resource, event: ResourceEvent) {
        self.questions = resource.jsonArray as! [[String : AnyObject]]
        feedbackOptionTable.reloadData()
    }
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = feedbackOptionTable.dequeueReusableCellWithIdentifier("feedbackCell") as! FeedbackTableViewCell
        cell.remoteData = questions[indexPath.item]
        return cell
    }
    
    func submitFeedback() {
        let cells = feedbackOptionTable.visibleCells as! [FeedbackTableViewCell]
        let data = cells.map { (cell) -> [String: AnyObject] in

            return [
                "question_id": cell.remoteData!["id"] as! Int,
                "response": cell.response!.on,
                "device_id": UIDevice.currentDevice().identifierForVendor!.UUIDString
            ]
        }
        
        do {
    //        let jsondata = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
  //          responseResource!.request(.POST, data: jsondata, contentType: "application/json")
        } catch {
            return
        }
        
    }

    @IBAction func submitButtonPressed(sender: UIButton) {
        submitFeedback()
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
