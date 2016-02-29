//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Aurielle on 2/21/16.
//  Copyright © 2016 Aurielel. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var tweet : Tweet?
    
    // Initialization Methods
    // ============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profileImageUrl = User.currentUser?.profileImageURL {
            self.profileImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
        }
        
        self.nameLabel.text = User.currentUser?.name
        self.screennameLabel.text = "@\(User.currentUser?.screenname ?? "")"
        
        if let tweet = self.tweet {
           self.tweetTextView.text = "@\(tweet.user?.screenname ?? "")"
        }
        self.tweetTextView.becomeFirstResponder()
    }

    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.updateStatusWithCompletion(self.tweetTextView.text) { (tweet, error) -> () in
            if tweet != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
