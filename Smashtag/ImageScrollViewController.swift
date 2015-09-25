//
//  ImageScrollViewController.swift
//  Smashtag
//
//  Created by Joe Isaacs on 24/09/2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController, UIScrollViewDelegate {
    
    private var imageView = UIImageView()
    
    private var scrollViewDidScrollOrZoom = false
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 3.0
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rescale()
    }
    
    private func rescale() {
        if let scroll = scrollView {
            if image != nil {
                scroll.zoomScale = max(scroll.bounds.size.height / image!.size.height,
                    scroll.bounds.size.width / image!.size.width)
                scroll.contentOffset = CGPoint(x: (imageView.frame.size.width - scroll.frame.size.width) / 2,
                    y: (imageView.frame.size.height - scroll.frame.size.height) / 2)
            }
        }
    }
  
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            if let newImage = newValue {
                imageView.image = newImage
                imageView.sizeToFit()
                scrollView?.contentSize = imageView.frame.size
                if scrollView != nil {
                    rescale()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
}