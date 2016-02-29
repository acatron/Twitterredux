//
//  MenuViewController.swift
//  Twitter
//
//  Created by Aurielle on 2/27/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var profileNavigationController: UINavigationController!
    private var timelineNavigationController: UINavigationController!
    private var mentionsNavigationController: UINavigationController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
        
        timelineNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        
        let timelineViewController = timelineNavigationController.viewControllers.first as! TweetsViewController
        timelineViewController.controllerType = .Timeline
        
        let mentionsViewController = mentionsNavigationController.viewControllers.first as! TweetsViewController
        mentionsViewController.controllerType = .Mentions
        
        let profileViewController = profileNavigationController.viewControllers.first as! ProfileViewController
        profileViewController.user = User.currentUser
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        hamburgerViewController?.contentViewController = profileNavigationController
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath) as! MenuTableViewCell
        
        let titles = ["Profile", "Timeline", "Mentions"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController?.contentViewController = viewControllers[indexPath.row]
    }
}
