//
//  User.swift
//  Twitter
//
//  Created by Aurielle on 2/20/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutinNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var tagline: String?
    
    var tweetsCount: Int?
    var followersCount: Int?
    var followingCount: Int?
    
    // User header
    var profileUseBackgroundImage: String?
    var profileBackgroundColor: String?
    var profileBackgroundImageURL: String?
    var profileBackgroundTile: String?
    var profileImageURL: String?
    var profileTextColor: String?
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        tweetsCount = dictionary["statuses_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        
        profileBackgroundColor = dictionary["profile_background_color"] as? String
        profileBackgroundImageURL = dictionary["profile_background_image_url"] as? String
        profileBackgroundTile = dictionary["profile_background_tile"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        profileTextColor = dictionary["profile_text_color"] as? String
        profileUseBackgroundImage = dictionary["profile_use_background_image"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        print("Error retrieving JSON")
        
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions(rawValue: 0))
                    
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print("Error parsing JSON")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
