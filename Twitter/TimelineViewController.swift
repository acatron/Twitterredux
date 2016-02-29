//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Rick Song on 2/21/16.
//  Copyright © 2016 Rick Song. All rights reserved.
//

import UIKit
import DateTools
import AFNetworking

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    
    // Initialization Methods
    // ============================
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
        
        tweetsTableViewCell.nameLabel.text = tweet.user!.name
        tweetsTableViewCell.createdAtLabel.text = "\(tweet.createdAt.shortTimeAgoSinceNow()) ago"
        tweetsTableViewCell.tweetLabel.text = tweet.text
        
        return tweetsTableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewController
        let tweet = self.tweets![indexPath.row]
        
        vc.tweet = tweet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func retrieveTweets(refreshControl: UIRefreshControl? = nil) {
        // Pull the tweets
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
            refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
}
