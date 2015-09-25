//
//  ImageCollectionViewController.swift
//  Smashtag
//
//  Created by Joe Isaacs on 25/09/2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit


class ImageCollectionViewController: UICollectionViewController {
    
    let imageCache = NSCache()
    
  
        @IBInspectable var startingSize: CGFloat = 200
        
        @IBInspectable var smallestSize: CGFloat = 20
    
    
    
    private struct MediaWithTweet {
        let media: MediaItem
        let tweet: Tweet
    }
    
    var scale: CGFloat = 1 {
        didSet {
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    var tweets: [Tweet]? {
        didSet {
            mediaItems = tweets?.flatMap {
                (tweet: Tweet) in
                return tweet.media.flatMap {
                    (media: MediaItem) in
                    return MediaWithTweet(media: media, tweet: tweet)
                }
            }
        }
    }
    
    private var mediaItems: [MediaWithTweet]?
    
    // MARK: - Storyboard
    
    struct Storyboard {
        static let ImageIconIdentifier = "Image Icon"
        
        static let ShowTweet = "Show Tweet"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "zoom:"))
    }


    func zoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(mediaItems?.count)
        return mediaItems?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.ImageIconIdentifier, forIndexPath: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            if let items = mediaItems {
                imageCell.tableViewCache = imageCache
                let item = items[indexPath.row]
                imageCell.url = item.media.url
                imageCell.tweet = item.tweet
            }
        }
        return cell
    }
  
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = max(min(collectionView.bounds.width, startingSize * scale), smallestSize)
        if let item = mediaItems?[indexPath.row].media {
            return CGSize(width: width, height: width / CGFloat(item.aspectRatio))
        }
        return CGSize(width: 0,height: 0)
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController
        if let navCon = destination as? UINavigationController {
            if let visible = navCon.visibleViewController {
                destination = visible
            }
        }
        if let identifier = segue.identifier {
        switch identifier {
            case Storyboard.ShowTweet:
                if let ttvc = destination as? TweetTableViewController {
                    if let imageCell = sender as? ImageCollectionViewCell {
                        ttvc.searchText = nil
                        if let tweet = imageCell.tweet {
                            ttvc.tweets = [[tweet]]
                        }
                    }
                }
                
            default: break
            }
        }
    }

}
