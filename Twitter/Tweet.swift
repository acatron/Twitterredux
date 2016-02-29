//
//  Tweet.swift
//  Twitter
//
//  Created by Aurielle on 2/20/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: String?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate
    
    var favorited: Bool?
    var favoriteCount: Int?

    var retweeted: Bool?
    var retweetCount: Int?

    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favorited = dictionary["favorited"] as? Bool
        favoriteCount = dictionary["favorite_count"] as? Int
        
        retweeted = dictionary["retweeted"] as? Bool
        retweetCount = dictionary["retweet_count"] as? Int
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)!
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
