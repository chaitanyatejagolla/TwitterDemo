//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Golla, Chaitanya Teja on 4/16/17.
//  Copyright © 2017 Golla, Chaitanya Teja. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "YXovFgEdtohiSsj3fJgn0WaTw", consumerSecret: "AFCml5tTwqY2Yn3segEjRJ7y2j8mmOX4QtTABZZwXyXEPIMuIE")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error?) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        let twitterClient = TwitterClient.sharedInstance
        
        twitterClient.deauthorize()
        twitterClient.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print(requestToken)
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?) in
            print(error?.localizedDescription)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotificationName, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(
            withPath: "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential?) in
                
                self.currentAccount(success: { (user: User) in
                    
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error: Error?) in
                    self.loginFailure?(error)
                })
        },
            failure: { (error: Error?) in
                self.loginFailure?(error)
        }
        )
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get(
            "1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        )
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        get(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let dictionary = response as! NSDictionary
                let user = User(dictionary: dictionary)
                success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        )
    }
    
    func tweetStatus(tweet: Tweet, success: (Tweet) -> (), failure: @escaping (Error?) -> ()) {
        let params: NSDictionary = [
            "status": tweet.text!
        ]
        
        post(
            "1.1/statuses/update.json",
            parameters: params,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                print(response)
                //todo
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        )
    }
}

