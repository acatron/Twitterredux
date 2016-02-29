//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Aurielle on 2/21/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var parentViewController: UIViewController?
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onProfileImageTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let storyboard = parentViewController?.storyboard
            let navigationController = parentViewController?.navigationController
            let profileViewController = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            
            profileViewController.user = user
            navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
}
