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
    
    struct Constants {
        static let Image = "Image"
        static let URLs = "URLs"
        static let Hashtag = "Hashtag"
        static let User = "User"
    }
    
    var currentTweet: Tweet? {
        didSet {
            if let tweet = currentTweet {
                if !tweet.media.isEmpty {
                    info.append(
                        Mention(
                            title: Constants.Image,
                            items: tweet.media.map( { .Image($0.url, $0.aspectRatio) })
                        )
                    )
                }
                if !tweet.urls.isEmpty {
                    info.append(
                        Mention(
                            title: Constants.URLs,
                            items: tweet.urls.map({ .Text($0.keyword) })
                        )
                    )
                }
                if !tweet.hashtags.isEmpty {
                    info.append(
                        Mention(
                            title: Constants.Hashtag,
                            items: tweet.hashtags.map({ .Text($0.keyword) })
                        )
                    )
                }
                var users = tweet.userMentions.map({ MentionItem.Text($0.keyword) })
                users.append(MentionItem.Text("@\(tweet.user.screenName)"))
                info.append(
                    Mention(
                        title: Constants.User,
                        items: users
                    )
                )
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
    
    struct Storyboard {
        static let imageCellIdentifier = "ImageTableCell"
        static let textCellIdentifier = "TextTableCell"
        
        static let showSearch = "Show Search"
        static let showImage = "Show Image"
        static let showWebpage = "Show Webpage"
        static let Unwind = "Unwind"
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
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.textCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = text
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.imageCellIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController
        if let navCon = destination as? UINavigationController {
            if let visible = navCon.visibleViewController {
                destination = visible
            }
        }
        switch segue.identifier! {
        case Storyboard.showSearch:
        if let ttvc = destination as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    ttvc.searchText = cell.textLabel?.text
                }
            }
        case Storyboard.showImage:
            if let imageCell = sender as? ImageTableViewCell {
                if let isvc = destination as? ImageScrollViewController {
                    if let image = imageCell.mentionImage?.image {
                        isvc.image = image
                        isvc.edgesForExtendedLayout = UIRectEdge.None;
                    }
                }
            }
        case Storyboard.showWebpage:
            if let url = sender as? NSURL {
                if let wvc = destination as? WebViewController {
                    wvc.webUrl = url
                }
            }
            default: break
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case Storyboard.showSearch:
            if let textCell = sender as? UITableViewCell {
                if let indexPath =  tableView.indexPathForCell(textCell) {
                    switch info[indexPath.section].title {
                    case Constants.Hashtag: fallthrough
                    case Constants.User:
                        return true
                    case Constants.URLs:
                        if let text = textCell.textLabel?.text {
                            if let url = NSURL(string: text) {
                                performSegueWithIdentifier(Storyboard.showWebpage, sender: url)
                            }
                        }
                    default: break
                    }
                }
            }
        case Storyboard.showImage:
            return true
        case Storyboard.showWebpage:
            return true
        case Storyboard.Unwind:
            print("here")
            return true
        default: break
        }
        return false
    }
}
