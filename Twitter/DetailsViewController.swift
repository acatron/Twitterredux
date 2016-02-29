//
//  DetailsViewController.swift
//  Twitter
//
//  Created by Aurielle on 2/21/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!

    var tweet : Tweet?
    
    // Initialization Methods
    // ============================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadTweet()
    }
    
    func reloadTweet() {
        if let profileImageUrl = self.tweet?.user?.profileImageURL {
            self.profileImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
        }
        
        self.nameLabel.text = self.tweet?.user?.name
        self.screennameLabel.text = "@\(self.tweet?.user?.screenname ?? "")"
        self.tweetLabel.text = self.tweet?.text
        
        self.favoritesCountLabel.text = "\(self.tweet?.favoriteCount ?? 0) Favorites"
        self.retweetCountLabel.text = "\(self.tweet?.retweetCount ?? 0) Retweets"
        
        if let createdAt = self.tweet?.createdAt {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .MediumStyle
            self.createdAtLabel.text = formatter.stringFromDate(createdAt)
        }
        
        if let favorited = self.tweet?.favorited {
            self.favoriteButton.enabled = !(favorited)
        }
        
        if let retweeted = self.tweet?.retweeted {
            self.retweetButton.enabled = !(retweeted)
        }
    }
    
    @IBAction func onProfileImageTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let profileViewController = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            
            profileViewController.user = tweet?.user
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ComposeViewController") as! ComposeViewController
        let nc = UINavigationController(rootViewController: vc)
        
        vc.tweet = self.tweet
        presentViewController(nc, animated: true, completion: nil)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.createRetweetWithCompletion(tweet!.id!) { (tweet, error) -> () in
            if tweet != nil {
                self.tweet?.retweetCount! += 1
                self.tweet?.retweeted! = true
                self.reloadTweet()
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.createFavoriteWithCompletion(tweet!.id!) { (tweet, error) -> () in
            if tweet != nil {
                self.tweet?.favoriteCount! += 1
                self.tweet?.favorited! = true
                self.reloadTweet()
            }
        }
    }
}
