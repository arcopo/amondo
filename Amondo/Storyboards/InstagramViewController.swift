//
//  InstagramViewController.swift
//  Amondo
//
//  Created by Timothy Whiting on 04/11/2016.
//  Copyright © 2016 Arcopo. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos
import GoogleMaps
import CoreLocation
import Parse


class InstagramViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableViewMap: UITableView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var initialFrame = CGRectMake(160, 320, 160, 80)
    var transitionImageView=UIImageView()
    var image = UIImage()
    var asset:AMDAsset!
    
    var imageHeight:CGFloat!
    @IBOutlet weak var imageHeightStrut: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeightStrut: NSLayoutConstraint!
    @IBOutlet weak var headerHeightStrut: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(image)
        print(asset)
        
        descriptionHeightStrut.constant=asset.instagram!.description!.heightForView(descriptionLabel.font, width: self.view.bounds.width-30)+47
        imageHeightStrut.constant=240//self.view.bounds.width*(image.size.height/image.size.width)
        headerHeightStrut.constant=imageHeightStrut.constant+descriptionHeightStrut.constant+46
        self.view.layoutIfNeeded()
        let head = tableView.tableHeaderView!
        let newFrame = headerView.bounds;
        head.frame=newFrame
        
        let head2 = tableViewMap.tableHeaderView!
        let newFrame2 = headerView.bounds;
        head2.frame=newFrame2
        
        //headerView.frame = newFrame;
        tableView.tableHeaderView=head
        tableViewMap.tableHeaderView=head2
        
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
        
        let imTap3 = UITapGestureRecognizer(target: self, action: "imTap")
        tableViewMap.tableHeaderView!.addGestureRecognizer(imTap3)
        
        let imTap2 = UITapGestureRecognizer(target: self, action: "imTap2")
        transitionImageView.addGestureRecognizer(imTap2)
        
        
        if asset.location != nil {
            scrollView.contentSize=CGSizeMake(self.view.bounds.width*2, self.view.bounds.height)
            scrollView.delegate=self
        }
        
        if asset.type == "deviceVideo" {
            self.avPlayer.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
            let layer = AVPlayerLayer(player: self.avPlayer)
     
            self.avPlayer.actionAtItemEnd = .None
            layer.frame = self.imageView.bounds
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: "playerItemDidReachEnd:",
                                                             name: AVPlayerItemDidPlayToEndTimeNotification,
                                                             object: self.avPlayer.currentItem)
            
            self.imageView.layer.addSublayer(layer)
            
            PHImageManager.defaultManager().requestAVAssetForVideo(self.asset.asset!, options: PHVideoRequestOptions()) { (asset, audio, dictionary) in
                self.avPlayer.replaceCurrentItemWithPlayerItem(AVPlayerItem(asset: asset!))
            }
        }
        
        if asset.type == "instagram" {
            usernameLabel.text = asset.instagram?.username
            dateLabel.text = "INSTAGRAM •"
            descriptionLabel.text = asset.instagram?.description
            likesLabel.text="\(asset.instagram!.likes)"
            locationLabel.text=asset.instagram?.location
            (asset.object?.valueForKey("icon") as! PFFile).getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
                if error == nil {
                    let im = UIImage(data: data!)
                    self.logoImage.image=im
                }
            }
        }
        
        
        
    }
    
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.avPlayer.seekToTime(kCMTimeZero)
        self.avPlayer.play()
    }
    
    var avPlayer = AVPlayer()
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" && self.avPlayer.status == .ReadyToPlay {
            self.avPlayer.play()
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
        headerView.frame.origin.y=self.view.bounds.height-imageView.bounds.height
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
        transitionImageView.frame.origin.y=headerView.frame.origin.y
        UIView.animateWithDuration(0.5, animations: {
            self.tableView.frame.origin.y=self.view.bounds.height-self.imageView.bounds.height
            self.transitionImageView.frame=self.initialFrame
            
            self.tableViewMap.frame.origin.y=self.view.bounds.height-self.imageView.bounds.height
            
            self.tableView.contentOffset.y=0
            self.tableViewMap.contentOffset.y=0
            self.headerView.frame.origin.y=self.view.bounds.height//-self.imageView.bounds.height
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
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
    
        print(scrollView.tag)
        if scrollView.tag != 1 {
            return
        }
        
        
        
        if scrollView.contentOffset.y < 0 {
            headerView.frame.origin.y = 0
        } else {
            headerView.frame.origin.y = -scrollView.contentOffset.y
        }
        
        if scrollView == tableView {
            tableViewMap.contentOffset.y=scrollView.contentOffset.y
        } else {
            tableView.contentOffset.y=scrollView.contentOffset.y
        }
    }

}

extension InstagramViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == tableViewMap {
            if asset.location == nil {
                return 0
            }
            return 2
        }
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableViewMap {
            return 1
        }
        
        if section == 0 {
            return 1
        } else {
            // Comments
            return asset.instagram!.comments.count
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableViewMap {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
                return cell
            } else  {
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
                let camera = GMSCameraPosition.cameraWithLatitude(asset.location!.coordinate.latitude, longitude: asset.location!.coordinate.longitude, zoom: 12.0)
                let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
                mapView.myLocationEnabled = true
                mapView.frame=cell.contentView.frame
        //        mapView.userInteractionEnabled=false
                cell.contentView.addSubview(mapView)// = mapView
                mapView.tag = -1
                
                // Creates a marker in the center of the map.
                let marker = GMSMarker()
          
                marker.position = CLLocationCoordinate2D(latitude: asset.location!.coordinate.latitude, longitude: asset.location!.coordinate.longitude)
                marker.title = "Sydney"
                marker.snippet = "Australia"
                marker.map = mapView
                
                do {
                    // Set the map style by passing the URL of the local file.
                    if let styleURL = NSBundle.mainBundle().URLForResource("MapStyle", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } catch {
                    NSLog("The style definition could not be loaded: \(error)")
                }
                
                
                return cell
            }
        
        }
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            for l in cell.contentView.subviews {
                if l.isKindOfClass(UILabel) {
                    (l as! UILabel).text = "\(asset.instagram!.comments.count) comments"
                }
            }
            return cell
        } else  {
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentCell
            cell.setLabels(asset.instagram!.comments[indexPath.row])
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == tableViewMap {
            if indexPath.section==0{
                return 40
            }
            let tvSize = self.tableView.contentSize.height-40-self.tableView.tableHeaderView!.frame.size.height
            if tvSize>self.view.bounds.height && tvSize > 0 {
             //   return tvSize
            }
            return self.view.bounds.height-40
        }
        if indexPath.section == 0 {
            return 40
        } else  {
            
            let font = UIFont(name: "AvenirNext-Regular", size: 15)!
            
            return (asset.instagram!.comments[indexPath.row]["comment"] as! String).heightForView(font,width:self.view.bounds.width-38)+45//155
        }
    }
}
