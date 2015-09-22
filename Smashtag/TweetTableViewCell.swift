//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!

    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil

        // load new information from our tweet (if any)

        if let tweet = self.tweet
        {
            if let var text = tweet.text {
            for _ in tweet.media {
                text += " 📷"
            }

            let newTweet = NSMutableAttributedString(string: text)

            newTweet.colorStringAtIndexs(UIColor.redColor(), indexs: tweet.hashtags)
            newTweet.colorStringAtIndexs(UIColor.blueColor(), indexs: tweet.urls)
            newTweet.colorStringAtIndexs(UIColor.orangeColor(), indexs: tweet.userMentions)

            tweetTextLabel?.attributedText = newTweet
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description

            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }

            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        }

    }

}


private extension NSMutableAttributedString {
    func colorStringAtIndexs(color: UIColor, indexs: [Tweet.IndexedKeyword]) {
        for index in indexs {
            addAttribute(NSForegroundColorAttributeName, value: color, range: index.nsrange)
        }
    }
}