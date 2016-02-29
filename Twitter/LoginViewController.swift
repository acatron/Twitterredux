//
//  ViewController.swift
//  Twitter
//
//  Created by Aurielle on 2/20/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            if user != nil {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let hamburgerViewController = storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController") as!HamburgerViewController
                
                let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
                
                menuViewController.hamburgerViewController = hamburgerViewController
                hamburgerViewController.menuViewController = menuViewController
                
                self.presentViewController(hamburgerViewController, animated: false, completion: nil)
            } else {
                // handle login error
            }
        }
    }

}

