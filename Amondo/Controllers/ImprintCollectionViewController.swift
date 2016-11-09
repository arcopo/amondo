//
//  ImprintCollectionViewController.swift
//  Amondo
//
//  Created by James Bradley on 16/06/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

//import Analytics
import Photos
import UIKit
import Parse




class ImprintCollectionViewController: UICollectionViewController {
    
    var currentSection = 0
    var navigationDirection: Direction?
    var transitionLayout: UICollectionViewTransitionLayout?
    var transitionInProgress = false
    var finalLayout: ImprintLayout?
    
    var assets = [AMDAsset]()
    var sections = [[AMDAsset]]()
    let damping:CGFloat = 1
    var initialFrames = [CGRect]()
    var selectedCell:NSIndexPath?
    
    let phmanager = PHImageManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitialLayout()
        self.collectionView!.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleGestureRecognizer(_:))))
        
        self.populateSections()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = sections[indexPath.section][indexPath.item]

        if item.type == "instagram" {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! ImageCollectionViewCell
            
            //cell.file = item.object?.valueForKey("file") as? PFFile
            
            let file = item.object?.valueForKey("file") as? PFFile
            if item.coverImage != nil {
                cell.imageView.image=item.coverImage
            } else {
                cell.imageView.image=nil
                
                file?.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) in
                    if error == nil {
                        let result = UIImage(data: data!)
                        cell.imageView.image = result
                        item.coverImage=result
                    }
                })
            }
            
            cell.alpha=1
            return cell
        } else if item.type == "spotify" {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! ImageCollectionViewCell
            
            let file = item.object?.valueForKey("file") as? PFFile
            
            if item.coverImage != nil {
                cell.imageView.image=item.coverImage
            } else {
                cell.imageView.image=nil
                
                file?.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) in
                    if error == nil {
                        let result = UIImage(data: data!)
                        cell.imageView.image = result
                        item.coverImage=result
                    }
                })
            }
            
            cell.alpha=1
            return cell
        } else if item.type == "article" {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! ImageCollectionViewCell
            
            let file = item.object?.valueForKey("file") as? PFFile
            
            
            if item.coverImage != nil {
                cell.imageView.image=item.coverImage
            } else {
                cell.imageView.image=nil
                
                file?.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) in
                    if error == nil {
                        let result = UIImage(data: data!)
                        cell.imageView.image = result
                        item.coverImage=result
                    }
                })
            }
            
            cell.alpha=1
            return cell
        }
        
        print(item.type)
        
        
        switch item.asset!.mediaType {
        case .Image:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! ImageCollectionViewCell
            
     //       cell.asset = item.asset
            let option = PHImageRequestOptions()
            
            if item.coverImage != nil {
                cell.imageView.image=item.coverImage
            } else {
                cell.imageView.image=nil
                
                phmanager.requestImageForAsset(item.asset!, targetSize: cell.frame.size, contentMode: .AspectFill, options: option, resultHandler: {(result, info)->Void in
                    cell.imageView.image = result!
                    item.coverImage=result!
                })
            }
            
            cell.alpha=1
            return cell
        case .Video:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("video", forIndexPath: indexPath) as! VideoCollectionViewCell
            
            cell.asset = item.asset
            cell.alpha=1
            return cell
        
        default:
            return collectionView.dequeueReusableCellWithReuseIdentifier("unsupported", forIndexPath: indexPath)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset = sections[indexPath.section][indexPath.item]
        showDetailViewForAsset(asset, atIndex: indexPath)
    }
    
    func populateSections() {
       
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let result = PHAsset.fetchAssetsWithOptions(options)

        let defaults = NSUserDefaults.standardUserDefaults()
        let fireDate = defaults.objectForKey("notificationFireDate") as! NSDate
        
        let startDate = fireDate.dateByAddingTimeInterval(NSTimeInterval(-86400))
        
        result.enumerateObjectsUsingBlock { (object, int, pointer) in
            
            let asset = object as! PHAsset
            
            var id = "devicePhoto"
            if asset.mediaType == .Image {
                id = "devicePhoto"
            } else if asset.mediaType == .Video {
                id = "deviceVideo"
            }
            
            let amdasset = AMDAsset(type: id)
            amdasset.asset=asset
            amdasset.location=asset.location
            
            if (asset.creationDate!.compare(startDate) == .OrderedDescending){ self.assets.append(amdasset) }
        }
        
        for el in curatedAssets {
            assets.append(el)
        }
        
//        setBackground(assets[(assets.count/2)])
        
        let availableSizes = [2,4,5,6,7,8]

        
        while assets.count >= availableSizes.minElement()! {
            let random = Int(arc4random_uniform(UInt32(availableSizes.count)))
            let randomSize = availableSizes[random]
            if assets.count >= randomSize {
                let sectionItems = Array(assets[0..<randomSize]) as [AMDAsset]
                sections.append(sectionItems)
                assets.removeRange(0..<randomSize)
            }
        }
        
    }
    
    
}

//UI Methods
extension ImprintCollectionViewController {
    
    func hideCells(showCell:UICollectionViewCell){
        initialFrames.removeAll()
        for cell in collectionView!.visibleCells() {
            initialFrames.append(cell.frame)
            print(cell.frame.origin.x)
            if cell == showCell {
                //         cell.alpha=0
            } else {
                cell.alpha=1
            }
            if cell.frame.origin.x <= 10 {
                UIView.animateWithDuration(0.3, animations: {
                    cell.frame.origin.x = -cell.frame.width
                    }, completion: nil)
            } else {
                UIView.animateWithDuration(0.3, animations: {
                    cell.frame.origin.x = self.view.bounds.width
                    }, completion: nil)
            }
        }
    }
    
    func showCells(){
        
        
        
        for cell in collectionView!.visibleCells() {
            
            
            
            //  let isSelected = (cell == collectionView!)
            
            
            if cell.frame.origin.x == self.view.bounds.width {
                UIView.animateWithDuration(0.5, animations: {
                    cell.frame.origin.x -= cell.frame.width
                    }, completion: { (b:Bool) in
                        cell.alpha=1
                })
                
            } else {
                UIView.animateWithDuration(0.5, animations: {
                    cell.frame.origin.x += cell.frame.width
                    }, completion: { (b:Bool) in
                        cell.alpha=1
                })
                
            }
        }
        
    }
    
    
    func setInitialLayout() -> ImprintLayout {
        let initialLayout = ImprintLayout()
        initialLayout.delegate = self
        self.collectionView!.collectionViewLayout = initialLayout
        return initialLayout
    }
    
    func setFinalLayout() -> ImprintLayout {
        finalLayout = ImprintLayout()
        finalLayout?.delegate = self
        finalLayout?.currentSection = nextSection()
        return finalLayout!
    }
    
    func handleGestureRecognizer(gesture: UIPanGestureRecognizer) {
        
        
        
        if (gesture.direction! == .Left || gesture.direction! == .Right) {
            //          self.collectionView!.cancelInteractiveTransition()
            //return
            guard let transitionLayout = self.transitionLayout else {return}
            transitionLayout.transitionProgress = abs(gesture.translationInView(self.collectionView!).y / self.view.frame.height)
        }
        
        // Determine Direction
        
        if self.navigationDirection == nil {
            configureTriggerPanGesture(gesture.direction!)
        }
        
        
        if self.navigationDirection != nil {
            guard let transitionLayout = self.transitionLayout else {return}
            
            switch navigationDirection! {
            case .Up:
                transitionLayout.transitionProgress = -gesture.translationInView(self.collectionView!).y / self.view.frame.height
            case .Down:
                transitionLayout.transitionProgress = gesture.translationInView(self.collectionView!).y / self.view.frame.height
            default: break
            }
            
            if (gesture.state == .Ended) {
                if !self.transitionInProgress { return }
                
                if (transitionLayout.transitionProgress > 0.5 || abs(gesture.velocityInView(self.collectionView).y) > 200) {
                    
                    
                    if sections.indices.contains(nextSection()) {
                        self.collectionView!.finishInteractiveTransition()
                    } else if navigationDirection == .Up && (sections.endIndex - 1) == currentSection {
                        self.performSegueWithIdentifier("imprintFinished", sender: self)
                    } else {
                        self.collectionView!.cancelInteractiveTransition()
                    }
                } else {
                    
                    
                    self.collectionView!.cancelInteractiveTransition()
                }
                
                self.transitionInProgress = false
            }
        }
    }
    
    func configureTriggerPanGesture(direction: Direction) {
        self.navigationDirection = direction
        self.transitionInProgress = true
        
        self.transitionLayout = self.collectionView!.startInteractiveTransitionToCollectionViewLayout(self.setFinalLayout(), completion: { (completed, finished) -> Void in
            
            if finished {
                self.currentSection = self.nextSection()
                
                //            SEGAnalytics.sharedAnalytics().track("Imprint Navigated", properties: ["direction": self.navigationDirection!.rawValue])
                
                
            }
            
            if completed {
                // Animation done, regardless of state
                
                self.transitionLayout = nil
                self.navigationDirection = nil
            }
        })
    }
    
    func nextSection() -> Int {
        switch self.navigationDirection! {
        case .Down:
            return self.currentSection - 1
        case .Up:
            return self.currentSection + 1
        default:
            return 0
        }
    }
    
    func setBackground(asset: PHAsset) {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        
        manager.requestImageForAsset(asset, targetSize: self.collectionView!.frame.size, contentMode: .AspectFill, options: option, resultHandler: {(result, info)->Void in
            
            let background = UIImageView(image: result!)
            background.frame = self.collectionView!.frame
            background.alpha = 0.1
            self.collectionView?.backgroundView = background
        })
        
    }
}

extension ImprintCollectionViewController {
    func showDetailViewForAsset(asset:AMDAsset, atIndex:NSIndexPath){
       
        let indexPath = atIndex
        let assetType = asset.type
        
        
        if assetType == "instagram" {
            
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
            cell.alpha=0
            self.hideCells(cell)
            selectedCell=indexPath
            cell.alpha=0
            
            
            let vc = storyboard?.instantiateViewControllerWithIdentifier("InstagramVC") as! InstagramViewController
            
            vc.asset=asset
            vc.image=cell.imageView.image!
            vc.initialFrame=collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!.frame
            addChildViewController(vc)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(vc.view)
            
            NSLayoutConstraint.activateConstraints([
                vc.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
                vc.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
                vc.view.topAnchor.constraintEqualToAnchor(view.topAnchor),
                vc.view.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)])
            vc.didMoveToParentViewController(self)
            
            return
        } else if assetType == "facebook" {
            
        } else if assetType == "article" {
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
            cell.alpha=0
            self.hideCells(cell)
            selectedCell=indexPath
            cell.alpha=0
            
            
            let vc = storyboard?.instantiateViewControllerWithIdentifier("ArticleVC") as! ArticleViewController
            
            vc.asset=asset
            vc.image=cell.imageView.image!
            vc.initialFrame=collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!.frame
            addChildViewController(vc)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(vc.view)
            
            NSLayoutConstraint.activateConstraints([
                vc.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
                vc.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
                vc.view.topAnchor.constraintEqualToAnchor(view.topAnchor),
                vc.view.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)])
            vc.didMoveToParentViewController(self)
        } else if assetType == "spotify" {
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
            cell.alpha=0
            self.hideCells(cell)
            selectedCell=indexPath
            cell.alpha=0
            
            
            let vc = storyboard?.instantiateViewControllerWithIdentifier("SpotifyVC") as! SpotifyViewController
            
            vc.asset=asset
            vc.image=cell.imageView.image!
            vc.initialFrame=collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!.frame
            addChildViewController(vc)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(vc.view)
            
            NSLayoutConstraint.activateConstraints([
                vc.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
                vc.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
                vc.view.topAnchor.constraintEqualToAnchor(view.topAnchor),
                vc.view.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)])
            vc.didMoveToParentViewController(self)
        } else if assetType == "devicePhoto" {
            
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
            cell.alpha=0
            self.hideCells(cell)
            selectedCell=indexPath
            cell.alpha=0
            
            
            let vc = storyboard?.instantiateViewControllerWithIdentifier("InstagramVC") as! InstagramViewController
            
            vc.asset=asset
            vc.image=cell.imageView.image!
            vc.initialFrame=collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!.frame
            
            addChildViewController(vc)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(vc.view)
            
            NSLayoutConstraint.activateConstraints([
                vc.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
                vc.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
                vc.view.topAnchor.constraintEqualToAnchor(view.topAnchor),
                vc.view.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)])
            vc.didMoveToParentViewController(self)
            let manager = PHImageManager.defaultManager()
            let option = PHImageRequestOptions()
            
            manager.requestImageForAsset(asset.asset!, targetSize: self.view.frame.size, contentMode: .AspectFill, options: option, resultHandler: {(result, info)->Void in
                vc.imageView.image=result
                vc.transitionImageView.image=result
            })
            return
        } else if assetType == "deviceVideo" {
            
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! VideoCollectionViewCell
            cell.alpha=0
            self.hideCells(cell)
            selectedCell=indexPath
            cell.alpha=0
           
            let vc = storyboard?.instantiateViewControllerWithIdentifier("InstagramVC") as! InstagramViewController
            
            vc.asset=asset
            
            vc.initialFrame=collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!.frame
            vc.avPlayer = cell.avPlayer
            addChildViewController(vc)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(vc.view)
            
            NSLayoutConstraint.activateConstraints([
                vc.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
                vc.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
                vc.view.topAnchor.constraintEqualToAnchor(view.topAnchor),
                vc.view.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)])
            vc.didMoveToParentViewController(self)
            let manager = PHImageManager.defaultManager()
            let option = PHImageRequestOptions()
            
            manager.requestImageForAsset(cell.asset!, targetSize: self.view.frame.size, contentMode: .AspectFill, options: option, resultHandler: {(result, info)->Void in
                vc.imageView.image=result
                vc.transitionImageView.image=result
            })
            return
        }
        
        
 
 
    }
}
