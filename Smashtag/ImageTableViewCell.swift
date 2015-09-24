//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Joe Isaacs on 23/09/2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var mentionImage: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var imageURL: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        mentionImage?.image = nil
        if let url = imageURL {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                if let data = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) {
                        if url == self.imageURL {
                            print(UIImage(data: data))
                            self.mentionImage.image = UIImage(data: data)
                            self.spinner?.stopAnimating()
                        }
                    }
                }
            }
        }
    }
}

extension UIImage
{
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}