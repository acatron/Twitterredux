//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Aurielle on 2/27/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profileImageUrl = user?.profileImageURL {
            profileImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
        }

        if let profileBackgroundImageUrl = user?.profileBackgroundImageURL {
            backgroundImageView.setImageWithURL(NSURL(string: profileBackgroundImageUrl)!)
        }
        
        nameLabel.text = user?.name
        screennameLabel.text = "@\(user?.screenname ?? "")"
        
        tweetsCountLabel.text = "\(user?.tweetsCount ?? 0)"
        followingCountLabel.text = "\(user?.followingCount ?? 0)"
        followersCountLabel.text = "\(user?.followersCount ?? 0)"
    }
}
