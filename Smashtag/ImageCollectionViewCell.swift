//
//  ImageCollectionViewCell.swift
//  Smashtag
//
//  Created by Joe Isaacs on 25/09/2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            fetchData()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    weak var tableViewCache: NSCache?
    
    var url: NSURL? {
        didSet {
            fetchData()
        }
    }
    
    var tweet: Tweet?
    
    func fetchData() {
        if let URL = url {
            spinner.startAnimating()
            if let cache = tableViewCache {
                if let image = cache.objectForKey(URL) as? UIImage {
                    self.spinner.stopAnimating()
                    self.imageView.image = image
                }
            }
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                if let data = NSData(contentsOfURL: URL) {
                    NSThread.sleepForTimeInterval(1.0)
                    dispatch_async(dispatch_get_main_queue()) {
                        if URL == self.url {
                            self.spinner.stopAnimating()
                            if let image = UIImage(data: data) {
                                self.tableViewCache?.setObject(image, forKey: URL)
                                self.imageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}
