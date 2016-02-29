//
//  TwitterClient.swift
//  Twitter
//
//  Created by Aurielle on 2/20/16.
//  Copyright © 2016 Aurielle. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "wyzOGl0teG9rqAnoajzjtFllx"
let twitterConsumerSecret = "vVVLeDS75ZtmjVqaNUxN65mWrwf06LYaU2kM9FCsZN5xWjzpHn"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret
            )
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        self.loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        self.requestSerializer.removeAccessToken()
        self.fetchRequestTokenWithPath("oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: { ( requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }, failure: { (error : NSError!) -> Void in
                print("Failed to get the request token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    func openURL(url: NSURL) {
        self.fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the access token")
                self.requestSerializer.saveAccessToken(accessToken)
                
                self.GET("1.1/account/verify_credentials.json",
                    parameters: nil,
                    success: { (operation: NSURLSessionDataTask, response: AnyObject) -> Void in
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        self.loginCompletion?(user: user, error: nil)
                    }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                    }
                )
            },
            failure: { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json",
            parameters: params,
            success: { (operation: NSURLSessionDataTask, response: AnyObject) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting timeline")
                completion(tweets: nil, error: error)
            }
        )
    }
    
    func mentionsTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/mentions_timeline.json",
            parameters: params,
            success: { (operation: NSURLSessionDataTask, response: AnyObject) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting timeline")
                completion(tweets: nil, error: error)
            }
        )
    }
    
    func updateStatusWithCompletion(status: String, inReplyToStatusId: String? = nil, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/statuses/update.json",
            parameters: [
                "status": status,
                "in_reply_to_status_id": inReplyToStatusId ?? ""
            ],
            success: { (operation: NSURLSessionDataTask, response: AnyObject) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error updating status")
                print(error.localizedDescription)
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func createFavoriteWithCompletion(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/favorites/create.json",
            parameters: ["id": id],
            success: { (operation: NSURLSessionDataTask, response: AnyObject) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error updating status")
                print(error.localizedDescription)
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func createRetweetWithCompletion(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/statuses/retweet/\(id).json",
            parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error updating status")
                print(error.localizedDescription)
                completion(tweet: nil, error: error)
            }
        )
    }
}
