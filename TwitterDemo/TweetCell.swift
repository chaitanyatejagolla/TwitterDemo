//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Golla, Chaitanya Teja on 4/16/17.
//  Copyright © 2017 Golla, Chaitanya Teja. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            tweetTextLabel.text = tweet.text
            
            if let screenName = tweet.user?.screenName {
                screenNameLabel.text = "@\(screenName)"
            }
            
            if let profilePicUrl = tweet.user?.profileUrl {
                profilePic.setImageWith(profilePicUrl)
            }
            
            if let timestamp = tweet.timestamp {
                let timeDiff = abs(timestamp.timeIntervalSinceNow)
                
                if timeDiff > 86400 {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "mm/dd/yy"
                    timestampLabel.text = dateFormatter.string(from: timestamp)
                } else if timeDiff > 3600 {
                    let hours = Int(timeDiff/3600)
                    timestampLabel.text = "\(hours)h"
                } else {
                    let minutes = Int(timeDiff/60)
                    timestampLabel.text = "\(minutes)m"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePic.layer.cornerRadius = 4
        profilePic.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
