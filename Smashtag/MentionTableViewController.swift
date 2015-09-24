//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by Joe Isaacs on 23/09/2015.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class MentionTableViewController: UITableViewController {
    
    // MARK: - Data Source
    
    var currentTweet: Tweet? {
        didSet {
            if let tweet = currentTweet {
                if !tweet.media.isEmpty {
                    info.append(
                        Mention(
                            title: "Image",
                            items: tweet.media.map( { .Image($0.url, $0.aspectRatio) })
                        )
                    )
                }
                if !tweet.urls.isEmpty {
                    info.append(
                        Mention(
                            title: "URLs",
                            items: tweet.urls.map({ .Text($0.keyword) })
                        )
                    )
                }
                if !tweet.hashtags.isEmpty {
                    info.append(
                        Mention(
                            title: "Hashtag",
                            items: tweet.hashtags.map({ .Text($0.keyword) })
                        )
                    )
                }
                if !tweet.userMentions.isEmpty {
                    info.append(
                        Mention(
                            title: "User",
                            items: tweet.userMentions.map({ .Text($0.keyword) })
                        )
                    )
                }
            }
        }
    }
    
    private struct Mention {
        let title: String
        let items: [MentionItem]
    }
    
    private enum MentionItem : CustomStringConvertible {
        case Text(String)
        case Image(NSURL, Double)
        
        
        var description: String {
            switch self {
            case .Image(let url, let aspectRatio):
                return "\(url) -> \(aspectRatio)"
            case Text(let value):
                return value
            }
        }
    }
    
    private var info = [Mention]()
    
    
    func updateUI() {
        
    }
    
    struct CellIdentifier {
        static let imageCellIdentifier = "ImageTableCell"
        static let textCellIdentifier = "TextTableCell"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // navigationItem.hidesBackButton = false
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return info.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info[section].items.count
    }
    
     override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return info[section].title
     }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch info[indexPath.section].items[indexPath.row] {
        case .Text(let text):
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.textCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = text
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.imageCellIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
            cell.imageURL = url
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         switch info[indexPath.section].items[indexPath.row] {
            case .Image(_, let aspectRatio):
                return tableView.bounds.size.width / CGFloat(aspectRatio)
            default:
                return UITableViewAutomaticDimension
         }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
