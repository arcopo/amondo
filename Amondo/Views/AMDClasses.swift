import Photos
import UIKit
import Parse


class AMDAsset: NSObject {
    
    init(type:String) {
        self.type=type
    }
    
    var type:String!
    var asset:PHAsset?
    var location:CLLocation?
    var coverImage:UIImage?
    var object:PFObject? {
        didSet {
            if object != nil {
                
                self.type = object!["type"] as! String
                
                if self.type == "instagram" {
                    
                } else if self.type == "spotify" {
                    
                } else if self.type == ""{
                    
                }
                
            }
            
        }
    }
    var album: AMDSpotify?
    var instagram:AMDInstagram?
    var article:AMDArticle?

    class func retrieveAssetsForEvent(event:String, completion:(error:NSError?, assets:[AMDAsset])->()) {
        let query = PFQuery(className: "DataAssets")
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) in
            
            var assets = [AMDAsset]()
            
            if error == nil {
                
                
                
                for object in objects! {
                    
                    let type = object.valueForKey("type") as! String
                    let asset = AMDAsset(type: type)
                    asset.object=object
                    if let point = object["geopoint"] as? PFGeoPoint {
                        asset.location = CLLocation(latitude: point.latitude, longitude: point.longitude)
                    }
                    
                    if type == "spotify" {
                        let album = AMDSpotify()
                        album.artist=object.valueForKey("artist") as! String
                        album.album=object.valueForKey("album") as! String
                        album.tracks=object.valueForKey("tracks") as! [String]
                        asset.album=album
                    }
                    
                    if type == "instagram" {
                        let post = AMDInstagram()
                        post.comments=object["comments"] as! [[String:AnyObject]]
                        post.description=object["description"] as? String
                        post.location=object["location"] as? String
                        post.username=object["username"] as? String
                        post.likes=object["likes"] as! Int
                        post.geopoint=object["geopoint"] as? PFGeoPoint
                        asset.instagram=post
                    }
                    
                    if type == "article" {
                        let article = AMDArticle()
                        article.url=(object["url"] as? String)
                        asset.article=article
                    }
                    
                    assets.append(asset)
                }
                
            }
            
            completion(error: error, assets: assets)
        }
    }
    
}



class AMDSpotify {
    var album:String!
    var artist:String!
    var tracks:[String]!
}

class AMDInstagram {
    var geopoint:PFGeoPoint?
    var description:String?
    var username:String?
    var location:String?
    var likes:Int = 0
    var comments:[[String:AnyObject]] = []
}

class AMDArticle {
    var url:String?
    var description:String?
    var publisher:String?
    var stars:Int=0
}
