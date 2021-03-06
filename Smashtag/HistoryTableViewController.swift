//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Joe Isaacs on 24/09/2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    var mostRecentSearches: [String]?
    
    
    struct Storyboard {
        static let ShowSearch = "Show Search"
        static let HistoryTableCell = "HistoryTableCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController?.viewControllers.first as? HistoryTableViewController    {
            if nav == self {
                navigationItem.rightBarButtonItem = nil
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostRecentSearches?.count ?? 0
    }
    
    override func viewWillAppear(animated: Bool) {
        mostRecentSearches?.removeAll()
        mostRecentSearches = MostRecentTwitterSearchesDataSource.mostRecentTwitterSearches
        tableView.reloadData()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.HistoryTableCell, forIndexPath: indexPath)

        if let searches = mostRecentSearches {
            cell.textLabel?.text = searches[indexPath.row]
        }

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            MostRecentTwitterSearchesDataSource.deleteRow(indexPath.row)
            mostRecentSearches = MostRecentTwitterSearchesDataSource.mostRecentTwitterSearches

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
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
        case Storyboard.ShowSearch:
            if let ttvc = destination as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    ttvc.searchText = cell.textLabel?.text
                }
            }
        default: break
        }
    }
    
    @IBAction func unwindToRoot(sender: UIStoryboardSegue) { }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        if let first = navigationController?.viewControllers.first as? HistoryTableViewController {
            if first == self {
                return true
            }
        }
        return false
    }
}
