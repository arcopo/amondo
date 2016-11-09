//
//  ArticleViewController.swift
//  Amondo
//
//  Created by Timothy Whiting on 04/11/2016.
//  Copyright © 2016 Arcopo. All rights reserved.
//

import UIKit
import Parse

class ArticleViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var initialFrame = CGRectMake(160, 320, 160, 80)
    var transitionImageView=UIImageView()
    var image = UIImage()
    var asset:AMDAsset!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image=image
        transitionImageView.frame=initialFrame
        transitionImageView.contentMode = .ScaleAspectFill
        transitionImageView.image=image
        transitionImageView.clipsToBounds=true
        transitionImageView.userInteractionEnabled=true
        imageView.userInteractionEnabled=true
        self.view.addSubview(transitionImageView)
        // Do any additional setup after loading the view.
        
        let imTap = UITapGestureRecognizer(target: self, action: "imTap")
        tableView.tableHeaderView!.addGestureRecognizer(imTap)
        
        let imTap2 = UITapGestureRecognizer(target: self, action: "imTap2")
        transitionImageView.addGestureRecognizer(imTap2)
        // Do any additional setup after loading the view.
        
        (asset.object?.valueForKey("icon") as! PFFile).getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            if error == nil {
                let im = UIImage(data: data!)
                self.logoImage.image=im
            }
        }
    }
    
    func imTap(){
        closeAnimation()
    }
    func imTap2(){
        initialAnimation()
    }
    
    override func viewWillAppear(animated: Bool) {
        initialAnimation()
    }
    
    func initialAnimation(){
        imageView.alpha=0
        self.transitionImageView.alpha=1
        tableView.frame.origin.y=self.view.bounds.height-imageView.bounds.height
        //   headerView.frame.origin.y=self.view.bounds.height-imageView.bounds.height
        UIView.animateWithDuration(0.5, animations: {
            self.headerView.frame.origin.y=0
            self.tableView.frame.origin.y=0
            self.transitionImageView.frame=self.imageView.bounds
        }) { (b:Bool) in
            self.imageView.alpha=1
            self.transitionImageView.alpha=0
            
        }
    }
    func closeAnimation(){
        
        let parent = self.parentViewController as! ImprintCollectionViewController
        parent.showCells()
        
        imageView.alpha=0
        transitionImageView.alpha=1
        transitionImageView.frame.origin.y = -tableView.contentOffset.y
        UIView.animateWithDuration(0.5, animations: {
            self.tableView.frame.origin.y=self.view.bounds.height-self.imageView.bounds.height
            self.transitionImageView.frame=self.initialFrame
            self.tableView.contentOffset.y=0
            //           self.headerView.frame.origin.y=self.view.bounds.height
        }) { (b:Bool) in
            parent.collectionView?.reloadData()
            self.view.removeFromSuperview()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            headerView.frame.origin.y = scrollView.contentOffset.y
        } else {
            headerView.frame.origin.y=0
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
    
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return 1
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell0", forIndexPath: indexPath)
            return cell
        } else  {
            let cell = tableView.dequeueReusableCellWithIdentifier("webCell", forIndexPath: indexPath)
            let webView = UIWebView(frame: cell.contentView.bounds)
            let url = NSURL(string: asset.article!.url!);
            let requestObj = NSURLRequest(URL: url!);
            webView.loadRequest(requestObj);
            cell.addSubview(webView)
            webView.backgroundColor=UIColor.clearColor()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            tableView.setContentOffset(CGPointZero, animated: true)
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 117
        }else  {
            return self.view.bounds.height-117
        }
    }
}
