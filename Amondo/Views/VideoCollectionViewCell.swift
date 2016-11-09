//
//  VideoCollectionViewCell.swift
//  Amondo
//
//  Created by James Bradley on 09/09/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import AVKit
import AVFoundation
import Photos
import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    var avPlayer = AVPlayer()
    
    var asset: PHAsset? {
        didSet {
            self.avPlayer.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
            let layer = AVPlayerLayer(player: self.avPlayer)
            
            self.avPlayer.actionAtItemEnd = .None
            layer.frame = self.bounds
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            self.layer.addSublayer(layer)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: "playerItemDidReachEnd:",
                                                             name: AVPlayerItemDidPlayToEndTimeNotification,
                                                             object: self.avPlayer.currentItem)
            
            

             PHImageManager.defaultManager().requestAVAssetForVideo(self.asset!, options: PHVideoRequestOptions()) { (asset, audio, dictionary) in
                self.avPlayer.replaceCurrentItemWithPlayerItem(AVPlayerItem(asset: asset!))
            }
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.avPlayer.seekToTime(kCMTimeZero)
        self.avPlayer.play()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" && self.avPlayer.status == .ReadyToPlay {
            self.avPlayer.play()
        }
    }

}
