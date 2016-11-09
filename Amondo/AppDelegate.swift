//
//  AppDelegate.swift
//  Amondo
//
//  Created by James Bradley on 01/05/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

//import Analytics
import CoreLocation
//import Intercom
import UIKit
import Parse
import GoogleMaps
let GMAPS_API_KEY = "AIzaSyAfpwTMOBDc2Npu4JRVBn_m_wOGzm4wuf0"


//  parse-dashboard --appId myAppId --masterKey myMasterKey --serverURL "http://amondo.herokuapp.com/parse" --appName Amondo-Dev


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let plist = NSBundle.mainBundle().infoDictionary
        
   //     let segmentConfig = SEGAnalyticsConfiguration(writeKey: plist!["segmentWriteKey"] as! String)
     //   segmentConfig.trackApplicationLifecycleEvents = true
       // segmentConfig.recordScreenViews = true
       // SEGAnalytics.setupWithConfiguration(segmentConfig!)
                
  //      Intercom.setApiKey(plist!["IntercomApiKey"] as! String,
    //                       forAppId: plist!["IntercomAppId"] as! String)

    //    Intercom.registerUnidentifiedUser()
        
        selectLandingPage()
        GMSServices.provideAPIKey(GMAPS_API_KEY)
        
        Parse.initializeWithConfiguration(ParseClientConfiguration(block: { (config:ParseMutableClientConfiguration) in
            config.applicationId="myAppId"
            config.clientKey="myMasterKey"
            config.server="http://amondo.herokuapp.com/parse"
        }))
        
      /*  let uri = NSURL(string: "spotify:album:58Dbqi6VBskSmnSsbXbgrs")
        SPTAlbum.albumWithURI(uri, accessToken: "c51bb68f3e194b1bbe386ad6f690a5e0", market: "GB") { (error:NSError!, ob:AnyObject!) in
            print(error)
 
        }*/
        
        let url = NSURL(string:"https://api.spotify.com/v1/albums/58Dbqi6VBskSmnSsbXbgrs?market=GB")!
   
       /*
      
        let data = NSData(contentsOfURL: url)!
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            print(json)
        } catch let error {
            
        }
        */
        
        let comment: [[String:AnyObject]] =
            [
                ["comment":"This is the comment",
                    "username":"@tim",
                "date":NSDate()],
                ["comment":"This is the secondcomment",
                    "username":"@jonny",
                    "date":NSDate()]
        ]
  /*      let ob = PFObject(className: "DataAssets")
        ob.setValue(comment, forKey: "comments")
        ob.saveInBackgroundWithBlock { (suc:Bool, error:NSError?) in
        
            
            print(suc)
            
            
        }
   */     
        /*
        let requestURL: NSURL = url
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
        
            
            
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    
                    let dictionary = json as! [String:AnyObject]
                    
                    let albumName = dictionary["name"] as! String
                    let albumArtists = (dictionary["artists"]![0] as! [String:AnyObject])["name"]
                    let tracks = (dictionary["tracks"] as! [String:AnyObject])
                    
                    print(albumName)
                    print(albumArtists)
                    print(tracks)
                } catch let error {
                    
                }
            }
        }
        
        task.resume()
 */
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        selectLandingPage()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    }
    
    func selectLandingPage() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(NSDate(), forKey: "notificationFireDate")
        
        let fireDate = defaults.objectForKey("notificationFireDate") as? NSDate
     
        if (fireDate != nil) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if fireDate!.compare(NSDate()) == .OrderedAscending {
                let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("imprintStart")
                self.window!.rootViewController = viewController
            } else {
                let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("introComplete")
                self.window!.rootViewController = viewController
            }
        }
    }
}
