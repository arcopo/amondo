//
//  IntroPage4ViewController.swift
//  Amondo
//
//  Created by James Bradley on 30/08/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import UIKit

class IntroNotificationsViewController: UIViewController {
    @IBAction func remindMeButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))

        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Hey! Remember us?" // text that will be displayed in the notification
        notification.alertAction = "See last night's Imprint" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let now: NSDate! = NSDate()
        
        var fireDate: NSDate?
        
        if calendar.component(.Hour, fromDate: now) > 10 {
            let tomorrow = calendar.dateByAddingUnit(.Day, value: 1, toDate: now, options: [])!
            fireDate = calendar.dateBySettingHour(10, minute: 0, second: 0, ofDate: tomorrow, options: NSCalendarOptions.MatchFirst)!
        } else {
            fireDate = calendar.dateBySettingHour(10, minute: 0, second: 0, ofDate: now, options: NSCalendarOptions.MatchFirst)!
        }
        

        notification.fireDate = fireDate
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(fireDate, forKey: "notificationFireDate")
        defaults.synchronize()
        
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
