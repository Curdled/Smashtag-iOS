//
//  WebViewController.swift
//  Smashtag
//
//  Created by Joe Isaacs on 25/09/2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func backButton(sender: AnyObject) {
        webView?.goBack()
    }
    
    @IBOutlet weak var webView: UIWebView! {
        didSet {
            updateUI()
            webView.delegate = self
        }
    }
    
    
    var webUrl: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    var currentDownloads = 0
    
    func updateUI() {
        if let url = webUrl {
            if let view = webView {
                let request = NSURLRequest(URL: url)
                view.loadRequest(request)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - WebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        currentDownloads++
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        currentDownloads--
        if currentDownloads > 0 {
            spinner.stopAnimating()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
