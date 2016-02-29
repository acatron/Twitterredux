//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Aurielle on 2/21/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit
import DateTools
import AFNetworking

enum TweetsControllerType {
    case Timeline
    case Mentions
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var controllerType: TweetsControllerType?
    var tweets: [Tweet]?
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set up pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "retrieveTweets:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Retrieve tweets
        self.retrieveTweets()
    }
    
    // Table View Delegate Methods
    // ============================
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetsTableViewCell = tableView.dequeueReusableCellWithIdentifier("TweetsTableViewCell", forIndexPath: indexPath) as! TweetsTableViewCell
        let tweet = self.tweets![indexPath.row]
        
        if let profileImageUrl = tweet.user?.profileImageURL {
            tweetsTableViewCell.profileImage.setImageWithURL(NSURL(string: profileImageUrl)!)
        }
        
        tweetsTableViewCell.parentViewController = self
        tweetsTableViewCell.user = tweet.user!
        tweetsTableViewCell.nameLabel.text = tweet.user!.name
        tweetsTableViewCell.screennameLabel.text = tweet.user!.screenname
        tweetsTableViewCell.createdAtLabel.text = "\(tweet.createdAt.shortTimeAgoSinceNow()) ago"
        tweetsTableViewCell.tweetLabel.text = tweet.text
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: tweetsTableViewCell, action: "onProfileImageTap:")
        tweetsTableViewCell.profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        return tweetsTableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewController
        let tweet = self.tweets![indexPath.row]
        
        vc.tweet = tweet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func retrieveTweets(refreshControl: UIRefreshControl? = nil) {
        // Pull the tweets
        switch controllerType! {
        case .Timeline:
            TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                
                refreshControl?.endRefreshing()
            }
        case .Mentions:
            TwitterClient.sharedInstance.mentionsTimelineWithCompletion(nil) { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                
                refreshControl?.endRefreshing()
            }
        }
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
}
